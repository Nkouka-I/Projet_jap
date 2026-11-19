-- Activation des clés étrangères (obligatoire à chaque connexion dans SQLite)
PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS kana (
    id_kana INTEGER PRIMARY KEY,
    caractere TEXT NOT NULL UNIQUE,
    type_kana TEXT NOT NULL CHECK (type_kana IN ('hiragana', 'katakana')),
    accent TEXT NOT NULL CHECK (accent IN ('aucun', 'dakuten', 'handakuten')),
    est_combinaison INTEGER NOT NULL DEFAULT 0 CHECK (est_combinaison IN (0, 1))
);

CREATE TABLE IF NOT EXISTS romaji (
    id_romaji INTEGER PRIMARY KEY,
    transcription TEXT NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS kana_romaji (
    id_kana INTEGER NOT NULL,
    id_romaji INTEGER NOT NULL,
    est_principal INTEGER NOT NULL DEFAULT 0 CHECK (est_principal IN (0, 1)),
    PRIMARY KEY (id_kana, id_romaji),
    FOREIGN KEY (id_kana) REFERENCES kana (id_kana)
        ON DELETE CASCADE,
    FOREIGN KEY (id_romaji) REFERENCES romaji (id_romaji)
        ON DELETE CASCADE
);