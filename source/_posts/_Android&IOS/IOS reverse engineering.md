## Tools
| Tool | Functionality | Pre-requisite | 
| --- | --- | --- |
| iFunBox | Browse file system by USB | Mac |
| MachOView | View Match-O file structure | Mac |
| class-dump | After unpacking, export class definitions | Mac, cmdline |




## Methodologies
### Unpack .ipa file
Unpack by `unzip` cmd

### Detect shell
```
otool -l <mach-O> | grep crypt
```
Cryptid 0 stands for no shell, 1 for shell detected.


### Unpack shell
#### Unpack using frida-ios-dump
#### Unpack using Clutch
#### Unpack using 


## Tips

