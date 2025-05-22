# G - Grunnbeløp

![Linting](https://github.com/navikt/g/workflows/Linting/badge.svg)
![Testing](https://github.com/navikt/g/workflows/Testing/badge.svg)
![Build and deploy](https://github.com/navikt/g/workflows/Build%20and%20deploy/badge.svg)

G er tjenesten som gir deg dagens grunnbeløp!


## Spørsmål?

Opprett et issue eller send en e-post til Kyrre.Havik@nav.no.


## Utregninger

Kan også bare kjøre `ruby calc.rb Ny-G Forrige-G`.

### Gjennomsnitt per år

```
(G fra året før / 12) * 4
+
(Ny G / 12) * 8
```

### Omregningsfaktor

```
Ny G / Fjorårets G
```
