#rm wsq_wrap.c
echo "WSQ"
swig -python -Wall -I../install_dir/include/ wsq.i &&
gcc -fPIC -Wall -shared wsq_wrap.c -o _wsq.so -L../install_dir/lib -lwsq -lioutil -lfet -ljpegl -lutil -I/usr/include/python2.7/ -lpython2.7 -I../install_dir/include/

echo "NFIQ"
swig -python -Wall -I../install_dir/include/ nfiq.i &&
gcc -fPIC -Wall -shared nfiq_wrap.c -o _nfiq.so -L../install_dir/lib -lnfiq -lmindtct -lmlp -lcblas -lioutil -lutil -I/usr/include/python2.7/ -lpython2.7 -I../install_dir/include/
