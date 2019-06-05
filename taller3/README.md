# Taller raster

## Propósito

Comprender algunos aspectos fundamentales del paradigma de rasterización.

## Tareas

Emplee coordenadas baricéntricas para:

1. Rasterizar un triángulo.
2. Sombrear su superficie a partir de los colores de sus vértices.
3. (opcional para grupos menores de dos) Implementar un [algoritmo de anti-aliasing](https://www.scratchapixel.com/lessons/3d-basic-rendering/rasterization-practical-implementation/rasterization-practical-implementation) para sus aristas.

Referencias:

* [The barycentric conspiracy](https://fgiesen.wordpress.com/2013/02/06/the-barycentric-conspirac/)
* [Rasterization stage](https://www.scratchapixel.com/lessons/3d-basic-rendering/rasterization-practical-implementation/rasterization-stage)

Implemente la función ```triangleRaster()``` del sketch adjunto para tal efecto, requiere la librería [nub](https://github.com/nakednous/nub/releases).

## Integrantes

Complete la tabla:

| Integrante | github nick |
|------------|-------------|
| Jhon Torres | jhont285 |
| Dago Fonseca | dagofonseca |
| Camilo Pinzon | capinzonr |

## Discusión

Describa los resultados obtenidos. En el caso de anti-aliasing describir las técnicas exploradas, citando las referencias.

Se utilizaron cuatro muestras por pixel, para esto se dividió el pixel en cuatro subpixeles y se verificaba si el centro de los subpixeles se encontraban dentro el triángulo. Dependiendo del número de subpixeles que se encontrarán dentro del tiragulo se asignaba un valor alpha al color del pixel. Si todos los subpixeles se encuentran dentro del triangulo alpha tomaba el valor de 255, lo que significa una opacidad de 100% mientras que si ningun subpixel estaba dentro del triángulo alpha tomaba el valor de 0 lo que significa transparencia total.

### Sin anti-aliazing.

![noAtialiasing](/taller3/images/noAntialising.png)

### Con anti-aliazing.

![antialising](/taller3/images/antiAliasing.png)

## Entrega

* Plazo: 2/6/19 a las 24h.
