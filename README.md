# G - Grunnbeløp

![Linting](https://github.com/navikt/g/workflows/Linting/badge.svg)
![Testing](https://github.com/navikt/g/workflows/Testing/badge.svg)
![Build and deploy](https://github.com/navikt/g/workflows/Build%20and%20deploy/badge.svg)

G er tjenesten som gir deg dagens grunnbeløp!


## Spørsmål?

Opprett et issue eller send en e-post til Kyrre.Havik@nav.no.

### Lokal utvikling

Process-metrics (minne-forbruk osv.) støttes bare på Linux, `Dockerfile.Local` kan benyttes i stedet:

```shell
docker build -f Dockerfile.Local -t g .
docker run -p 8000:8000 g
```