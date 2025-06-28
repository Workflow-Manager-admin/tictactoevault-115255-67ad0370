-- Tic Tac Toe: Database Schema Definition
-- This file creates tables for User, Game, and Move in the application database.
-- Safe to run multiple times due to IF NOT EXISTS on CREATE TABLE.

-- Users: Stores all user profiles
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(100) NOT NULL UNIQUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Games: Records of each game session
CREATE TABLE IF NOT EXISTS games (
    id SERIAL PRIMARY KEY,
    player_x_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    player_o_id INTEGER REFERENCES users(id) ON DELETE SET NULL,
    winner_id INTEGER REFERENCES users(id) ON DELETE SET NULL,
    status VARCHAR(32) NOT NULL DEFAULT 'in_progress', -- values: in_progress, complete
    started_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    finished_at TIMESTAMPTZ
);

-- Moves: Each move in a game, one row per move
CREATE TABLE IF NOT EXISTS moves (
    id SERIAL PRIMARY KEY,
    game_id INTEGER NOT NULL REFERENCES games(id) ON DELETE CASCADE,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    move_number INTEGER NOT NULL, -- sequential index within each game (1 through max 9)
    row INTEGER NOT NULL CHECK (row BETWEEN 0 AND 2),
    col INTEGER NOT NULL CHECK (col BETWEEN 0 AND 2),
    symbol CHAR(1) NOT NULL CHECK (symbol IN ('X', 'O')),
    moved_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(game_id, move_number)
);

-- Optional: For rapid game queries, index moves by game
CREATE INDEX IF NOT EXISTS idx_moves_game_id ON moves(game_id);
