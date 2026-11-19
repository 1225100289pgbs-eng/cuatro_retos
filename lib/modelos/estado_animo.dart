/// Estado de ánimo del usuario y el género de TMDB que le corresponde.
/// generoId null = tendencias de la semana.
enum EstadoAnimo {
  tendencias('Tendencias', '🔥', null),
  feliz('Feliz', '😄', 35), // Comedia
  aventurero('Aventurero', '🤠', 12), // Aventura
  romantico('Romántico', '💘', 10749), // Romance
  miedo('Quiero miedo', '👻', 27), // Terror
  pensativo('Pensativo', '🤔', 18), // Drama
  nostalgico('Nostálgico', '🎨', 16); // Animación

  const EstadoAnimo(this.etiqueta, this.emoji, this.generoId);
  final String etiqueta;
  final String emoji;
  final int? generoId;
}
