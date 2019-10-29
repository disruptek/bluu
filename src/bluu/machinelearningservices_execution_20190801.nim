
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

  OpenApiRestCall_563555 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563555](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563555): Option[Scheme] {.used.} =
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
  macServiceName = "machinelearningservices-execution"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ExecutionCancelRunWithUri_563777 = ref object of OpenApiRestCall_563555
proc url_ExecutionCancelRunWithUri_563779(protocol: Scheme; host: string;
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

proc validate_ExecutionCancelRunWithUri_563778(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Cancels a run within an experiment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   runId: JString (required)
  ##        : The id of the run to cancel.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   experimentName: JString (required)
  ##                 : The experiment name.
  ##   resourceGroupName: JString (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `runId` field"
  var valid_563954 = path.getOrDefault("runId")
  valid_563954 = validateParameter(valid_563954, JString, required = true,
                                 default = nil)
  if valid_563954 != nil:
    section.add "runId", valid_563954
  var valid_563955 = path.getOrDefault("subscriptionId")
  valid_563955 = validateParameter(valid_563955, JString, required = true,
                                 default = nil)
  if valid_563955 != nil:
    section.add "subscriptionId", valid_563955
  var valid_563956 = path.getOrDefault("experimentName")
  valid_563956 = validateParameter(valid_563956, JString, required = true,
                                 default = nil)
  if valid_563956 != nil:
    section.add "experimentName", valid_563956
  var valid_563957 = path.getOrDefault("resourceGroupName")
  valid_563957 = validateParameter(valid_563957, JString, required = true,
                                 default = nil)
  if valid_563957 != nil:
    section.add "resourceGroupName", valid_563957
  var valid_563958 = path.getOrDefault("workspaceName")
  valid_563958 = validateParameter(valid_563958, JString, required = true,
                                 default = nil)
  if valid_563958 != nil:
    section.add "workspaceName", valid_563958
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563981: Call_ExecutionCancelRunWithUri_563777; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancels a run within an experiment.
  ## 
  let valid = call_563981.validator(path, query, header, formData, body)
  let scheme = call_563981.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563981.url(scheme.get, call_563981.host, call_563981.base,
                         call_563981.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563981, url, valid)

proc call*(call_564052: Call_ExecutionCancelRunWithUri_563777; runId: string;
          subscriptionId: string; experimentName: string; resourceGroupName: string;
          workspaceName: string): Recallable =
  ## executionCancelRunWithUri
  ## Cancels a run within an experiment.
  ##   runId: string (required)
  ##        : The id of the run to cancel.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   experimentName: string (required)
  ##                 : The experiment name.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_564053 = newJObject()
  add(path_564053, "runId", newJString(runId))
  add(path_564053, "subscriptionId", newJString(subscriptionId))
  add(path_564053, "experimentName", newJString(experimentName))
  add(path_564053, "resourceGroupName", newJString(resourceGroupName))
  add(path_564053, "workspaceName", newJString(workspaceName))
  result = call_564052.call(path_564053, nil, nil, nil, nil)

var executionCancelRunWithUri* = Call_ExecutionCancelRunWithUri_563777(
    name: "executionCancelRunWithUri", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/execution/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/experiments/{experimentName}/runId/{runId}/cancel",
    validator: validate_ExecutionCancelRunWithUri_563778, base: "",
    url: url_ExecutionCancelRunWithUri_563779, schemes: {Scheme.Https})
type
  Call_ExecutionStartSnapshotRun_564093 = ref object of OpenApiRestCall_563555
proc url_ExecutionStartSnapshotRun_564095(protocol: Scheme; host: string;
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

proc validate_ExecutionStartSnapshotRun_564094(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Starts an experiment run on the remote compute target using the provided definition.json file to define the run.
  ##             The code for the run is retrieved using the snapshotId in definition.json.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   experimentName: JString (required)
  ##                 : The experiment name.
  ##   resourceGroupName: JString (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564096 = path.getOrDefault("subscriptionId")
  valid_564096 = validateParameter(valid_564096, JString, required = true,
                                 default = nil)
  if valid_564096 != nil:
    section.add "subscriptionId", valid_564096
  var valid_564097 = path.getOrDefault("experimentName")
  valid_564097 = validateParameter(valid_564097, JString, required = true,
                                 default = nil)
  if valid_564097 != nil:
    section.add "experimentName", valid_564097
  var valid_564098 = path.getOrDefault("resourceGroupName")
  valid_564098 = validateParameter(valid_564098, JString, required = true,
                                 default = nil)
  if valid_564098 != nil:
    section.add "resourceGroupName", valid_564098
  var valid_564099 = path.getOrDefault("workspaceName")
  valid_564099 = validateParameter(valid_564099, JString, required = true,
                                 default = nil)
  if valid_564099 != nil:
    section.add "workspaceName", valid_564099
  result.add "path", section
  ## parameters in `query` object:
  ##   runId: JString
  ##        : A run id. If not supplied a run id will be created automatically.
  section = newJObject()
  var valid_564100 = query.getOrDefault("runId")
  valid_564100 = validateParameter(valid_564100, JString, required = false,
                                 default = nil)
  if valid_564100 != nil:
    section.add "runId", valid_564100
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

proc call*(call_564102: Call_ExecutionStartSnapshotRun_564093; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts an experiment run on the remote compute target using the provided definition.json file to define the run.
  ##             The code for the run is retrieved using the snapshotId in definition.json.
  ## 
  let valid = call_564102.validator(path, query, header, formData, body)
  let scheme = call_564102.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564102.url(scheme.get, call_564102.host, call_564102.base,
                         call_564102.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564102, url, valid)

proc call*(call_564103: Call_ExecutionStartSnapshotRun_564093;
          definition: JsonNode; subscriptionId: string; experimentName: string;
          resourceGroupName: string; workspaceName: string; runId: string = ""): Recallable =
  ## executionStartSnapshotRun
  ## Starts an experiment run on the remote compute target using the provided definition.json file to define the run.
  ##             The code for the run is retrieved using the snapshotId in definition.json.
  ##   definition: JObject (required)
  ##             : A JSON run definition structure.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   experimentName: string (required)
  ##                 : The experiment name.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   runId: string
  ##        : A run id. If not supplied a run id will be created automatically.
  var path_564104 = newJObject()
  var query_564105 = newJObject()
  var body_564106 = newJObject()
  if definition != nil:
    body_564106 = definition
  add(path_564104, "subscriptionId", newJString(subscriptionId))
  add(path_564104, "experimentName", newJString(experimentName))
  add(path_564104, "resourceGroupName", newJString(resourceGroupName))
  add(path_564104, "workspaceName", newJString(workspaceName))
  add(query_564105, "runId", newJString(runId))
  result = call_564103.call(path_564104, query_564105, nil, nil, body_564106)

var executionStartSnapshotRun* = Call_ExecutionStartSnapshotRun_564093(
    name: "executionStartSnapshotRun", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/execution/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/experiments/{experimentName}/snapshotrun",
    validator: validate_ExecutionStartSnapshotRun_564094, base: "",
    url: url_ExecutionStartSnapshotRun_564095, schemes: {Scheme.Https})
type
  Call_ExecutionStartLocalRun_564107 = ref object of OpenApiRestCall_563555
proc url_ExecutionStartLocalRun_564109(protocol: Scheme; host: string; base: string;
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

proc validate_ExecutionStartLocalRun_564108(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Starts an experiment run using the provided definition.json file to define the run.
  ##             The source code and configuration is defined in a zip archive in project.zip.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   experimentName: JString (required)
  ##                 : The experiment name.
  ##   resourceGroupName: JString (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564110 = path.getOrDefault("subscriptionId")
  valid_564110 = validateParameter(valid_564110, JString, required = true,
                                 default = nil)
  if valid_564110 != nil:
    section.add "subscriptionId", valid_564110
  var valid_564111 = path.getOrDefault("experimentName")
  valid_564111 = validateParameter(valid_564111, JString, required = true,
                                 default = nil)
  if valid_564111 != nil:
    section.add "experimentName", valid_564111
  var valid_564112 = path.getOrDefault("resourceGroupName")
  valid_564112 = validateParameter(valid_564112, JString, required = true,
                                 default = nil)
  if valid_564112 != nil:
    section.add "resourceGroupName", valid_564112
  var valid_564113 = path.getOrDefault("workspaceName")
  valid_564113 = validateParameter(valid_564113, JString, required = true,
                                 default = nil)
  if valid_564113 != nil:
    section.add "workspaceName", valid_564113
  result.add "path", section
  ## parameters in `query` object:
  ##   runId: JString
  ##        : A run id. If not supplied a run id will be created automatically.
  section = newJObject()
  var valid_564114 = query.getOrDefault("runId")
  valid_564114 = validateParameter(valid_564114, JString, required = false,
                                 default = nil)
  if valid_564114 != nil:
    section.add "runId", valid_564114
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

proc call*(call_564116: Call_ExecutionStartLocalRun_564107; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts an experiment run using the provided definition.json file to define the run.
  ##             The source code and configuration is defined in a zip archive in project.zip.
  ## 
  let valid = call_564116.validator(path, query, header, formData, body)
  let scheme = call_564116.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564116.url(scheme.get, call_564116.host, call_564116.base,
                         call_564116.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564116, url, valid)

proc call*(call_564117: Call_ExecutionStartLocalRun_564107; definition: JsonNode;
          subscriptionId: string; experimentName: string; resourceGroupName: string;
          workspaceName: string; runId: string = ""): Recallable =
  ## executionStartLocalRun
  ## Starts an experiment run using the provided definition.json file to define the run.
  ##             The source code and configuration is defined in a zip archive in project.zip.
  ##   definition: JObject (required)
  ##             : A JSON run definition structure.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   experimentName: string (required)
  ##                 : The experiment name.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   runId: string
  ##        : A run id. If not supplied a run id will be created automatically.
  var path_564118 = newJObject()
  var query_564119 = newJObject()
  var body_564120 = newJObject()
  if definition != nil:
    body_564120 = definition
  add(path_564118, "subscriptionId", newJString(subscriptionId))
  add(path_564118, "experimentName", newJString(experimentName))
  add(path_564118, "resourceGroupName", newJString(resourceGroupName))
  add(path_564118, "workspaceName", newJString(workspaceName))
  add(query_564119, "runId", newJString(runId))
  result = call_564117.call(path_564118, query_564119, nil, nil, body_564120)

var executionStartLocalRun* = Call_ExecutionStartLocalRun_564107(
    name: "executionStartLocalRun", meth: HttpMethod.HttpPost, host: "azure.local", route: "/execution/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/experiments/{experimentName}/startlocalrun",
    validator: validate_ExecutionStartLocalRun_564108, base: "",
    url: url_ExecutionStartLocalRun_564109, schemes: {Scheme.Https})
type
  Call_ExecutionStartRun_564121 = ref object of OpenApiRestCall_563555
proc url_ExecutionStartRun_564123(protocol: Scheme; host: string; base: string;
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

proc validate_ExecutionStartRun_564122(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Starts an experiment run using the provided definition.json file to define the run.
  ##             The source code and configuration is defined in a zip archive in project.zip.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   experimentName: JString (required)
  ##                 : The experiment name.
  ##   resourceGroupName: JString (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564124 = path.getOrDefault("subscriptionId")
  valid_564124 = validateParameter(valid_564124, JString, required = true,
                                 default = nil)
  if valid_564124 != nil:
    section.add "subscriptionId", valid_564124
  var valid_564125 = path.getOrDefault("experimentName")
  valid_564125 = validateParameter(valid_564125, JString, required = true,
                                 default = nil)
  if valid_564125 != nil:
    section.add "experimentName", valid_564125
  var valid_564126 = path.getOrDefault("resourceGroupName")
  valid_564126 = validateParameter(valid_564126, JString, required = true,
                                 default = nil)
  if valid_564126 != nil:
    section.add "resourceGroupName", valid_564126
  var valid_564127 = path.getOrDefault("workspaceName")
  valid_564127 = validateParameter(valid_564127, JString, required = true,
                                 default = nil)
  if valid_564127 != nil:
    section.add "workspaceName", valid_564127
  result.add "path", section
  ## parameters in `query` object:
  ##   runId: JString
  ##        : A run id. If not supplied a run id will be created automatically.
  section = newJObject()
  var valid_564128 = query.getOrDefault("runId")
  valid_564128 = validateParameter(valid_564128, JString, required = false,
                                 default = nil)
  if valid_564128 != nil:
    section.add "runId", valid_564128
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
  var valid_564129 = formData.getOrDefault("projectZipFile")
  valid_564129 = validateParameter(valid_564129, JString, required = true,
                                 default = nil)
  if valid_564129 != nil:
    section.add "projectZipFile", valid_564129
  var valid_564130 = formData.getOrDefault("runDefinitionFile")
  valid_564130 = validateParameter(valid_564130, JString, required = true,
                                 default = nil)
  if valid_564130 != nil:
    section.add "runDefinitionFile", valid_564130
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564131: Call_ExecutionStartRun_564121; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts an experiment run using the provided definition.json file to define the run.
  ##             The source code and configuration is defined in a zip archive in project.zip.
  ## 
  let valid = call_564131.validator(path, query, header, formData, body)
  let scheme = call_564131.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564131.url(scheme.get, call_564131.host, call_564131.base,
                         call_564131.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564131, url, valid)

proc call*(call_564132: Call_ExecutionStartRun_564121; projectZipFile: string;
          subscriptionId: string; experimentName: string; runDefinitionFile: string;
          resourceGroupName: string; workspaceName: string; runId: string = ""): Recallable =
  ## executionStartRun
  ## Starts an experiment run using the provided definition.json file to define the run.
  ##             The source code and configuration is defined in a zip archive in project.zip.
  ##   projectZipFile: string (required)
  ##                 : The zip archive of the project folder containing the source code to use for the run.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   experimentName: string (required)
  ##                 : The experiment name.
  ##   runDefinitionFile: string (required)
  ##                    : The JSON file containing the RunDefinition
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   runId: string
  ##        : A run id. If not supplied a run id will be created automatically.
  var path_564133 = newJObject()
  var query_564134 = newJObject()
  var formData_564135 = newJObject()
  add(formData_564135, "projectZipFile", newJString(projectZipFile))
  add(path_564133, "subscriptionId", newJString(subscriptionId))
  add(path_564133, "experimentName", newJString(experimentName))
  add(formData_564135, "runDefinitionFile", newJString(runDefinitionFile))
  add(path_564133, "resourceGroupName", newJString(resourceGroupName))
  add(path_564133, "workspaceName", newJString(workspaceName))
  add(query_564134, "runId", newJString(runId))
  result = call_564132.call(path_564133, query_564134, nil, formData_564135, nil)

var executionStartRun* = Call_ExecutionStartRun_564121(name: "executionStartRun",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/execution/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/experiments/{experimentName}/startrun",
    validator: validate_ExecutionStartRun_564122, base: "",
    url: url_ExecutionStartRun_564123, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
