#!/usr/bin/env wolframscript
(* ============================================================================
   make_sync_demo.wls
   Regenerate the four-backend synchrony demonstration for the paper
   "One Timeline, Many Renderings: A Wolfram Language Paclet for Heterogeneous
   Musical Output" (ICSC 2026), section 6 "Keeping the Projections Synchronous".

   WHAT IT PRODUCES (written next to this script):
     demo_sync_A.{csd,musicxml} + demo_sync_click_A.csd + demo_sync_osc_A.json
     demo_sync_B.{csd,musicxml} + demo_sync_click_B.csd + demo_sync_osc_B.json
     propagation.{pdf,png}
   One authored timeline (two 4/4 bars then 3/4, 120 then 90 BPM) is projected
   to all four backends (`_A`), then re-rendered after a SINGLE tempo edit
   (second segment 90 -> 60 BPM, `_B`). The three time-domain backends
   (Csound p2, OSC time_ms, click) move together; the MusicXML export is
   byte-identical across the edit.

   REQUIREMENTS:
     - WolframScript
     - a checkout of the Temporal System paclet (not yet public). Point this
       script at it either by setting the environment variable
       TEMPORAL_SYSTEM_ROOT, or by editing `repoRoot` below:

         TEMPORAL_SYSTEM_ROOT=/path/to/temporal-system \
           wolframscript -file make_sync_demo.wls

   The pre-generated artifacts already ship in this folder; this script is only
   needed to reproduce them.
   ============================================================================ *)

repoRoot = Environment["TEMPORAL_SYSTEM_ROOT"];
If[!StringQ[repoRoot] || !DirectoryQ[repoRoot],
  repoRoot = "/Users/master/Documents/GitHub/temporal-system"];  (* <-- edit if needed *)
If[!DirectoryQ[repoRoot],
  Print["Temporal System paclet not found at: ", repoRoot];
  Print["Set TEMPORAL_SYSTEM_ROOT or edit repoRoot in this script."];
  Exit[1]];

out = DirectoryName[ExpandFileName[$InputFileName]];
SetDirectory[out];  (* never write into the paclet repo *)

Get[FileNameJoin[{repoRoot, "core", "entities.wl"}]];
Get[FileNameJoin[{repoRoot, "core", "stemData.wl"}]];
Get[FileNameJoin[{repoRoot, "core", "tempoMap.wl"}]];
Get[FileNameJoin[{repoRoot, "core", "session.wl"}]];
Get[FileNameJoin[{repoRoot, "util", "pitch.wl"}]];
Get[FileNameJoin[{repoRoot, "util", "dynamics.wl"}]];
Get[FileNameJoin[{repoRoot, "util", "rhythm.wl"}]];
Get[FileNameJoin[{repoRoot, "rendering", "renderer.wl"}]];
Get[FileNameJoin[{repoRoot, "rendering", "csound.wl"}]];
Get[FileNameJoin[{repoRoot, "rendering", "click.wl"}]];
Get[FileNameJoin[{repoRoot, "rendering", "osc.wl"}]];
Get[FileNameJoin[{repoRoot, "rendering", "musicxml.wl"}]];

b2s[beat_, tempo_] := TemporalSystem`TempoMap`beatToSeconds[beat, tempo];

cfg = TemporalSystem`Session`makeSessionConfig[
  "sampleRate" -> 44100,
  "curveSrOSC" -> 10,
  "clickBeatUnit" -> 1/4,
  "clickDuration" -> 1/16,
  "instrumentsDir" -> FileNameJoin[{repoRoot, "instruments"}]
];
registry = TemporalSystem`Session`loadOrchRegistry[cfg];

(* ---- one authored timeline: 4/4 (x2) then 3/4, with a tempo change ---- *)
mkN[id_, onset_, pitch_, dur_, dyn_] := TemporalSystem`Entities`makeNote[
  id, onset, pitch, dur, dyn,
  "rendering" -> <|"csound" -> <|"instrument" -> "sine_osc"|>,
                   "musicxml" -> <|"instrument" -> "Lead", "voice" -> 1, "staff" -> 1|>|>];

sd = TemporalSystem`StemData`emptyStemData[];
sd = TemporalSystem`StemData`addEntity[sd, TemporalSystem`Entities`makeMeter["m1", 0, 4, 4]];
sd = TemporalSystem`StemData`addEntity[sd, TemporalSystem`Entities`makeMeter["m2", 2, 3, 4]];
sd = TemporalSystem`StemData`addEntity[sd, mkN["n1", 0,   {"A4", 0}, 1/4, "mf"]];
sd = TemporalSystem`StemData`addEntity[sd, mkN["n2", 1,   {"C5", 0}, 1/4, "mf"]];
sd = TemporalSystem`StemData`addEntity[sd, mkN["n3", 2,   {"E5", 0}, 1/4, "f"]];   (* downbeat of bar 3, at the edit point *)
sd = TemporalSystem`StemData`addEntity[sd, mkN["n4", 9/4, {"G5", 0}, 1/4, "mf"]];
sd = TemporalSystem`StemData`addEntity[sd, mkN["n5", 5/2, {"B5", 0}, 1/4, "mf"]];

tempoA = TemporalSystem`TempoMap`makeTempoSpec[{{0, 120.}, {2, 90.}}];  (* original *)
tempoB = TemporalSystem`TempoMap`makeTempoSpec[{{0, 120.}, {2, 60.}}];  (* single edit: 90 -> 60 *)

render[tempo_, tag_] := Module[{cs, ck, osc, mx},
  cs  = TemporalSystem`Renderer`renderTo[sd, tempo, TemporalSystem`Csound`csoundBackend, cfg, registry];
  ck  = TemporalSystem`Renderer`renderTo[sd, tempo, TemporalSystem`Click`clickBackend, cfg, registry];
  osc = TemporalSystem`Renderer`renderTo[sd, tempo, TemporalSystem`OSC`oscBackend, cfg, registry];
  mx  = TemporalSystem`Renderer`renderTo[sd, tempo, TemporalSystem`MusicXML`musicXMLBackend, cfg, registry];
  If[StringQ[cs],  Export["demo_sync_" <> tag <> ".csd", cs, "Text"]];
  If[StringQ[ck],  Export["demo_sync_click_" <> tag <> ".csd", ck, "Text"]];
  If[AssociationQ[osc], Export["demo_sync_osc_" <> tag <> ".json", osc, "JSON"]];
  Which[
    StringQ[mx],           Export["demo_sync_" <> tag <> ".musicxml", mx, "Text"],
    MatchQ[mx, _XMLObject], Export["demo_sync_" <> tag <> ".musicxml", mx, "XML"]
  ];
  Print["[", tag, "] csound=", StringQ[cs], " click=", StringQ[ck],
        " osc=", AssociationQ[osc], " musicxml=", Head[mx]];
];

render[tempoA, "A"];
render[tempoB, "B"];

(* ---- propagation figure (B/W-safe: filled disk = original, open = edited) ---- *)
beats = {0, 1, 2, 9/4, 5/2};
labels = {"n1", "n2", "n3", "n4", "n5"};
secA = b2s[#, tempoA] & /@ beats;
secB = b2s[#, tempoB] & /@ beats;
Print["propagation seconds  A=", secA, "  B=", secB];

lanes = {"Csound  p2 (s)", "OSC  time_ms", "click  grid"};
yFor = <|lanes[[1]] -> 3, lanes[[2]] -> 2, lanes[[3]] -> 1|>;
rx = 0.062; ry = 0.15; editX = 4.0;
marker[x_, y_, filled_] := If[filled,
  {Black, Disk[{x, y}, {rx, ry}]},
  {White, Disk[{x, y}, {rx, ry}], Black, Thickness[0.005], Circle[{x, y}, {rx, ry}]}];
laneGraphics[y_] := {
  GrayLevel[0.78], Thickness[0.002], Line[{{-0.2, y}, {6.65, y}}],
  GrayLevel[0.5],
  Table[If[secB[[i]] > secA[[i]] + 0.001,
    {Arrowheads[0.022], Arrow[{{secA[[i]] + 1.7 rx, y}, {secB[[i]] - 1.7 rx, y}}]}, {}],
    {i, Length[beats]}],
  Table[If[Abs[secB[[i]] - secA[[i]]] < 0.001,
      marker[secA[[i]], y, True],
      {marker[secA[[i]], y, True], marker[secB[[i]], y, False]}],
    {i, Length[beats]}]
};
fig = Graphics[{
    GrayLevel[0.55], Dashing[{0.012, 0.012}], Thickness[0.003],
    Line[{{editX, 0.45}, {editX, 3.45}}],
    Table[laneGraphics[yFor[l]], {l, lanes}],
    Table[Text[Style[l, 9, FontFamily -> "Helvetica"], {-0.35, yFor[l]}, {1, 0}], {l, lanes}],
    Table[Text[Style[labels[[i]], 7, Gray, FontFamily -> "Helvetica"],
      {If[i <= 3, secA[[i]], (secA[[i]] + secB[[i]])/2], 3.5}, {0, -1}], {i, Length[beats]}],
    Text[Style["tempo edit at beat 2  (90\[Rule]60 BPM)", 7.5, GrayLevel[0.4],
      FontFamily -> "Helvetica"], {editX + 0.12, 0.2}, {-1, 0}],
    marker[-1.75, 0.2, True], Text[Style["original", 7, FontFamily -> "Helvetica"], {-1.62, 0.2}, {-1, 0}],
    marker[-0.75, 0.2, False], Text[Style["edited", 7, FontFamily -> "Helvetica"], {-0.62, 0.2}, {-1, 0}]
  },
  PlotRange -> {{-2.0, 7.1}, {-0.15, 3.8}}, AspectRatio -> 0.4, ImageSize -> 380,
  Axes -> {True, False}, AxesStyle -> GrayLevel[0.3], Ticks -> {Range[0, 6], None},
  AxesLabel -> {Style["seconds", 8, FontFamily -> "Helvetica"], None}
];
Export["propagation.pdf", fig];
Export["propagation.png", fig, ImageResolution -> 300];

(* tidy up any stray Csound scratch files a compile step may leave behind *)
Scan[If[FileExistsQ[#], DeleteFile[#]] &, {"test.aif", "test.pkf"}];
Print["done -> ", out];
