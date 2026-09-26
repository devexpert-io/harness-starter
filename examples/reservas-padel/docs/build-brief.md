# Build Brief

## Problema
El club gestiona las reservas por WhatsApp y una hoja de cálculo. Hay dobles reservas, pistas vacías por cancelaciones que nadie ve y el gestor pierde unas 5 horas a la semana.

## Solución actual
Grupo de WhatsApp + Google Sheets compartida con el gestor.

## Usuarios
- Socios (unos 300), sobre todo desde el móvil.
- Gestor (1–2 personas), desde el ordenador.

## Objetivos
- Un socio reserva una franja libre en menos de 1 minuto.
- Cero dobles reservas.
- Las cancelaciones liberan la franja al instante.

## Fuera de alcance (MVP)
- Pagos online.
- Torneos, ligas y clases.
- App nativa (será web responsive).

## MVP
Web responsive donde el socio inicia sesión con enlace mágico por email, ve la disponibilidad de la semana, reserva y cancela (hasta 24 h antes). El gestor da de alta socios, configura pistas y horario, y bloquea franjas por mantenimiento.

## Validación
Piloto de 2 semanas con 30 socios y la Pista 1.

## Criterios de éxito
Ninguna doble reserva en el piloto; el 80% de las reservas del piloto se hacen en la web.

## Notas
Stack propuesto: Next.js + PostgreSQL. Aún sin decidir hosting.
