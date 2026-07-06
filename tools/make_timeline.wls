(* Generate the timeline figure for the ICSC 2026 paper, using
   temporal-system's own drawTimeline renderer. *)

repoRoot = "/Users/master/Documents/GitHub/temporal-system";
outDir = "/Users/master/Documents/GitHub/2026-icsc-temporal-system/figures";
SetDirectory[repoRoot];
If[!DirectoryQ[outDir], CreateDirectory[outDir]];

Get[FileNameJoin[{repoRoot, "core", "entities.wl"}]];
Get[FileNameJoin[{repoRoot, "core", "stemData.wl"}]];
Get[FileNameJoin[{repoRoot, "core", "tempoMap.wl"}]];
Get[FileNameJoin[{repoRoot, "util", "timeline.wl"}]];

sd = TemporalSystem`StemData`emptyStemData[];
add[e_] := (sd = TemporalSystem`StemData`addEntity[sd, e];
  If[sd === $Failed, Print["addEntity failed: ", e]; Exit[1]]);

(* meter: two bars of 4/4 followed by 3/4 *)
add[TemporalSystem`Entities`makeMeter["m1", 0, 4, 4]];
add[TemporalSystem`Entities`makeMeter["m2", 8, 3, 4]];

(* a rising harmonic-series segment on sine_osc (harmonics 2-9 of A2),
   microtonal offsets in cents *)
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

(* an amplitude curve, a trigger and section markers *)
add[TemporalSystem`Entities`makeCurve["c1", 0, "amplitude", 8,
  {"linear", {{0, 0.15}, {4, 0.9}, {8, 0.3}}}]];
add[TemporalSystem`Entities`makeTrigger["t1", 4, "reverb", "enable", {0.35}]];
add[TemporalSystem`Entities`makeMarker["mk1", 0, "A"]];
add[TemporalSystem`Entities`makeMarker["mk2", 8, "B"]];

tempo = TemporalSystem`TempoMap`makeTempoSpec[{{0, 120.}}];

g = TemporalSystem`Timeline`drawTimeline[sd, tempo];
If[Head[g] =!= Graphics, Print["drawTimeline did not return Graphics"]; Exit[1]];

pdfPath = FileNameJoin[{outDir, "timeline_export.pdf"}];
pngPath = FileNameJoin[{outDir, "timeline_export.png"}];
Export[pdfPath, g];
Export[pngPath, g, ImageResolution -> 300];
Print["written: ", pdfPath];
Print["written: ", pngPath];
