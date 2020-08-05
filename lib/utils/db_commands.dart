const CREATE_TABLE_NOTE = "CREATE VIRTUAL TABLE IF NOT EXISTS notes USING fts4("
    "note_id TEXT PRIMARY KEY, "
    "title TEXT, "
    "created_time DATETIME, "
    "modified_time DATETIME"
    ")";
const CREATE_TABLE_THUMBNAIL_NOTE = "CREATE TABLE IF NOT EXISTS thumbnails("
    "note_id TEXT PRIMARY KEY, "
    "title TEXT, "
    "type TEXT, "
    "color INTEGER, "
    "content TEXT, "
    "created_time DATETIME, "
    "modified_time DATETIME"
    ")";
const CREATE_TABLE_TAG = "CREATE VIRTUAL TABLE IF NOT EXISTS tags USING fts4("
    "tag_id TEXT PRIMARY KEY, "
    "title TEXT, "
    "color INTEGER, "
    "created_time DATETIME, "
    "modified_time DATETIME, "
    "UNIQUE(title)"
    ")";
const CREATE_TABLE_NOTE_ITEM = "CREATE VIRTUAL TABLE IF NOT EXISTS noteItems USING fts4("
    "noteItem_id TEXT PRIMARY KEY, "
    "note_id TEXT, "
    "content TEXT, "
    "type TEXT, "
    "note_color INTEGER, "
    "created_time DATETIME, "
    "modified_time DATETIME"
    ")";
const CREATE_TABLE_RELATIVE = "CREATE TABLE IF NOT EXISTS relatives("
    "note_id TEXT, "
    "tag_id TEXT"
    ")";
const DELETE_TAG ="DELETE FROM tags";
const DELETE_NOTE = "DELETE FROM notes";
const DELETE_NOTE_ITEM = "DELETE FROM noteItems";
const DELETE_RELATIVE = "DELETE FROM relatives";

const DROP_TABLE_TAG = "DROP TABLE IF EXISTS tags";
const DROP_TABLE_NOTE = "DROP TABLE IF EXISTS notes";
const DROP_TABLE_NOTE_ITEM = "DROP TABLE IF EXISTS noteItems";
const DROP_TABLE_RELATIVE = "DROP TABLE IF EXISTS relatives";
const DROP_TABLE_THUMBNAIL = "DROP TABLE IF EXISTS thumbnails";

const SELECT_TAG_RELATIVES_JOIN_TAGS =
    "SELECT *FROM relatives re INNER JOIN tags tg ON re.tag_id=tg.tag_id WHERE re.note_id=?";
const SELECT_NOTE_ITEMS=
    "SELECT *FROM noteItems WHERE note_id=?";
const SELECT_NOTES_BY_TAGID =
    "SELECT *FROM relatives re INNER JOIN notes no ON re.note_id=no.note_id WHERE re.tag_id=?";
const SELECT_THUMBNAILS_BY_TAGID =
    "SELECT note_id FROM relatives WHERE tag_id=?";

const FTS_NOTE_ITEM = "SELECT * FROM noteItems WHERE type = \"Text\" and content MATCH '";
const FTS_NOTE="SELECT * FROM notes WHERE title MATCH '";
const FTS_TAG="SELECT * FROM tags WHERE title MATCH ?";
const COUNT = "SELECT COUNT(*) FROM ?";