# Modelo de dominio

## Conceptos
- Socio (email, nombre, cuota activa sí/no)
- Pista (nombre, estado: operativa | cerrada)
- Franja (pista, fecha, hora de inicio; 90 min)
- Reserva (socio, franja, estado: confirmada | cancelada | no presentada)
- Bloqueo (pista, rango de fechas, motivo)

## Reglas
- Una franja tiene como máximo una reserva confirmada.
- Un socio sin cuota activa no puede reservar.
- Un socio puede tener como máximo 2 reservas confirmadas futuras.
- Se puede cancelar hasta 24 h antes; después, solo el gestor.
- Las franjas bloqueadas o de pistas cerradas no se pueden reservar.

## Ciclo de vida de una reserva
confirmada → cancelada (socio ≥24 h antes, o gestor) · confirmada → no presentada (gestor, después de la franja)
