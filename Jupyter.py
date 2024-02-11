#!/usr/bin/env python
# coding: utf-8

# In[1]:


#importiamo le librerie
import pynq
from pynq import Overlay
from pynq import allocate
import numpy as np
import random
import time


# In[2]:


#importiamo il nostro overlay
overlay = Overlay('/home/xilinx/pynq/overlays/Merge/Merge.bit')


# In[3]:


get_ipython().run_line_magic('pinfo', 'overlay')


# In[4]:


dma = overlay.axi_dma_0


# In[5]:


get_ipython().run_line_magic('pinfo', 'dma')


# In[6]:


dma_send = overlay.axi_dma_0.sendchannel
dma_recv = overlay.axi_dma_0.recvchannel


# In[7]:


#allochiamo il vettore input_buffer
data_size = 32
input_buffer = allocate(shape=(data_size,), dtype=np.uint32)


# In[8]:


#salviamo un set di dati nel vettore input_buffer da inviare successivamente alla dma
for i in range(data_size):
    input_buffer[i] = random.randrange(1, 512, 1)


# In[9]:


for i in range(0, data_size):
    print(input_buffer[i])


# In[10]:


#allochiamo l'output buffer
output_buffer = allocate(shape=(data_size,), dtype=np.uint32)


# In[11]:


print("Input buffer address   :", hex(input_buffer.physical_address))
print("Output buffer address  :", hex(output_buffer.physical_address))
print("---")
print("DMA Source address     :", hex(dma.register_map.MM2S_SA.Source_Address))
print("DMA Destination address:", hex(dma.register_map.S2MM_DA.Destination_Address))


# In[12]:


start_time = time.time()


# In[13]:


#mandiamo l'input alla dma
dma_send.transfer(input_buffer)
dma.sendchannel.wait()


# In[14]:


#trasferiamo lo stream di dati nel vettore di output e stampiamone i valori
dma.recvchannel.transfer(output_buffer)
dma.recvchannel.wait()

for i in range(6, data_size):
    print(output_buffer[i])

dma.recvchannel.transfer(output_buffer)
dma.recvchannel.wait()

end_time = time.time()

for i in range(0,4):
    print(output_buffer[i])


# In[15]:


del input_buffer, output_buffer


# In[16]:


elapsed_time = end_time - start_time
print(f"Conversion time: {elapsed_time} s")

