
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

  OpenApiRestCall_563556 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563556](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563556): Option[Scheme] {.used.} =
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
    case js.kind
    of JInt, JFloat, JNull, JBool:
      head = $js
    of JString:
      head = js.getStr
    else:
      return
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  macServiceName = "machinelearningservices-hyperdrive"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_HyperDriveCreateExperiment_563778 = ref object of OpenApiRestCall_563556
proc url_HyperDriveCreateExperiment_563780(protocol: Scheme; host: string;
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

proc validate_HyperDriveCreateExperiment_563779(path: JsonNode; query: JsonNode;
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
  var valid_563955 = path.getOrDefault("armScope")
  valid_563955 = validateParameter(valid_563955, JString, required = true,
                                 default = nil)
  if valid_563955 != nil:
    section.add "armScope", valid_563955
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
  var valid_563956 = formData.getOrDefault("config")
  valid_563956 = validateParameter(valid_563956, JString, required = true,
                                 default = nil)
  if valid_563956 != nil:
    section.add "config", valid_563956
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563979: Call_HyperDriveCreateExperiment_563778; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a HyperDrive Experiment.
  ## 
  let valid = call_563979.validator(path, query, header, formData, body)
  let scheme = call_563979.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563979.url(scheme.get, call_563979.host, call_563979.base,
                         call_563979.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563979, url, valid)

proc call*(call_564050: Call_HyperDriveCreateExperiment_563778; armScope: string;
          config: string): Recallable =
  ## hyperDriveCreateExperiment
  ## Create a HyperDrive Experiment.
  ##   armScope: string (required)
  ##           : The ARM scope passed in through URL with format:
  ##             
  ## subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/experiments/{experimentName}.
  ## 
  ##   config: string (required)
  ##         : The configuration file with experiment JSON content. A text file that is a JSON-serialized '#/definitions/HyperDriveCreateExperiment' object.
  var path_564051 = newJObject()
  var formData_564053 = newJObject()
  add(path_564051, "armScope", newJString(armScope))
  add(formData_564053, "config", newJString(config))
  result = call_564050.call(path_564051, nil, nil, formData_564053, nil)

var hyperDriveCreateExperiment* = Call_HyperDriveCreateExperiment_563778(
    name: "hyperDriveCreateExperiment", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/hyperdrive/v1.0/{armScope}/runs",
    validator: validate_HyperDriveCreateExperiment_563779, base: "",
    url: url_HyperDriveCreateExperiment_563780, schemes: {Scheme.Https})
type
  Call_HyperDriveCancelExperiment_564092 = ref object of OpenApiRestCall_563556
proc url_HyperDriveCancelExperiment_564094(protocol: Scheme; host: string;
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

proc validate_HyperDriveCancelExperiment_564093(path: JsonNode; query: JsonNode;
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
  var valid_564095 = path.getOrDefault("runId")
  valid_564095 = validateParameter(valid_564095, JString, required = true,
                                 default = nil)
  if valid_564095 != nil:
    section.add "runId", valid_564095
  var valid_564096 = path.getOrDefault("armScope")
  valid_564096 = validateParameter(valid_564096, JString, required = true,
                                 default = nil)
  if valid_564096 != nil:
    section.add "armScope", valid_564096
  result.add "path", section
  section = newJObject()
  result.add "query", section
  ## parameters in `header` object:
  ##   RunHistoryHost: JString
  ##                 : The host for run location.
  section = newJObject()
  var valid_564097 = header.getOrDefault("RunHistoryHost")
  valid_564097 = validateParameter(valid_564097, JString, required = false,
                                 default = nil)
  if valid_564097 != nil:
    section.add "RunHistoryHost", valid_564097
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564098: Call_HyperDriveCancelExperiment_564092; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancel a HyperDrive Experiment.
  ## 
  let valid = call_564098.validator(path, query, header, formData, body)
  let scheme = call_564098.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564098.url(scheme.get, call_564098.host, call_564098.base,
                         call_564098.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564098, url, valid)

proc call*(call_564099: Call_HyperDriveCancelExperiment_564092; runId: string;
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
  var path_564100 = newJObject()
  add(path_564100, "runId", newJString(runId))
  add(path_564100, "armScope", newJString(armScope))
  result = call_564099.call(path_564100, nil, nil, nil, nil)

var hyperDriveCancelExperiment* = Call_HyperDriveCancelExperiment_564092(
    name: "hyperDriveCancelExperiment", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/hyperdrive/v1.0/{armScope}/runs/{runId}/cancel",
    validator: validate_HyperDriveCancelExperiment_564093, base: "",
    url: url_HyperDriveCancelExperiment_564094, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
