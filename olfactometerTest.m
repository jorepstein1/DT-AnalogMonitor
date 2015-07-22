%create TTLs for stimulation

dio = digitalio('mcc',1);
ttlLine = addline(dio,9:12,'out');
dtLine =  addline(dio,56:63,'out');
%turn TTL on
putvalue(ttlLine,uint8(0));
%turn TTL off
putvalue(dtLine,uint8(15));