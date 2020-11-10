# Conceptos generales

Como decía la consiga el sistema almacenará los cuadernos en la carpeta .my_rns en el home del usuario que está trabajando. En caso de no existir este se creará y también el cuaderno global que va a contener todas las notas que no son asignadas a ningún cuaderno

Tanto para los cuadernos como para las notas se debe tener en cuenta que no se permiten carácteres especiales en los nombres. Sólo se permiten títulos que contengan letras, números y espacios. 

# Creando cuadernos y notas

Este comando nos creará un cuaderno. Si el mismo ya existe o no contiene un nombre válido se nos avisará del problema.

```bash
$ ruby bin/rn b create "Nuevo Cuaderno"
```

Ahora al momento de crear una nota podemos optar por dos maneras, indicandole el cuaderno donde queremos que se guarde o no indicandole nada y guardandolo en nuestro cuaderno global. Este es un ejemplo donde creamos una nota global:

```bash
$ ruby bin/rn n create "Nota en global"
```

Y en este caso le indicamos el cuaderno en el que deseamos que se guarde

```bash
$ ruby bin/rn b create "Nota de cuaderno" --book "Nuevo Cuaderno"
```

Si la nota tiene un nombre válido y no existe todavía. Se creará y se nos ofrecerá la selección de un editor de texto para completar el contenido de la misma.

```bash
Select an editor? 
  1) vi
  2) nano
  3) pico
  Choose 1-3 [1]: 
  ```




