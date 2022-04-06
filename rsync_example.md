
# 如果服务器起了rsync服务，并配置了ftp
- 命令
```
echo “password" | rsync -rvzP  --exclude client --exclude ".svn" --chmod=ug=rwx --chmod=o-rx . ftp@175.178.56.166::ftp/otf 
```

# 如果直接使用ssh拷贝
- 命令, /home/git/rsync_upload必须预先存在，
- 由于linux和windows的权限表达不同， 需要加上设置--chmod=766
```
rsync -e "ssh -i C:/Users/xiaol.luo/.ssh/all_keys/app_key/id_rsa -p 22 -o \"StrictHostKeyChecking no\" " --chmod=755 -avzP . git@175.178.56.166:/home/git/rsync_upload
```

- 如果每次都需要你确认是否connect，可通过 -o "StrictHostKeyChecking no"  取消弹出确认connect

```
rsync -e "ssh -i C:/Users/xiaol.luo/.ssh/all_keys/app_key/id_rsa -p 22  -o \"StrictHostKeyChecking no\" " --chmod=755 -avzP . git@175.178.56.166:/home/git/rsync_upload
```


- 注意单冒号和双冒号