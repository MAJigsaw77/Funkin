package funkin.ui.debug.charting;

import funkin.play.song.SongData.SongEventData;
import funkin.play.song.SongData.SongNoteData;
import flixel.math.FlxMath;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;

/**
 * Handles the note scrollbar preview in the chart editor.
 */
class ChartEditorNotePreview extends FlxSprite
{
  //
  // Constants
  //
  static final NOTE_WIDTH:Int = 5;
  static final NOTE_HEIGHT:Int = 1;
  static final WIDTH:Int = NOTE_WIDTH * 9;

  static final BG_COLOR:FlxColor = FlxColor.GRAY;
  static final LEFT_COLOR:FlxColor = 0xFFFF22AA;
  static final DOWN_COLOR:FlxColor = 0xFF00EEFF;
  static final UP_COLOR:FlxColor = 0xFF00CC00;
  static final RIGHT_COLOR:FlxColor = 0xFFCC1111;
  static final EVENT_COLOR:FlxColor = 0xFF111111;

  var previewHeight:Int;

  public function new(height:Int)
  {
    super(0, 0);
    this.previewHeight = height;
    buildBackground();
  }

  /**
   * Build the initial sprite for the preview.
   */
  function buildBackground():Void
  {
    makeGraphic(WIDTH, 0, BG_COLOR);
  }

  /**
   * Erase all notes from the preview.
   */
  public function erase():Void
  {
    drawRect(0, 0, WIDTH, previewHeight, BG_COLOR);
  }

  /**
   * Add a single note to the preview.
   * @param note The data for the note.
   * @param songLengthInMs The total length of the song in milliseconds.
   */
  public function addNote(note:SongNoteData, songLengthInMs:Int):Void
  {
    var noteDir:Int = note.getDirection();
    var mustHit:Bool = note.getStrumlineIndex() == 0;
    drawNote(noteDir, mustHit, Std.int(note.time), songLengthInMs);
  }

  /**
   * Add a song event to the preview.
   * @param event The data for the event.
   * @param songLengthInMs The total length of the song in milliseconds.
   */
  public function addEvent(event:SongEventData, songLengthInMs:Int):Void
  {
    drawNote(-1, false, Std.int(event.time), songLengthInMs);
  }

  /**
   * Add an array of notes to the preview.
   * @param notes The data for the notes.
   * @param songLengthInMs The total length of the song in milliseconds.
   */
  public function addNotes(notes:Array<SongNoteData>, songLengthInMs:Int):Void
  {
    for (note in notes)
    {
      addNote(note, songLengthInMs);
    }
  }

  /**
   * Add an array of events to the preview.
   * @param events The data for the events.
   * @param songLengthInMs The total length of the song in milliseconds.
   */
  public function addEvents(events:Array<SongEventData>, songLengthInMs:Int):Void
  {
    for (event in events)
    {
      addEvent(event, songLengthInMs);
    }
  }

  /**
   * Draws a note on the preview.
   * @param dir Note data.
   * @param mustHit False if opponent, true if player.
   * @param strumTimeInMs Time in milliseconds to strum the note.
   * @param songLengthInMs Length of the song in milliseconds.
   */
  function drawNote(dir:Int, mustHit:Bool, strumTimeInMs:Int, songLengthInMs:Int):Void
  {
    var color:FlxColor = switch (dir)
    {
      case 0: LEFT_COLOR;
      case 1: DOWN_COLOR;
      case 2: UP_COLOR;
      case 3: RIGHT_COLOR;
      default: EVENT_COLOR;
    };

    var noteX:Float = NOTE_WIDTH * dir;
    if (mustHit) noteX += NOTE_WIDTH * 4;
    if (dir == -1) noteX = NOTE_WIDTH * 8;

    var noteY:Float = FlxMath.remapToRange(strumTimeInMs, 0, songLengthInMs, 0, previewHeight);

    drawRect(noteX, noteY, NOTE_WIDTH, NOTE_HEIGHT, color);
  }

  function eraseNote(dir:Int, mustHit:Bool, strumTimeInMs:Int, songLengthInMs:Int):Void
  {
    var noteX:Float = NOTE_WIDTH * dir;
    if (mustHit) noteX += NOTE_WIDTH * 4;
    if (dir == -1) noteX = NOTE_WIDTH * 8;

    var noteY:Float = FlxMath.remapToRange(strumTimeInMs, 0, songLengthInMs, 0, previewHeight);

    drawRect(noteX, noteY, NOTE_WIDTH, NOTE_HEIGHT, BG_COLOR);
  }

  inline function drawRect(noteX:Float, noteY:Float, width:Int, height:Int, color:FlxColor):Void
  {
    FlxSpriteUtil.drawRect(this, noteX, noteY, width, height, color);
  }
}