

while aws detach-volume $1 | grep detaching
do sleep 2
done

aws delete-volume $1
echo 'Deleted'

