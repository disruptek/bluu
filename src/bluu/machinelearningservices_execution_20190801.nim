
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: Execution Service
## version: 2019-08-01
## termsOfService: (not provided)
## license: (not provided)
## 
## 
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

  OpenApiRestCall_573657 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_573657](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_573657): Option[Scheme] {.used.} =
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
  macServiceName = "machinelearningservices-execution"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ExecutionCancelRunWithUri_573879 = ref object of OpenApiRestCall_573657
proc url_ExecutionCancelRunWithUri_573881(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "experimentName" in path, "`experimentName` is a required path parameter"
  assert "runId" in path, "`runId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/execution/v1.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/experiments/"),
               (kind: VariableSegment, value: "experimentName"),
               (kind: ConstantSegment, value: "/runId/"),
               (kind: VariableSegment, value: "runId"),
               (kind: ConstantSegment, value: "/cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExecutionCancelRunWithUri_573880(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Cancels a run within an experiment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   runId: JString (required)
  ##        : The id of the run to cancel.
  ##   experimentName: JString (required)
  ##                 : The experiment name.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574054 = path.getOrDefault("resourceGroupName")
  valid_574054 = validateParameter(valid_574054, JString, required = true,
                                 default = nil)
  if valid_574054 != nil:
    section.add "resourceGroupName", valid_574054
  var valid_574055 = path.getOrDefault("subscriptionId")
  valid_574055 = validateParameter(valid_574055, JString, required = true,
                                 default = nil)
  if valid_574055 != nil:
    section.add "subscriptionId", valid_574055
  var valid_574056 = path.getOrDefault("runId")
  valid_574056 = validateParameter(valid_574056, JString, required = true,
                                 default = nil)
  if valid_574056 != nil:
    section.add "runId", valid_574056
  var valid_574057 = path.getOrDefault("experimentName")
  valid_574057 = validateParameter(valid_574057, JString, required = true,
                                 default = nil)
  if valid_574057 != nil:
    section.add "experimentName", valid_574057
  var valid_574058 = path.getOrDefault("workspaceName")
  valid_574058 = validateParameter(valid_574058, JString, required = true,
                                 default = nil)
  if valid_574058 != nil:
    section.add "workspaceName", valid_574058
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574081: Call_ExecutionCancelRunWithUri_573879; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancels a run within an experiment.
  ## 
  let valid = call_574081.validator(path, query, header, formData, body)
  let scheme = call_574081.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574081.url(scheme.get, call_574081.host, call_574081.base,
                         call_574081.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574081, url, valid)

proc call*(call_574152: Call_ExecutionCancelRunWithUri_573879;
          resourceGroupName: string; subscriptionId: string; runId: string;
          experimentName: string; workspaceName: string): Recallable =
  ## executionCancelRunWithUri
  ## Cancels a run within an experiment.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   runId: string (required)
  ##        : The id of the run to cancel.
  ##   experimentName: string (required)
  ##                 : The experiment name.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_574153 = newJObject()
  add(path_574153, "resourceGroupName", newJString(resourceGroupName))
  add(path_574153, "subscriptionId", newJString(subscriptionId))
  add(path_574153, "runId", newJString(runId))
  add(path_574153, "experimentName", newJString(experimentName))
  add(path_574153, "workspaceName", newJString(workspaceName))
  result = call_574152.call(path_574153, nil, nil, nil, nil)

var executionCancelRunWithUri* = Call_ExecutionCancelRunWithUri_573879(
    name: "executionCancelRunWithUri", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/execution/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/experiments/{experimentName}/runId/{runId}/cancel",
    validator: validate_ExecutionCancelRunWithUri_573880, base: "",
    url: url_ExecutionCancelRunWithUri_573881, schemes: {Scheme.Https})
type
  Call_ExecutionStartSnapshotRun_574193 = ref object of OpenApiRestCall_573657
proc url_ExecutionStartSnapshotRun_574195(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "experimentName" in path, "`experimentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/execution/v1.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/experiments/"),
               (kind: VariableSegment, value: "experimentName"),
               (kind: ConstantSegment, value: "/snapshotrun")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExecutionStartSnapshotRun_574194(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Starts an experiment run on the remote compute target using the provided definition.json file to define the run.
  ##             The code for the run is retrieved using the snapshotId in definition.json.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   experimentName: JString (required)
  ##                 : The experiment name.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574196 = path.getOrDefault("resourceGroupName")
  valid_574196 = validateParameter(valid_574196, JString, required = true,
                                 default = nil)
  if valid_574196 != nil:
    section.add "resourceGroupName", valid_574196
  var valid_574197 = path.getOrDefault("subscriptionId")
  valid_574197 = validateParameter(valid_574197, JString, required = true,
                                 default = nil)
  if valid_574197 != nil:
    section.add "subscriptionId", valid_574197
  var valid_574198 = path.getOrDefault("experimentName")
  valid_574198 = validateParameter(valid_574198, JString, required = true,
                                 default = nil)
  if valid_574198 != nil:
    section.add "experimentName", valid_574198
  var valid_574199 = path.getOrDefault("workspaceName")
  valid_574199 = validateParameter(valid_574199, JString, required = true,
                                 default = nil)
  if valid_574199 != nil:
    section.add "workspaceName", valid_574199
  result.add "path", section
  ## parameters in `query` object:
  ##   runId: JString
  ##        : A run id. If not supplied a run id will be created automatically.
  section = newJObject()
  var valid_574200 = query.getOrDefault("runId")
  valid_574200 = validateParameter(valid_574200, JString, required = false,
                                 default = nil)
  if valid_574200 != nil:
    section.add "runId", valid_574200
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   definition: JObject (required)
  ##             : A JSON run definition structure.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574202: Call_ExecutionStartSnapshotRun_574193; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts an experiment run on the remote compute target using the provided definition.json file to define the run.
  ##             The code for the run is retrieved using the snapshotId in definition.json.
  ## 
  let valid = call_574202.validator(path, query, header, formData, body)
  let scheme = call_574202.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574202.url(scheme.get, call_574202.host, call_574202.base,
                         call_574202.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574202, url, valid)

proc call*(call_574203: Call_ExecutionStartSnapshotRun_574193;
          resourceGroupName: string; subscriptionId: string; definition: JsonNode;
          experimentName: string; workspaceName: string; runId: string = ""): Recallable =
  ## executionStartSnapshotRun
  ## Starts an experiment run on the remote compute target using the provided definition.json file to define the run.
  ##             The code for the run is retrieved using the snapshotId in definition.json.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   runId: string
  ##        : A run id. If not supplied a run id will be created automatically.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   definition: JObject (required)
  ##             : A JSON run definition structure.
  ##   experimentName: string (required)
  ##                 : The experiment name.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_574204 = newJObject()
  var query_574205 = newJObject()
  var body_574206 = newJObject()
  add(path_574204, "resourceGroupName", newJString(resourceGroupName))
  add(query_574205, "runId", newJString(runId))
  add(path_574204, "subscriptionId", newJString(subscriptionId))
  if definition != nil:
    body_574206 = definition
  add(path_574204, "experimentName", newJString(experimentName))
  add(path_574204, "workspaceName", newJString(workspaceName))
  result = call_574203.call(path_574204, query_574205, nil, nil, body_574206)

var executionStartSnapshotRun* = Call_ExecutionStartSnapshotRun_574193(
    name: "executionStartSnapshotRun", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/execution/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/experiments/{experimentName}/snapshotrun",
    validator: validate_ExecutionStartSnapshotRun_574194, base: "",
    url: url_ExecutionStartSnapshotRun_574195, schemes: {Scheme.Https})
type
  Call_ExecutionStartLocalRun_574207 = ref object of OpenApiRestCall_573657
proc url_ExecutionStartLocalRun_574209(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "experimentName" in path, "`experimentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/execution/v1.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/experiments/"),
               (kind: VariableSegment, value: "experimentName"),
               (kind: ConstantSegment, value: "/startlocalrun")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExecutionStartLocalRun_574208(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Starts an experiment run using the provided definition.json file to define the run.
  ##             The source code and configuration is defined in a zip archive in project.zip.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   experimentName: JString (required)
  ##                 : The experiment name.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574210 = path.getOrDefault("resourceGroupName")
  valid_574210 = validateParameter(valid_574210, JString, required = true,
                                 default = nil)
  if valid_574210 != nil:
    section.add "resourceGroupName", valid_574210
  var valid_574211 = path.getOrDefault("subscriptionId")
  valid_574211 = validateParameter(valid_574211, JString, required = true,
                                 default = nil)
  if valid_574211 != nil:
    section.add "subscriptionId", valid_574211
  var valid_574212 = path.getOrDefault("experimentName")
  valid_574212 = validateParameter(valid_574212, JString, required = true,
                                 default = nil)
  if valid_574212 != nil:
    section.add "experimentName", valid_574212
  var valid_574213 = path.getOrDefault("workspaceName")
  valid_574213 = validateParameter(valid_574213, JString, required = true,
                                 default = nil)
  if valid_574213 != nil:
    section.add "workspaceName", valid_574213
  result.add "path", section
  ## parameters in `query` object:
  ##   runId: JString
  ##        : A run id. If not supplied a run id will be created automatically.
  section = newJObject()
  var valid_574214 = query.getOrDefault("runId")
  valid_574214 = validateParameter(valid_574214, JString, required = false,
                                 default = nil)
  if valid_574214 != nil:
    section.add "runId", valid_574214
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   definition: JObject (required)
  ##             : A JSON run definition structure.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574216: Call_ExecutionStartLocalRun_574207; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts an experiment run using the provided definition.json file to define the run.
  ##             The source code and configuration is defined in a zip archive in project.zip.
  ## 
  let valid = call_574216.validator(path, query, header, formData, body)
  let scheme = call_574216.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574216.url(scheme.get, call_574216.host, call_574216.base,
                         call_574216.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574216, url, valid)

proc call*(call_574217: Call_ExecutionStartLocalRun_574207;
          resourceGroupName: string; subscriptionId: string; definition: JsonNode;
          experimentName: string; workspaceName: string; runId: string = ""): Recallable =
  ## executionStartLocalRun
  ## Starts an experiment run using the provided definition.json file to define the run.
  ##             The source code and configuration is defined in a zip archive in project.zip.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   runId: string
  ##        : A run id. If not supplied a run id will be created automatically.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   definition: JObject (required)
  ##             : A JSON run definition structure.
  ##   experimentName: string (required)
  ##                 : The experiment name.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_574218 = newJObject()
  var query_574219 = newJObject()
  var body_574220 = newJObject()
  add(path_574218, "resourceGroupName", newJString(resourceGroupName))
  add(query_574219, "runId", newJString(runId))
  add(path_574218, "subscriptionId", newJString(subscriptionId))
  if definition != nil:
    body_574220 = definition
  add(path_574218, "experimentName", newJString(experimentName))
  add(path_574218, "workspaceName", newJString(workspaceName))
  result = call_574217.call(path_574218, query_574219, nil, nil, body_574220)

var executionStartLocalRun* = Call_ExecutionStartLocalRun_574207(
    name: "executionStartLocalRun", meth: HttpMethod.HttpPost, host: "azure.local", route: "/execution/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/experiments/{experimentName}/startlocalrun",
    validator: validate_ExecutionStartLocalRun_574208, base: "",
    url: url_ExecutionStartLocalRun_574209, schemes: {Scheme.Https})
type
  Call_ExecutionStartRun_574221 = ref object of OpenApiRestCall_573657
proc url_ExecutionStartRun_574223(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "experimentName" in path, "`experimentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/execution/v1.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/experiments/"),
               (kind: VariableSegment, value: "experimentName"),
               (kind: ConstantSegment, value: "/startrun")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExecutionStartRun_574222(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Starts an experiment run using the provided definition.json file to define the run.
  ##             The source code and configuration is defined in a zip archive in project.zip.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   experimentName: JString (required)
  ##                 : The experiment name.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574224 = path.getOrDefault("resourceGroupName")
  valid_574224 = validateParameter(valid_574224, JString, required = true,
                                 default = nil)
  if valid_574224 != nil:
    section.add "resourceGroupName", valid_574224
  var valid_574225 = path.getOrDefault("subscriptionId")
  valid_574225 = validateParameter(valid_574225, JString, required = true,
                                 default = nil)
  if valid_574225 != nil:
    section.add "subscriptionId", valid_574225
  var valid_574226 = path.getOrDefault("experimentName")
  valid_574226 = validateParameter(valid_574226, JString, required = true,
                                 default = nil)
  if valid_574226 != nil:
    section.add "experimentName", valid_574226
  var valid_574227 = path.getOrDefault("workspaceName")
  valid_574227 = validateParameter(valid_574227, JString, required = true,
                                 default = nil)
  if valid_574227 != nil:
    section.add "workspaceName", valid_574227
  result.add "path", section
  ## parameters in `query` object:
  ##   runId: JString
  ##        : A run id. If not supplied a run id will be created automatically.
  section = newJObject()
  var valid_574228 = query.getOrDefault("runId")
  valid_574228 = validateParameter(valid_574228, JString, required = false,
                                 default = nil)
  if valid_574228 != nil:
    section.add "runId", valid_574228
  result.add "query", section
  section = newJObject()
  result.add "header", section
  ## parameters in `formData` object:
  ##   projectZipFile: JString (required)
  ##                 : The zip archive of the project folder containing the source code to use for the run.
  ##   runDefinitionFile: JString (required)
  ##                    : The JSON file containing the RunDefinition
  section = newJObject()
  assert formData != nil,
        "formData argument is necessary due to required `projectZipFile` field"
  var valid_574229 = formData.getOrDefault("projectZipFile")
  valid_574229 = validateParameter(valid_574229, JString, required = true,
                                 default = nil)
  if valid_574229 != nil:
    section.add "projectZipFile", valid_574229
  var valid_574230 = formData.getOrDefault("runDefinitionFile")
  valid_574230 = validateParameter(valid_574230, JString, required = true,
                                 default = nil)
  if valid_574230 != nil:
    section.add "runDefinitionFile", valid_574230
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574231: Call_ExecutionStartRun_574221; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts an experiment run using the provided definition.json file to define the run.
  ##             The source code and configuration is defined in a zip archive in project.zip.
  ## 
  let valid = call_574231.validator(path, query, header, formData, body)
  let scheme = call_574231.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574231.url(scheme.get, call_574231.host, call_574231.base,
                         call_574231.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574231, url, valid)

proc call*(call_574232: Call_ExecutionStartRun_574221; resourceGroupName: string;
          subscriptionId: string; experimentName: string; workspaceName: string;
          projectZipFile: string; runDefinitionFile: string; runId: string = ""): Recallable =
  ## executionStartRun
  ## Starts an experiment run using the provided definition.json file to define the run.
  ##             The source code and configuration is defined in a zip archive in project.zip.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   runId: string
  ##        : A run id. If not supplied a run id will be created automatically.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   experimentName: string (required)
  ##                 : The experiment name.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   projectZipFile: string (required)
  ##                 : The zip archive of the project folder containing the source code to use for the run.
  ##   runDefinitionFile: string (required)
  ##                    : The JSON file containing the RunDefinition
  var path_574233 = newJObject()
  var query_574234 = newJObject()
  var formData_574235 = newJObject()
  add(path_574233, "resourceGroupName", newJString(resourceGroupName))
  add(query_574234, "runId", newJString(runId))
  add(path_574233, "subscriptionId", newJString(subscriptionId))
  add(path_574233, "experimentName", newJString(experimentName))
  add(path_574233, "workspaceName", newJString(workspaceName))
  add(formData_574235, "projectZipFile", newJString(projectZipFile))
  add(formData_574235, "runDefinitionFile", newJString(runDefinitionFile))
  result = call_574232.call(path_574233, query_574234, nil, formData_574235, nil)

var executionStartRun* = Call_ExecutionStartRun_574221(name: "executionStartRun",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/execution/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/experiments/{experimentName}/startrun",
    validator: validate_ExecutionStartRun_574222, base: "",
    url: url_ExecutionStartRun_574223, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
