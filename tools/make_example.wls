(* Regenerate all example material for the ICSC 2026 paper from
   temporal-system itself:

     figures/timeline_export.pdf|png   timeline figure (Fig. 2)
     example/timeline_example.csd|wav  Csound rendering of the same stemData
     example/click_track.csd|wav       click track quoted in Sect. 5
     example/notes.csd                 one-note rendering quoted in Sect. 4

   Run with:  wolframscript -file tools/make_example.wls            *)

repoRoot = "/Users/master/Documents/GitHub/temporal-system";
paperRoot = DirectoryName[DirectoryName[ExpandFileName[$InputFileName]]];
figDir = FileNameJoin[{paperRoot, "figures"}];
exDir = FileNameJoin[{paperRoot, "example"}];
SetDirectory[repoRoot];
Scan[If[!DirectoryQ[#], CreateDirectory[#]] &, {figDir, exDir}];

Get[FileNameJoin[{repoRoot, "core", "entities.wl"}]];
Get[FileNameJoin[{repoRoot, "core", "stemData.wl"}]];
Get[FileNameJoin[{repoRoot, "core", "tempoMap.wl"}]];
Get[FileNameJoin[{repoRoot, "core", "session.wl"}]];
Get[FileNameJoin[{repoRoot, "util", "pitch.wl"}]];
Get[FileNameJoin[{repoRoot, "util", "dynamics.wl"}]];
Get[FileNameJoin[{repoRoot, "util", "timeline.wl"}]];
Get[FileNameJoin[{repoRoot, "rendering", "renderer.wl"}]];
Get[FileNameJoin[{repoRoot, "rendering", "csound.wl"}]];
Get[FileNameJoin[{repoRoot, "rendering", "click.wl"}]];

csoundBinary = SelectFirst[
  {"/usr/local/bin/csound", "/opt/homebrew/bin/csound"}, FileExistsQ, "csound"];

(* ============================================================
   1. The timeline example: harmonics 2-9 of A2 on sine_osc.
      Beat unit = one quarter note in the timeline display.     *)

sd = TemporalSystem`StemData`emptyStemData[];
add[e_] := (sd = TemporalSystem`StemData`addEntity[sd, e];
  If[sd === $Failed, Print["addEntity failed: ", e]; Exit[1]]);

add[TemporalSystem`Entities`makeMeter["m1", 0, 4, 4]];
add[TemporalSystem`Entities`makeMeter["m2", 8, 3, 4]];

mkNote[id_, onset_, pitch_, dur_, dyn_] := TemporalSystem`Entities`makeNote[
  id, onset, pitch, dur, dyn,
  "rendering" -> <|
    "csound" -> <|"instrument" -> "sine_osc"|>,
    "musicxml" -> <|"instrument" -> "sine_osc"|>
  |>
];

add[mkNote["n1", 0, {"A3", 0}, 1, "p"]];
add[mkNote["n2", 1, {"E4", 2}, 1, "p"]];
add[mkNote["n3", 2, {"A4", 0}, 1, "mp"]];
add[mkNote["n4", 3, {"C#5", -14}, 1, "mp"]];
add[mkNote["n5", 4, {"E5", 2}, 2, "mf"]];
add[mkNote["n6", 6, {"G5", -31}, 2, "mf"]];
add[mkNote["n7", 8, {"A5", 0}, 3, "f"]];
add[mkNote["n8", 11, {"B5", 4}, 3, "f"]];

add[TemporalSystem`Entities`makeCurve["c1", 0, "amplitude", 8,
  {"linear", {{0, 0.15}, {4, 0.9}, {8, 0.3}}}]];
add[TemporalSystem`Entities`makeTrigger["t1", 4, "reverb", "enable", {0.35}]];
add[TemporalSystem`Entities`makeMarker["mk1", 0, "A"]];
add[TemporalSystem`Entities`makeMarker["mk2", 8, "B"]];

(* one displayed beat (a quarter) lasts 0.5 s, i.e. 120 BPM *)
tm = TemporalSystem`TempoMap`makeTempoMap[{{0, 0.}, {16, 8.}}];

g = TemporalSystem`Timeline`drawTimeline[sd, tm];
If[Head[g] =!= Graphics, Print["drawTimeline did not return Graphics"]; Exit[1]];
Export[FileNameJoin[{figDir, "timeline_export.pdf"}], g];
Export[FileNameJoin[{figDir, "timeline_export.png"}], g, ImageResolution -> 300];
Print["written: figures/timeline_export.pdf|png"];

(* Audio bounce of the same store: notes and meters only (the curve and
   the trigger address control-rate and realtime targets, not p-fields). *)
sdAudio = Join[
  TemporalSystem`StemData`emptyStemData[],
  KeyTake[sd, {"note", "state"}]
];

config = TemporalSystem`Session`makeSessionConfig[
  "sampleRate" -> 44100,
  "instrumentsDir" -> FileNameJoin[{repoRoot, "instruments"}],
  "csoundBinary" -> csoundBinary,
  "csoundCompileOnExport" -> True
];
registry = TemporalSystem`Session`loadOrchRegistry[config];
If[registry === $Failed, Print["registry failed"]; Exit[1]];

allEntities[stem_] := Flatten[Values /@ Values[stem], 1];
prims = DeleteMissing[
  TemporalSystem`Csound`renderEntityToCSnd[#, tm, registry, config] & /@
    allEntities[sdAudio]
];
result = TemporalSystem`Csound`serializeCSnd[
  prims, config, registry, FileNameJoin[{exDir, "timeline_example.csd"}]];
If[!AssociationQ[result] || result["compiled"] =!= True,
  Print["timeline_example compile failed"]; Exit[1]];
Print["written: example/timeline_example.csd|wav"];

(* ============================================================
   2. The click track quoted in the paper: two 4/4 bars at 120 BPM.
      Whole-note beat space: one 4/4 bar = 1.                     *)

sdClick = TemporalSystem`StemData`emptyStemData[];
sdClick = TemporalSystem`StemData`addEntity[sdClick,
  TemporalSystem`Entities`makeMeter["m1", 0, 4, 4]];
sdClick = TemporalSystem`StemData`addEntity[sdClick,
  TemporalSystem`Entities`makeNote["n1", 0, {"A4", 0}, 2, "mf",
    "rendering" -> <|"csound" -> <|"instrument" -> "sine_osc", "p6" -> 0.5|>|>]];
tempoClick = TemporalSystem`TempoMap`makeTempoSpec[{{0, 120.}}];

clickPrims = TemporalSystem`Click`renderClickTrack[
  sdClick, tempoClick, registry, config];
If[clickPrims === $Failed, Print["click render failed"]; Exit[1]];
clickResult = TemporalSystem`Click`serializeClickCSnd[
  clickPrims, config, registry, FileNameJoin[{exDir, "click_track.csd"}]];
If[!AssociationQ[clickResult] || clickResult["compiled"] =!= True,
  Print["click_track compile failed"]; Exit[1]];
Print["written: example/click_track.csd|wav"];

(* One-note Csound rendering quoted in Sect. 4 (no audio needed). *)
notesCsd = TemporalSystem`Renderer`renderTo[
  sdClick, tempoClick, TemporalSystem`Csound`csoundBackend,
  Join[config, <|"csoundCompileOnExport" -> False|>], registry];
If[!StringQ[notesCsd], Print["notes renderTo failed"]; Exit[1]];
Export[FileNameJoin[{exDir, "notes.csd"}], notesCsd, "Text"];
Print["written: example/notes.csd"];
