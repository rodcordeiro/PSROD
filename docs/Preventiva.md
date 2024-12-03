---
external help file: rod-help.xml
Module Name: psrod
online version: https://github.com/rodcordeiro/PSROD/blob/main/Public/Authoral/Preventive.ps1
schema: 2.0.0
---

# Preventiva

## SYNOPSIS
Execute preventive scripts

## SYNTAX

```
Preventiva [-Complete] [-Cleaner] [-DiskEvents] [-Updates] [-Reboot]
```

## DESCRIPTION
Execute preventive scripts on computer, cleaning temp files, trash and running recover tools.

## EXAMPLES

### EXEMPLO 1
```
./Preventiva
```

### EXEMPLO 2
```
./Preventiva -Complete
```

### EXEMPLO 3
```
./Preventiva -Cleaner
```

### EXEMPLO 4
```
./Preventiva -DiskEvents
```

### EXEMPLO 5
```
./Preventiva -Updates
```

### EXEMPLO 6
```
./Preventiva -Updates -Reboot
```

## PARAMETERS

### -Complete
Executa o processo completo, incluindo dism, sfc, instala § £o de atualiza § µes e limpeza.
Caso o reboot seja passado, a limpeza n £o ser ¡ executada.;

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Cleaner
Executa apenas a limpeza;

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -DiskEvents
Verifica se h ¡ eventos de disco;

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Updates
Executa a instala § £o de atualiza § µes;

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Reboot
Reinicia o computador ao finalizar a execu § £o do script

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES
Author: Rodrigo M.
Cordeiro

## RELATED LINKS

[https://github.com/rodcordeiro/PSROD/blob/main/Public/Authoral/Preventive.ps1](https://github.com/rodcordeiro/PSROD/blob/main/Public/Authoral/Preventive.ps1)

