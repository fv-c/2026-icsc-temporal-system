(* Generate a real click-track .csd and a Csound note rendering through
   temporal-system's actual pipeline, for quoting in the ICSC 2026 paper. *)

repoRoot = "/Users/master/Documents/GitHub/temporal-system";
outDir = FileNameJoin[{DirectoryName[ExpandFileName[$InputFileName]], "..", "artifacts"}];
SetDirectory[repoRoot];

Get[FileNameJoin[{repoRoot, "core", "entities.wl"}]];
Get[FileNameJoin[{repoRoot, "core", "stemData.wl"}]];
Get[FileNameJoin[{repoRoot, "core", "tempoMap.wl"}]];
Get[FileNameJoin[{repoRoot, "core", "session.wl"}]];
Get[FileNameJoin[{repoRoot, "util", "pitch.wl"}]];
Get[FileNameJoin[{repoRoot, "util", "dynamics.wl"}]];
Get[FileNameJoin[{repoRoot, "rendering", "renderer.wl"}]];
Get[FileNameJoin[{repoRoot, "rendering", "csound.wl"}]];
Get[FileNameJoin[{repoRoot, "rendering", "click.wl"}]];

(* whole-note beat space: one 4/4 bar = 1, quarter = 1/4 *)
sd = TemporalSystem`StemData`emptyStemData[];
sd = TemporalSystem`StemData`addEntity[sd, TemporalSystem`Entities`makeMeter["m1", 0, 4, 4]];
sd = TemporalSystem`StemData`addEntity[sd,
  TemporalSystem`Entities`makeNote["n1", 0, {"A4", 0}, 2, "mf",
    "rendering" -> <|"csound" -> <|"instrument" -> "sine_osc", "p6" -> 0.5|>|>]];

tempo = TemporalSystem`TempoMap`makeTempoSpec[{{0, 120.}}];
config = TemporalSystem`Session`makeSessionConfig[];
registry = TemporalSystem`Session`loadOrchRegistry[config];
If[registry === $Failed, Print["registry failed"]; Exit[1]];

(* click track via generic dispatcher *)
csdClick = TemporalSystem`Renderer`renderTo[
  sd, tempo, TemporalSystem`Click`clickBackend, config, registry];
If[!StringQ[csdClick], Print["click renderTo failed"]; Exit[1]];
Export[FileNameJoin[{outDir, "click_track.csd"}], csdClick, "Text"];

(* csound backend on the same stemData *)
csdNotes = TemporalSystem`Renderer`renderTo[
  sd, tempo, TemporalSystem`Csound`csoundBackend, config, registry];
If[!StringQ[csdNotes], Print["csound renderTo failed"]; Exit[1]];
Export[FileNameJoin[{outDir, "notes.csd"}], csdNotes, "Text"];

Print["=== click_track.csd ==="];
Print[csdClick];
Print["=== notes.csd score lines ==="];
Print[StringRiffle[Select[StringSplit[csdNotes, "\n"], StringStartsQ[#, "i "] &], "\n"]];
