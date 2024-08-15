-- Index the name and score columns in the names table.
-- The index should be named idx_name_score.
CREATE INDEX idx_name_first_score
ON names (name(1), score(1));
