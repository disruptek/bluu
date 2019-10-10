
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: HyperDrive
## version: 2019-08-01
## termsOfService: (not provided)
## license: (not provided)
## 
## HyperDrive REST API
## 
type
  Scheme {.pure.} = enum
    Https = "https", Http = "http", Wss = "wss", Ws = "ws"
  ValidatorSignature = proc (query: JsonNode = nil; body: JsonNode = nil;
                          header: JsonNode = nil; path: JsonNode = nil;
                          formData: JsonNode = nil): JsonNode
  OpenApiRestCall = ref object of RestCall
    validator*: ValidatorSignature
    route*: string
    base*: string
    host*: string
    schemes*: set[Scheme]
    url*: proc (protocol: Scheme; host: string; base: string; route: string;
              path: JsonNode; query: JsonNode): Uri

  OpenApiRestCall_573658 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_573658](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_573658): Option[Scheme] {.used.} =
  ## select a supported scheme from a set of candidates
  for scheme in Scheme.low ..
      Scheme.high:
    if scheme notin t.schemes:
      continue
    if scheme in [Scheme.Https, Scheme.Wss]:
      when defined(ssl):
        return some(scheme)
      else:
        continue
    return some(scheme)

proc validateParameter(js: JsonNode; kind: JsonNodeKind; required: bool;
                      default: JsonNode = nil): JsonNode =
  ## ensure an input is of the correct json type and yield
  ## a suitable default value when appropriate
  if js ==
      nil:
    if default != nil:
      return validateParameter(default, kind, required = required)
  result = js
  if result ==
      nil:
    assert not required, $kind & " expected; received nil"
    if required:
      result = newJNull()
  else:
    assert js.kind ==
        kind, $kind & " expected; received " &
        $js.kind

type
  KeyVal {.used.} = tuple[key: string, val: string]
  PathTokenKind = enum
    ConstantSegment, VariableSegment
  PathToken = tuple[kind: PathTokenKind, value: string]
proc queryString(query: JsonNode): string {.used.} =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] {.used.} =
  ## reconstitute a path with constants and variable values taken from json
  var head: string
  if segments.len == 0:
    return some("")
  head = segments[0].value
  case segments[0].kind
  of ConstantSegment:
    discard
  of VariableSegment:
    if head notin input:
      return
    let js = input[head]
    if js.kind notin {JString, JInt, JFloat, JNull, JBool}:
      return
    head = $js
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  macServiceName = "machinelearningservices-hyperdrive"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_HyperDriveCreateExperiment_573880 = ref object of OpenApiRestCall_573658
proc url_HyperDriveCreateExperiment_573882(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "armScope" in path, "`armScope` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/hyperdrive/v1.0/"),
               (kind: VariableSegment, value: "armScope"),
               (kind: ConstantSegment, value: "/runs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HyperDriveCreateExperiment_573881(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a HyperDrive Experiment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   armScope: JString (required)
  ##           : The ARM scope passed in through URL with format:
  ##             
  ## subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/experiments/{experimentName}.
  ## 
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `armScope` field"
  var valid_574055 = path.getOrDefault("armScope")
  valid_574055 = validateParameter(valid_574055, JString, required = true,
                                 default = nil)
  if valid_574055 != nil:
    section.add "armScope", valid_574055
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  ## parameters in `formData` object:
  ##   config: JString (required)
  ##         : The configuration file with experiment JSON content. A text file that is a JSON-serialized '#/definitions/HyperDriveCreateExperiment' object.
  section = newJObject()
  assert formData != nil,
        "formData argument is necessary due to required `config` field"
  var valid_574056 = formData.getOrDefault("config")
  valid_574056 = validateParameter(valid_574056, JString, required = true,
                                 default = nil)
  if valid_574056 != nil:
    section.add "config", valid_574056
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574079: Call_HyperDriveCreateExperiment_573880; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a HyperDrive Experiment.
  ## 
  let valid = call_574079.validator(path, query, header, formData, body)
  let scheme = call_574079.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574079.url(scheme.get, call_574079.host, call_574079.base,
                         call_574079.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574079, url, valid)

proc call*(call_574150: Call_HyperDriveCreateExperiment_573880; config: string;
          armScope: string): Recallable =
  ## hyperDriveCreateExperiment
  ## Create a HyperDrive Experiment.
  ##   config: string (required)
  ##         : The configuration file with experiment JSON content. A text file that is a JSON-serialized '#/definitions/HyperDriveCreateExperiment' object.
  ##   armScope: string (required)
  ##           : The ARM scope passed in through URL with format:
  ##             
  ## subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/experiments/{experimentName}.
  ## 
  var path_574151 = newJObject()
  var formData_574153 = newJObject()
  add(formData_574153, "config", newJString(config))
  add(path_574151, "armScope", newJString(armScope))
  result = call_574150.call(path_574151, nil, nil, formData_574153, nil)

var hyperDriveCreateExperiment* = Call_HyperDriveCreateExperiment_573880(
    name: "hyperDriveCreateExperiment", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/hyperdrive/v1.0/{armScope}/runs",
    validator: validate_HyperDriveCreateExperiment_573881, base: "",
    url: url_HyperDriveCreateExperiment_573882, schemes: {Scheme.Https})
type
  Call_HyperDriveCancelExperiment_574192 = ref object of OpenApiRestCall_573658
proc url_HyperDriveCancelExperiment_574194(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "armScope" in path, "`armScope` is a required path parameter"
  assert "runId" in path, "`runId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/hyperdrive/v1.0/"),
               (kind: VariableSegment, value: "armScope"),
               (kind: ConstantSegment, value: "/runs/"),
               (kind: VariableSegment, value: "runId"),
               (kind: ConstantSegment, value: "/cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HyperDriveCancelExperiment_574193(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Cancel a HyperDrive Experiment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   runId: JString (required)
  ##        : Hyperdrive run id to cancel.
  ##   armScope: JString (required)
  ##           : The ARM scope passed in through URL with format:
  ##             
  ## subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/experiments/{experimentName}.
  ## 
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `runId` field"
  var valid_574195 = path.getOrDefault("runId")
  valid_574195 = validateParameter(valid_574195, JString, required = true,
                                 default = nil)
  if valid_574195 != nil:
    section.add "runId", valid_574195
  var valid_574196 = path.getOrDefault("armScope")
  valid_574196 = validateParameter(valid_574196, JString, required = true,
                                 default = nil)
  if valid_574196 != nil:
    section.add "armScope", valid_574196
  result.add "path", section
  section = newJObject()
  result.add "query", section
  ## parameters in `header` object:
  ##   RunHistoryHost: JString
  ##                 : The host for run location.
  section = newJObject()
  var valid_574197 = header.getOrDefault("RunHistoryHost")
  valid_574197 = validateParameter(valid_574197, JString, required = false,
                                 default = nil)
  if valid_574197 != nil:
    section.add "RunHistoryHost", valid_574197
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574198: Call_HyperDriveCancelExperiment_574192; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancel a HyperDrive Experiment.
  ## 
  let valid = call_574198.validator(path, query, header, formData, body)
  let scheme = call_574198.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574198.url(scheme.get, call_574198.host, call_574198.base,
                         call_574198.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574198, url, valid)

proc call*(call_574199: Call_HyperDriveCancelExperiment_574192; runId: string;
          armScope: string): Recallable =
  ## hyperDriveCancelExperiment
  ## Cancel a HyperDrive Experiment.
  ##   runId: string (required)
  ##        : Hyperdrive run id to cancel.
  ##   armScope: string (required)
  ##           : The ARM scope passed in through URL with format:
  ##             
  ## subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/experiments/{experimentName}.
  ## 
  var path_574200 = newJObject()
  add(path_574200, "runId", newJString(runId))
  add(path_574200, "armScope", newJString(armScope))
  result = call_574199.call(path_574200, nil, nil, nil, nil)

var hyperDriveCancelExperiment* = Call_HyperDriveCancelExperiment_574192(
    name: "hyperDriveCancelExperiment", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/hyperdrive/v1.0/{armScope}/runs/{runId}/cancel",
    validator: validate_HyperDriveCancelExperiment_574193, base: "",
    url: url_HyperDriveCancelExperiment_574194, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
