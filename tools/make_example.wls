(* Regenerate all example material for the ICSC 2026 paper from
   temporal-system itself. The main example is the most complex stemData
   of the paclet's Csound test suite (tests/test_csound.nb, Test 7):
   two instruments, four meter signatures, four triggers and six curves
   with composed p-field bindings.

     figures/timeline_export.pdf|png     timeline figure (Fig. 2)
     example/timeline_example.csd|wav    Csound rendering of the same stemData
     example/timeline_example_click.csd|wav  its click track (1/8 grid)
     example/paper_click.csd             minimal click quoted in Sect. 5
     example/paper_note.csd              one-note rendering quoted in Sect. 4
     example/paper_curve_osc.json        OSC ramp quoted in Sect. 4

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
Get[FileNameJoin[{repoRoot, "rendering", "osc.wl"}]];

csoundBinary = SelectFirst[
  {"/usr/local/bin/csound", "/opt/homebrew/bin/csound"}, FileExistsQ, "csound"];

add[e_] := (sd = TemporalSystem`StemData`addEntity[sd, e];
  If[sd === $Failed, Print["addEntity failed: ", e]; Exit[1]]);
mkNote[id_, onset_, pitch_, dur_, dyn_, csound_] :=
  TemporalSystem`Entities`makeNote[id, onset, pitch, dur, dyn,
    "rendering" -> <|"csound" -> csound|>];

(* ============================================================
   1. Test 7 stemData: whole-note beat space, 13/2 beats at 96 BPM. *)

cfg = TemporalSystem`Session`makeSessionConfig[
  "csoundCurveBindings" -> <|
    "amplitude" -> <|"pfield" -> "p5", "mode" -> "multiply"|>,
    "ampScale"  -> <|"pfield" -> "p5", "mode" -> "multiply"|>,
    "panSweep"  -> <|"pfield" -> "p6", "mode" -> "replace"|>,
    "panDepth"  -> <|"pfield" -> "p6", "mode" -> "multiply"|>
  |>,
  "clickBeatUnit" -> 1/8,
  "clickDuration" -> 1/32,
  "sampleRate" -> 44100,
  "instrumentsDir" -> FileNameJoin[{repoRoot, "instruments"}],
  "csoundBinary" -> csoundBinary,
  "csoundCompileOnExport" -> True
];
tempo = TemporalSystem`TempoMap`makeTempoSpec[{{0, 96.}}];

sd = TemporalSystem`StemData`emptyStemData[];
add[TemporalSystem`Entities`makeMeter["m1", 0, 4, 4]];
add[TemporalSystem`Entities`makeMeter["m2", 2, 5, 8]];
add[TemporalSystem`Entities`makeMeter["m3", 13/4, 7, 8]];
add[TemporalSystem`Entities`makeMeter["m4", 5, 3, 4]];
add[TemporalSystem`Entities`makeMarker["mkIntro", 0, "4-4 opening"]];
add[TemporalSystem`Entities`makeMarker["mkFive", 2, "5-8 rotation"]];
add[TemporalSystem`Entities`makeMarker["mkSeven", 13/4, "7-8 expansion"]];
add[TemporalSystem`Entities`makeMarker["mkCoda", 5, "3-4 coda"]];

add[mkNote["lead1", 0, {"A4", 0}, 1/4, "mp", <|"instrument" -> "sine_osc", "p6" -> 0.15, "p7" -> 0.20|>]];
add[mkNote["lead2", 1/8, {"C5", 0}, 3/8, "mf", <|"instrument" -> "sine_osc", "p6" -> 0.35, "p7" -> 0.45|>]];
add[mkNote["lead3", 1/2, {"E5", 25}, 1/4, "f", <|"instrument" -> "sine_osc", "p6" -> 0.80, "p7" -> 0.30|>]];
add[mkNote["lead4", 3/4, {"G4", -12}, 1/2, "p", <|"instrument" -> "sine_osc", "p6" -> 0.20, "p7" -> 0.65|>]];
add[mkNote["lead5", 5/4, {"B4", 0}, 3/8, "mf", <|"instrument" -> "sine_osc", "p6" -> 0.55, "p7" -> 0.25|>]];
add[mkNote["lead6", 13/8, {"D5", 0}, 1/4, "f", <|"instrument" -> "sine_osc", "p6" -> 0.75, "p7" -> 0.35|>]];
add[mkNote["lead7", 2, {"F5", -20}, 5/16, "mp", <|"instrument" -> "sine_osc", "p6" -> 0.10, "p7" -> 0.50|>]];
add[mkNote["lead8", 37/16, {"A5", 0}, 5/16, "mf", <|"instrument" -> "sine_osc", "p6" -> 0.35, "p7" -> 0.40|>]];
add[mkNote["lead9", 21/8, {"C6", 15}, 5/16, "f", <|"instrument" -> "sine_osc", "p6" -> 0.65, "p7" -> 0.30|>]];
add[mkNote["lead10", 47/16, {"E5", 0}, 1/4, "p", <|"instrument" -> "sine_osc", "p6" -> 0.85, "p7" -> 0.70|>]];
add[mkNote["lead11", 13/4, {"G5", 0}, 7/16, "mf", <|"instrument" -> "sine_osc", "p6" -> 0.25, "p7" -> 0.45|>]];
add[mkNote["lead12", 59/16, {"B5", -10}, 7/16, "f", <|"instrument" -> "sine_osc", "p6" -> 0.60, "p7" -> 0.25|>]];
add[mkNote["lead13", 33/8, {"D6", 0}, 1/2, "mp", <|"instrument" -> "sine_osc", "p6" -> 0.90, "p7" -> 0.55|>]];
add[mkNote["lead14", 37/8, {"F5", 0}, 3/8, "mf", <|"instrument" -> "sine_osc", "p6" -> 0.40, "p7" -> 0.35|>]];
add[mkNote["lead15", 5, {"A4", 0}, 3/4, "f", <|"instrument" -> "sine_osc", "p6" -> 0.20, "p7" -> 0.60|>]];
add[mkNote["lead16", 23/4, {"E5", 25}, 3/4, "mp", <|"instrument" -> "sine_osc", "p6" -> 0.80, "p7" -> 0.20|>]];

add[mkNote["perc1", 0, {"C6", 0}, 1/16, "mf", <|"instrument" -> "click"|>]];
add[mkNote["perc2", 1/2, {"G5", 0}, 1/16, "f", <|"instrument" -> "click"|>]];
add[mkNote["perc3", 1, {"C6", 0}, 1/16, "mp", <|"instrument" -> "click"|>]];
add[mkNote["perc4", 3/2, {"G5", 0}, 1/16, "f", <|"instrument" -> "click"|>]];
add[mkNote["perc5", 2, {"C6", 0}, 1/16, "mf", <|"instrument" -> "click"|>]];
add[mkNote["perc6", 21/8, {"G5", 0}, 1/16, "f", <|"instrument" -> "click"|>]];
add[mkNote["perc7", 13/4, {"C6", 0}, 1/16, "mf", <|"instrument" -> "click"|>]];
add[mkNote["perc8", 5, {"G5", 0}, 1/16, "f", <|"instrument" -> "click"|>]];

add[TemporalSystem`Entities`makeTrigger["trClick", 1/4, "click", "accent", {1760., 0.70}]];
add[TemporalSystem`Entities`makeTrigger["trClick2", 9/4, "click", "accent", {1320., 0.55}]];
add[TemporalSystem`Entities`makeTrigger["trLead", 5/4, "sine_osc", "accent", {660., 0.25, 0.75, 0.20}]];
add[TemporalSystem`Entities`makeTrigger["trLead2", 21/4, "sine_osc", "accent", {990., 0.18, 0.25, 0.70}]];

add[TemporalSystem`Entities`makeCurve["ampA", 0, "amplitude", 13/4,
  {"linear", {{0, 0.}, {1, 0.95}, {2, 0.65}, {13/4, 0.85}}}]];
add[TemporalSystem`Entities`makeCurve["ampB", 13/4, "amplitude", 13/4,
  {"linear", {{0, 0.85}, {7/8, 0.35}, {7/4, 0.95}, {13/4, 0.55}}}]];
add[TemporalSystem`Entities`makeCurve["ampScale", 0, "ampScale", 13/2,
  {"linear", {{0, 0.70}, {13/4, 1.00}, {13/2, 0.60}}}]];
add[TemporalSystem`Entities`makeCurve["panA", 0, "panSweep", 13/4,
  {"linear", {{0, 0.05}, {1, 0.95}, {2, 0.35}, {13/4, 0.75}}}]];
add[TemporalSystem`Entities`makeCurve["panB", 13/4, "panSweep", 13/4,
  {"linear", {{0, 0.75}, {7/8, 0.20}, {7/4, 0.90}, {13/4, 0.45}}}]];
add[TemporalSystem`Entities`makeCurve["panDepth", 0, "panDepth", 13/2,
  {"linear", {{0, 1.00}, {13/4, 0.45}, {13/2, 0.85}}}]];

Print["entities: ", TemporalSystem`StemData`stemDataSize[sd]];

registry = TemporalSystem`Session`loadOrchRegistry[cfg];
If[registry === $Failed, Print["registry failed"]; Exit[1]];

(* Timeline figure *)
g = TemporalSystem`Timeline`drawTimeline[sd, tempo];
If[Head[g] =!= Graphics, Print["drawTimeline did not return Graphics"]; Exit[1]];
Export[FileNameJoin[{figDir, "timeline_export.pdf"}], g];
Export[FileNameJoin[{figDir, "timeline_export.png"}], g, ImageResolution -> 300];
Print["written: figures/timeline_export.pdf|png"];

(* Aggregated Csound rendering + audio *)
prims = TemporalSystem`Csound`renderCSnd[sd, tempo, registry, cfg];
If[!ListQ[prims], Print["renderCSnd failed"]; Exit[1]];
result = TemporalSystem`Csound`serializeCSnd[
  prims, cfg, registry, FileNameJoin[{exDir, "timeline_example.csd"}]];
If[!AssociationQ[result] || result["compiled"] =!= True,
  Print["timeline_example compile failed"]; Exit[1]];
Print["written: example/timeline_example.csd|wav"];

(* Its click track: 1/8 grid over the 4/4, 5/8, 7/8, 3/4 meter sequence *)
clickRegistry = KeyTake[registry, {"click"}];
clickPrims = TemporalSystem`Click`renderClickTrack[sd, tempo, clickRegistry, cfg];
If[clickPrims === $Failed, Print["click render failed"]; Exit[1]];
clickResult = TemporalSystem`Click`serializeClickCSnd[
  clickPrims, cfg, clickRegistry,
  FileNameJoin[{exDir, "timeline_example_click.csd"}]];
If[!AssociationQ[clickResult] || clickResult["compiled"] =!= True,
  Print["timeline_example_click compile failed"]; Exit[1]];
Print["written: example/timeline_example_click.csd|wav"];

(* ============================================================
   2. The minimal snippets quoted verbatim in the paper.        *)

paperCfg = TemporalSystem`Session`makeSessionConfig[
  "sampleRate" -> 44100,
  "instrumentsDir" -> FileNameJoin[{repoRoot, "instruments"}]
];
sdPaper = TemporalSystem`StemData`emptyStemData[];
sdPaper = TemporalSystem`StemData`addEntity[sdPaper,
  TemporalSystem`Entities`makeMeter["m1", 0, 4, 4]];
sdPaper = TemporalSystem`StemData`addEntity[sdPaper,
  TemporalSystem`Entities`makeNote["n1", 0, {"A4", 0}, 2, "mf",
    "rendering" -> <|"csound" -> <|"instrument" -> "sine_osc", "p6" -> 0.5|>|>]];
tempoPaper = TemporalSystem`TempoMap`makeTempoSpec[{{0, 120.}}];

paperClick = TemporalSystem`Renderer`renderTo[
  sdPaper, tempoPaper, TemporalSystem`Click`clickBackend, paperCfg, registry];
If[!StringQ[paperClick], Print["paper click failed"]; Exit[1]];
Export[FileNameJoin[{exDir, "paper_click.csd"}], paperClick, "Text"];

paperNote = TemporalSystem`Renderer`renderTo[
  sdPaper, tempoPaper, TemporalSystem`Csound`csoundBackend, paperCfg, registry];
If[!StringQ[paperNote], Print["paper note failed"]; Exit[1]];
Export[FileNameJoin[{exDir, "paper_note.csd"}], paperNote, "Text"];
Print["written: example/paper_click.csd, example/paper_note.csd"];

(* ============================================================
   3. OSC projection of a single amplitude curve, quoted in Sect. 4:
      a linear 0->1 ramp sampled at 10 Hz over two seconds.         *)

oscCfg = TemporalSystem`Session`makeSessionConfig[
  "sampleRate" -> 44100, "curveSrOSC" -> 10];
oscTempo = TemporalSystem`TempoMap`makeTempoSpec[{{0, 120.}}];
oscCurve = TemporalSystem`Entities`makeCurve[
  "ampRamp", 0, "amplitude", 1, {"linear", {{0, 0.}, {1, 1.}}}];
oscEvents = TemporalSystem`OSC`renderEntityToOSC[oscCurve, oscTempo, oscCfg];
oscJson = TemporalSystem`OSC`serializeOSC[oscEvents, oscCfg];
If[!AssociationQ[oscJson], Print["osc render failed"]; Exit[1]];
Export[FileNameJoin[{exDir, "paper_curve_osc.json"}], oscJson, "JSON"];
Print["written: example/paper_curve_osc.json"];
