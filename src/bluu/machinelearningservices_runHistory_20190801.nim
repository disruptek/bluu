
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: Run History APIs
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

  OpenApiRestCall_573641 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_573641](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_573641): Option[Scheme] {.used.} =
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
  macServiceName = "machinelearningservices-runHistory"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ExperimentsGetById_573863 = ref object of OpenApiRestCall_573641
proc url_ExperimentsGetById_573865(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "experimentId" in path, "`experimentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/history/v1.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/experimentids/"),
               (kind: VariableSegment, value: "experimentId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExperimentsGetById_573864(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Get details of an Experiment with specific Experiment Id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   experimentId: JString (required)
  ##               : The identifier of the experiment.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574038 = path.getOrDefault("resourceGroupName")
  valid_574038 = validateParameter(valid_574038, JString, required = true,
                                 default = nil)
  if valid_574038 != nil:
    section.add "resourceGroupName", valid_574038
  var valid_574039 = path.getOrDefault("subscriptionId")
  valid_574039 = validateParameter(valid_574039, JString, required = true,
                                 default = nil)
  if valid_574039 != nil:
    section.add "subscriptionId", valid_574039
  var valid_574040 = path.getOrDefault("experimentId")
  valid_574040 = validateParameter(valid_574040, JString, required = true,
                                 default = nil)
  if valid_574040 != nil:
    section.add "experimentId", valid_574040
  var valid_574041 = path.getOrDefault("workspaceName")
  valid_574041 = validateParameter(valid_574041, JString, required = true,
                                 default = nil)
  if valid_574041 != nil:
    section.add "workspaceName", valid_574041
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574064: Call_ExperimentsGetById_573863; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get details of an Experiment with specific Experiment Id.
  ## 
  let valid = call_574064.validator(path, query, header, formData, body)
  let scheme = call_574064.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574064.url(scheme.get, call_574064.host, call_574064.base,
                         call_574064.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574064, url, valid)

proc call*(call_574135: Call_ExperimentsGetById_573863; resourceGroupName: string;
          subscriptionId: string; experimentId: string; workspaceName: string): Recallable =
  ## experimentsGetById
  ## Get details of an Experiment with specific Experiment Id.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   experimentId: string (required)
  ##               : The identifier of the experiment.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_574136 = newJObject()
  add(path_574136, "resourceGroupName", newJString(resourceGroupName))
  add(path_574136, "subscriptionId", newJString(subscriptionId))
  add(path_574136, "experimentId", newJString(experimentId))
  add(path_574136, "workspaceName", newJString(workspaceName))
  result = call_574135.call(path_574136, nil, nil, nil, nil)

var experimentsGetById* = Call_ExperimentsGetById_573863(
    name: "experimentsGetById", meth: HttpMethod.HttpGet, host: "azure.local", route: "/history/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/experimentids/{experimentId}",
    validator: validate_ExperimentsGetById_573864, base: "",
    url: url_ExperimentsGetById_573865, schemes: {Scheme.Https})
type
  Call_ExperimentsUpdate_574176 = ref object of OpenApiRestCall_573641
proc url_ExperimentsUpdate_574178(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "experimentId" in path, "`experimentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/history/v1.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/experimentids/"),
               (kind: VariableSegment, value: "experimentId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExperimentsUpdate_574177(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Update details of an Experiment with specific Experiment Id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   experimentId: JString (required)
  ##               : The identifier of the experiment.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574179 = path.getOrDefault("resourceGroupName")
  valid_574179 = validateParameter(valid_574179, JString, required = true,
                                 default = nil)
  if valid_574179 != nil:
    section.add "resourceGroupName", valid_574179
  var valid_574180 = path.getOrDefault("subscriptionId")
  valid_574180 = validateParameter(valid_574180, JString, required = true,
                                 default = nil)
  if valid_574180 != nil:
    section.add "subscriptionId", valid_574180
  var valid_574181 = path.getOrDefault("experimentId")
  valid_574181 = validateParameter(valid_574181, JString, required = true,
                                 default = nil)
  if valid_574181 != nil:
    section.add "experimentId", valid_574181
  var valid_574182 = path.getOrDefault("workspaceName")
  valid_574182 = validateParameter(valid_574182, JString, required = true,
                                 default = nil)
  if valid_574182 != nil:
    section.add "workspaceName", valid_574182
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   modifyExperimentDto: JObject
  ##                      : Experiment details which needs to be updated.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574184: Call_ExperimentsUpdate_574176; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update details of an Experiment with specific Experiment Id.
  ## 
  let valid = call_574184.validator(path, query, header, formData, body)
  let scheme = call_574184.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574184.url(scheme.get, call_574184.host, call_574184.base,
                         call_574184.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574184, url, valid)

proc call*(call_574185: Call_ExperimentsUpdate_574176; resourceGroupName: string;
          subscriptionId: string; experimentId: string; workspaceName: string;
          modifyExperimentDto: JsonNode = nil): Recallable =
  ## experimentsUpdate
  ## Update details of an Experiment with specific Experiment Id.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   experimentId: string (required)
  ##               : The identifier of the experiment.
  ##   modifyExperimentDto: JObject
  ##                      : Experiment details which needs to be updated.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_574186 = newJObject()
  var body_574187 = newJObject()
  add(path_574186, "resourceGroupName", newJString(resourceGroupName))
  add(path_574186, "subscriptionId", newJString(subscriptionId))
  add(path_574186, "experimentId", newJString(experimentId))
  if modifyExperimentDto != nil:
    body_574187 = modifyExperimentDto
  add(path_574186, "workspaceName", newJString(workspaceName))
  result = call_574185.call(path_574186, nil, nil, nil, body_574187)

var experimentsUpdate* = Call_ExperimentsUpdate_574176(name: "experimentsUpdate",
    meth: HttpMethod.HttpPatch, host: "azure.local", route: "/history/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/experimentids/{experimentId}",
    validator: validate_ExperimentsUpdate_574177, base: "",
    url: url_ExperimentsUpdate_574178, schemes: {Scheme.Https})
type
  Call_ExperimentsDeleteTags_574188 = ref object of OpenApiRestCall_573641
proc url_ExperimentsDeleteTags_574190(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "experimentId" in path, "`experimentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/history/v1.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/experimentids/"),
               (kind: VariableSegment, value: "experimentId"),
               (kind: ConstantSegment, value: "/tags")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExperimentsDeleteTags_574189(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete list of Tags from a specific Experiment Id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   experimentId: JString (required)
  ##               : The identifier of the experiment.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574191 = path.getOrDefault("resourceGroupName")
  valid_574191 = validateParameter(valid_574191, JString, required = true,
                                 default = nil)
  if valid_574191 != nil:
    section.add "resourceGroupName", valid_574191
  var valid_574192 = path.getOrDefault("subscriptionId")
  valid_574192 = validateParameter(valid_574192, JString, required = true,
                                 default = nil)
  if valid_574192 != nil:
    section.add "subscriptionId", valid_574192
  var valid_574193 = path.getOrDefault("experimentId")
  valid_574193 = validateParameter(valid_574193, JString, required = true,
                                 default = nil)
  if valid_574193 != nil:
    section.add "experimentId", valid_574193
  var valid_574194 = path.getOrDefault("workspaceName")
  valid_574194 = validateParameter(valid_574194, JString, required = true,
                                 default = nil)
  if valid_574194 != nil:
    section.add "workspaceName", valid_574194
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   tags: JObject
  ##       : The requested tags list to be deleted.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574196: Call_ExperimentsDeleteTags_574188; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete list of Tags from a specific Experiment Id.
  ## 
  let valid = call_574196.validator(path, query, header, formData, body)
  let scheme = call_574196.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574196.url(scheme.get, call_574196.host, call_574196.base,
                         call_574196.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574196, url, valid)

proc call*(call_574197: Call_ExperimentsDeleteTags_574188;
          resourceGroupName: string; subscriptionId: string; experimentId: string;
          workspaceName: string; tags: JsonNode = nil): Recallable =
  ## experimentsDeleteTags
  ## Delete list of Tags from a specific Experiment Id.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   experimentId: string (required)
  ##               : The identifier of the experiment.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   tags: JObject
  ##       : The requested tags list to be deleted.
  var path_574198 = newJObject()
  var body_574199 = newJObject()
  add(path_574198, "resourceGroupName", newJString(resourceGroupName))
  add(path_574198, "subscriptionId", newJString(subscriptionId))
  add(path_574198, "experimentId", newJString(experimentId))
  add(path_574198, "workspaceName", newJString(workspaceName))
  if tags != nil:
    body_574199 = tags
  result = call_574197.call(path_574198, nil, nil, nil, body_574199)

var experimentsDeleteTags* = Call_ExperimentsDeleteTags_574188(
    name: "experimentsDeleteTags", meth: HttpMethod.HttpDelete, host: "azure.local", route: "/history/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/experimentids/{experimentId}/tags",
    validator: validate_ExperimentsDeleteTags_574189, base: "",
    url: url_ExperimentsDeleteTags_574190, schemes: {Scheme.Https})
type
  Call_ExperimentsCreate_574210 = ref object of OpenApiRestCall_573641
proc url_ExperimentsCreate_574212(protocol: Scheme; host: string; base: string;
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
    segments = @[(kind: ConstantSegment, value: "/history/v1.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/experiments/"),
               (kind: VariableSegment, value: "experimentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExperimentsCreate_574211(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Create a new Experiment.
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
  var valid_574213 = path.getOrDefault("resourceGroupName")
  valid_574213 = validateParameter(valid_574213, JString, required = true,
                                 default = nil)
  if valid_574213 != nil:
    section.add "resourceGroupName", valid_574213
  var valid_574214 = path.getOrDefault("subscriptionId")
  valid_574214 = validateParameter(valid_574214, JString, required = true,
                                 default = nil)
  if valid_574214 != nil:
    section.add "subscriptionId", valid_574214
  var valid_574215 = path.getOrDefault("experimentName")
  valid_574215 = validateParameter(valid_574215, JString, required = true,
                                 default = nil)
  if valid_574215 != nil:
    section.add "experimentName", valid_574215
  var valid_574216 = path.getOrDefault("workspaceName")
  valid_574216 = validateParameter(valid_574216, JString, required = true,
                                 default = nil)
  if valid_574216 != nil:
    section.add "workspaceName", valid_574216
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574217: Call_ExperimentsCreate_574210; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a new Experiment.
  ## 
  let valid = call_574217.validator(path, query, header, formData, body)
  let scheme = call_574217.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574217.url(scheme.get, call_574217.host, call_574217.base,
                         call_574217.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574217, url, valid)

proc call*(call_574218: Call_ExperimentsCreate_574210; resourceGroupName: string;
          subscriptionId: string; experimentName: string; workspaceName: string): Recallable =
  ## experimentsCreate
  ## Create a new Experiment.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   experimentName: string (required)
  ##                 : The experiment name.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_574219 = newJObject()
  add(path_574219, "resourceGroupName", newJString(resourceGroupName))
  add(path_574219, "subscriptionId", newJString(subscriptionId))
  add(path_574219, "experimentName", newJString(experimentName))
  add(path_574219, "workspaceName", newJString(workspaceName))
  result = call_574218.call(path_574219, nil, nil, nil, nil)

var experimentsCreate* = Call_ExperimentsCreate_574210(name: "experimentsCreate",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/history/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/experiments/{experimentName}",
    validator: validate_ExperimentsCreate_574211, base: "",
    url: url_ExperimentsCreate_574212, schemes: {Scheme.Https})
type
  Call_ExperimentsGet_574200 = ref object of OpenApiRestCall_573641
proc url_ExperimentsGet_574202(protocol: Scheme; host: string; base: string;
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
    segments = @[(kind: ConstantSegment, value: "/history/v1.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/experiments/"),
               (kind: VariableSegment, value: "experimentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExperimentsGet_574201(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Get details of an Experiment with specific Experiment name.
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
  var valid_574203 = path.getOrDefault("resourceGroupName")
  valid_574203 = validateParameter(valid_574203, JString, required = true,
                                 default = nil)
  if valid_574203 != nil:
    section.add "resourceGroupName", valid_574203
  var valid_574204 = path.getOrDefault("subscriptionId")
  valid_574204 = validateParameter(valid_574204, JString, required = true,
                                 default = nil)
  if valid_574204 != nil:
    section.add "subscriptionId", valid_574204
  var valid_574205 = path.getOrDefault("experimentName")
  valid_574205 = validateParameter(valid_574205, JString, required = true,
                                 default = nil)
  if valid_574205 != nil:
    section.add "experimentName", valid_574205
  var valid_574206 = path.getOrDefault("workspaceName")
  valid_574206 = validateParameter(valid_574206, JString, required = true,
                                 default = nil)
  if valid_574206 != nil:
    section.add "workspaceName", valid_574206
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574207: Call_ExperimentsGet_574200; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get details of an Experiment with specific Experiment name.
  ## 
  let valid = call_574207.validator(path, query, header, formData, body)
  let scheme = call_574207.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574207.url(scheme.get, call_574207.host, call_574207.base,
                         call_574207.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574207, url, valid)

proc call*(call_574208: Call_ExperimentsGet_574200; resourceGroupName: string;
          subscriptionId: string; experimentName: string; workspaceName: string): Recallable =
  ## experimentsGet
  ## Get details of an Experiment with specific Experiment name.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   experimentName: string (required)
  ##                 : The experiment name.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_574209 = newJObject()
  add(path_574209, "resourceGroupName", newJString(resourceGroupName))
  add(path_574209, "subscriptionId", newJString(subscriptionId))
  add(path_574209, "experimentName", newJString(experimentName))
  add(path_574209, "workspaceName", newJString(workspaceName))
  result = call_574208.call(path_574209, nil, nil, nil, nil)

var experimentsGet* = Call_ExperimentsGet_574200(name: "experimentsGet",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/history/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/experiments/{experimentName}",
    validator: validate_ExperimentsGet_574201, base: "", url: url_ExperimentsGet_574202,
    schemes: {Scheme.Https})
type
  Call_EventsBatchPost_574220 = ref object of OpenApiRestCall_573641
proc url_EventsBatchPost_574222(protocol: Scheme; host: string; base: string;
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
    segments = @[(kind: ConstantSegment, value: "/history/v1.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/experiments/"),
               (kind: VariableSegment, value: "experimentName"),
               (kind: ConstantSegment, value: "/batch/events")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EventsBatchPost_574221(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Post event data to a specific Run Id.
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
  var valid_574223 = path.getOrDefault("resourceGroupName")
  valid_574223 = validateParameter(valid_574223, JString, required = true,
                                 default = nil)
  if valid_574223 != nil:
    section.add "resourceGroupName", valid_574223
  var valid_574224 = path.getOrDefault("subscriptionId")
  valid_574224 = validateParameter(valid_574224, JString, required = true,
                                 default = nil)
  if valid_574224 != nil:
    section.add "subscriptionId", valid_574224
  var valid_574225 = path.getOrDefault("experimentName")
  valid_574225 = validateParameter(valid_574225, JString, required = true,
                                 default = nil)
  if valid_574225 != nil:
    section.add "experimentName", valid_574225
  var valid_574226 = path.getOrDefault("workspaceName")
  valid_574226 = validateParameter(valid_574226, JString, required = true,
                                 default = nil)
  if valid_574226 != nil:
    section.add "workspaceName", valid_574226
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   batchEventCommand: JObject
  ##                    : The batch of Event details.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574228: Call_EventsBatchPost_574220; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Post event data to a specific Run Id.
  ## 
  let valid = call_574228.validator(path, query, header, formData, body)
  let scheme = call_574228.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574228.url(scheme.get, call_574228.host, call_574228.base,
                         call_574228.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574228, url, valid)

proc call*(call_574229: Call_EventsBatchPost_574220; resourceGroupName: string;
          subscriptionId: string; experimentName: string; workspaceName: string;
          batchEventCommand: JsonNode = nil): Recallable =
  ## eventsBatchPost
  ## Post event data to a specific Run Id.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   batchEventCommand: JObject
  ##                    : The batch of Event details.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   experimentName: string (required)
  ##                 : The experiment name.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_574230 = newJObject()
  var body_574231 = newJObject()
  add(path_574230, "resourceGroupName", newJString(resourceGroupName))
  if batchEventCommand != nil:
    body_574231 = batchEventCommand
  add(path_574230, "subscriptionId", newJString(subscriptionId))
  add(path_574230, "experimentName", newJString(experimentName))
  add(path_574230, "workspaceName", newJString(workspaceName))
  result = call_574229.call(path_574230, nil, nil, nil, body_574231)

var eventsBatchPost* = Call_EventsBatchPost_574220(name: "eventsBatchPost",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/history/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/experiments/{experimentName}/batch/events",
    validator: validate_EventsBatchPost_574221, base: "", url: url_EventsBatchPost_574222,
    schemes: {Scheme.Https})
type
  Call_RunsBatchAddOrModify_574232 = ref object of OpenApiRestCall_573641
proc url_RunsBatchAddOrModify_574234(protocol: Scheme; host: string; base: string;
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
    segments = @[(kind: ConstantSegment, value: "/history/v1.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/experiments/"),
               (kind: VariableSegment, value: "experimentName"),
               (kind: ConstantSegment, value: "/batch/runs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunsBatchAddOrModify_574233(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Add or Modify a batch of Runs for a given experiment.
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
  var valid_574235 = path.getOrDefault("resourceGroupName")
  valid_574235 = validateParameter(valid_574235, JString, required = true,
                                 default = nil)
  if valid_574235 != nil:
    section.add "resourceGroupName", valid_574235
  var valid_574236 = path.getOrDefault("subscriptionId")
  valid_574236 = validateParameter(valid_574236, JString, required = true,
                                 default = nil)
  if valid_574236 != nil:
    section.add "subscriptionId", valid_574236
  var valid_574237 = path.getOrDefault("experimentName")
  valid_574237 = validateParameter(valid_574237, JString, required = true,
                                 default = nil)
  if valid_574237 != nil:
    section.add "experimentName", valid_574237
  var valid_574238 = path.getOrDefault("workspaceName")
  valid_574238 = validateParameter(valid_574238, JString, required = true,
                                 default = nil)
  if valid_574238 != nil:
    section.add "workspaceName", valid_574238
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   requestDto: JObject
  ##             : The list of requested Run Additions/modifications in an Experiment.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574240: Call_RunsBatchAddOrModify_574232; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Add or Modify a batch of Runs for a given experiment.
  ## 
  let valid = call_574240.validator(path, query, header, formData, body)
  let scheme = call_574240.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574240.url(scheme.get, call_574240.host, call_574240.base,
                         call_574240.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574240, url, valid)

proc call*(call_574241: Call_RunsBatchAddOrModify_574232;
          resourceGroupName: string; subscriptionId: string; experimentName: string;
          workspaceName: string; requestDto: JsonNode = nil): Recallable =
  ## runsBatchAddOrModify
  ## Add or Modify a batch of Runs for a given experiment.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   requestDto: JObject
  ##             : The list of requested Run Additions/modifications in an Experiment.
  ##   experimentName: string (required)
  ##                 : The experiment name.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_574242 = newJObject()
  var body_574243 = newJObject()
  add(path_574242, "resourceGroupName", newJString(resourceGroupName))
  add(path_574242, "subscriptionId", newJString(subscriptionId))
  if requestDto != nil:
    body_574243 = requestDto
  add(path_574242, "experimentName", newJString(experimentName))
  add(path_574242, "workspaceName", newJString(workspaceName))
  result = call_574241.call(path_574242, nil, nil, nil, body_574243)

var runsBatchAddOrModify* = Call_RunsBatchAddOrModify_574232(
    name: "runsBatchAddOrModify", meth: HttpMethod.HttpPatch, host: "azure.local", route: "/history/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/experiments/{experimentName}/batch/runs",
    validator: validate_RunsBatchAddOrModify_574233, base: "",
    url: url_RunsBatchAddOrModify_574234, schemes: {Scheme.Https})
type
  Call_RunMetricsGet_574244 = ref object of OpenApiRestCall_573641
proc url_RunMetricsGet_574246(protocol: Scheme; host: string; base: string;
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
  assert "metricId" in path, "`metricId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/history/v1.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/experiments/"),
               (kind: VariableSegment, value: "experimentName"),
               (kind: ConstantSegment, value: "/metrics/"),
               (kind: VariableSegment, value: "metricId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunMetricsGet_574245(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Get Metric details for a specific Metric Id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   metricId: JString (required)
  ##           : The identifier for a Metric.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   experimentName: JString (required)
  ##                 : The experiment name.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574247 = path.getOrDefault("resourceGroupName")
  valid_574247 = validateParameter(valid_574247, JString, required = true,
                                 default = nil)
  if valid_574247 != nil:
    section.add "resourceGroupName", valid_574247
  var valid_574248 = path.getOrDefault("metricId")
  valid_574248 = validateParameter(valid_574248, JString, required = true,
                                 default = nil)
  if valid_574248 != nil:
    section.add "metricId", valid_574248
  var valid_574249 = path.getOrDefault("subscriptionId")
  valid_574249 = validateParameter(valid_574249, JString, required = true,
                                 default = nil)
  if valid_574249 != nil:
    section.add "subscriptionId", valid_574249
  var valid_574250 = path.getOrDefault("experimentName")
  valid_574250 = validateParameter(valid_574250, JString, required = true,
                                 default = nil)
  if valid_574250 != nil:
    section.add "experimentName", valid_574250
  var valid_574251 = path.getOrDefault("workspaceName")
  valid_574251 = validateParameter(valid_574251, JString, required = true,
                                 default = nil)
  if valid_574251 != nil:
    section.add "workspaceName", valid_574251
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574252: Call_RunMetricsGet_574244; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get Metric details for a specific Metric Id.
  ## 
  let valid = call_574252.validator(path, query, header, formData, body)
  let scheme = call_574252.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574252.url(scheme.get, call_574252.host, call_574252.base,
                         call_574252.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574252, url, valid)

proc call*(call_574253: Call_RunMetricsGet_574244; resourceGroupName: string;
          metricId: string; subscriptionId: string; experimentName: string;
          workspaceName: string): Recallable =
  ## runMetricsGet
  ## Get Metric details for a specific Metric Id.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   metricId: string (required)
  ##           : The identifier for a Metric.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   experimentName: string (required)
  ##                 : The experiment name.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_574254 = newJObject()
  add(path_574254, "resourceGroupName", newJString(resourceGroupName))
  add(path_574254, "metricId", newJString(metricId))
  add(path_574254, "subscriptionId", newJString(subscriptionId))
  add(path_574254, "experimentName", newJString(experimentName))
  add(path_574254, "workspaceName", newJString(workspaceName))
  result = call_574253.call(path_574254, nil, nil, nil, nil)

var runMetricsGet* = Call_RunMetricsGet_574244(name: "runMetricsGet",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/history/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/experiments/{experimentName}/metrics/{metricId}",
    validator: validate_RunMetricsGet_574245, base: "", url: url_RunMetricsGet_574246,
    schemes: {Scheme.Https})
type
  Call_RunMetricsGetByQuery_574255 = ref object of OpenApiRestCall_573641
proc url_RunMetricsGetByQuery_574257(protocol: Scheme; host: string; base: string;
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
    segments = @[(kind: ConstantSegment, value: "/history/v1.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/experiments/"),
               (kind: VariableSegment, value: "experimentName"),
               (kind: ConstantSegment, value: "/metrics:query")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunMetricsGetByQuery_574256(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get all Run Metrics for the specific Experiment with the specified query filters.
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
  var valid_574258 = path.getOrDefault("resourceGroupName")
  valid_574258 = validateParameter(valid_574258, JString, required = true,
                                 default = nil)
  if valid_574258 != nil:
    section.add "resourceGroupName", valid_574258
  var valid_574259 = path.getOrDefault("subscriptionId")
  valid_574259 = validateParameter(valid_574259, JString, required = true,
                                 default = nil)
  if valid_574259 != nil:
    section.add "subscriptionId", valid_574259
  var valid_574260 = path.getOrDefault("experimentName")
  valid_574260 = validateParameter(valid_574260, JString, required = true,
                                 default = nil)
  if valid_574260 != nil:
    section.add "experimentName", valid_574260
  var valid_574261 = path.getOrDefault("workspaceName")
  valid_574261 = validateParameter(valid_574261, JString, required = true,
                                 default = nil)
  if valid_574261 != nil:
    section.add "workspaceName", valid_574261
  result.add "path", section
  ## parameters in `query` object:
  ##   MergeStrategyOptions: JString
  ##                       : Controls behavior of the merge strategy in certain cases; e.g. when a metric is not merged.
  ##   MergeStrategySettings.Version: JString
  ##                                : The strategy settings version.
  ##   MergeStrategySettings.SelectMetrics: JString
  ##                                      : Defines how to select metrics when merging them together.
  ##   MergeStrategyType: JString
  ##                    : The type of merge strategy. Currently supported strategies are:
  ## None - all logged values are returned as individual metrics.
  ## MergeToVector - merges multiple values into a vector of values.
  ## Default - the system determines the behavior.
  section = newJObject()
  var valid_574275 = query.getOrDefault("MergeStrategyOptions")
  valid_574275 = validateParameter(valid_574275, JString, required = false,
                                 default = newJString("None"))
  if valid_574275 != nil:
    section.add "MergeStrategyOptions", valid_574275
  var valid_574276 = query.getOrDefault("MergeStrategySettings.Version")
  valid_574276 = validateParameter(valid_574276, JString, required = false,
                                 default = nil)
  if valid_574276 != nil:
    section.add "MergeStrategySettings.Version", valid_574276
  var valid_574277 = query.getOrDefault("MergeStrategySettings.SelectMetrics")
  valid_574277 = validateParameter(valid_574277, JString, required = false,
                                 default = newJString("SelectAll"))
  if valid_574277 != nil:
    section.add "MergeStrategySettings.SelectMetrics", valid_574277
  var valid_574278 = query.getOrDefault("MergeStrategyType")
  valid_574278 = validateParameter(valid_574278, JString, required = false,
                                 default = newJString("Default"))
  if valid_574278 != nil:
    section.add "MergeStrategyType", valid_574278
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   queryParams: JObject
  ##              : Query Parameters for data sorting and filtering.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574280: Call_RunMetricsGetByQuery_574255; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all Run Metrics for the specific Experiment with the specified query filters.
  ## 
  let valid = call_574280.validator(path, query, header, formData, body)
  let scheme = call_574280.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574280.url(scheme.get, call_574280.host, call_574280.base,
                         call_574280.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574280, url, valid)

proc call*(call_574281: Call_RunMetricsGetByQuery_574255;
          resourceGroupName: string; subscriptionId: string; experimentName: string;
          workspaceName: string; queryParams: JsonNode = nil;
          MergeStrategyOptions: string = "None";
          MergeStrategySettingsVersion: string = "";
          MergeStrategySettingsSelectMetrics: string = "SelectAll";
          MergeStrategyType: string = "Default"): Recallable =
  ## runMetricsGetByQuery
  ## Get all Run Metrics for the specific Experiment with the specified query filters.
  ##   queryParams: JObject
  ##              : Query Parameters for data sorting and filtering.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   MergeStrategyOptions: string
  ##                       : Controls behavior of the merge strategy in certain cases; e.g. when a metric is not merged.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   MergeStrategySettingsVersion: string
  ##                               : The strategy settings version.
  ##   MergeStrategySettingsSelectMetrics: string
  ##                                     : Defines how to select metrics when merging them together.
  ##   MergeStrategyType: string
  ##                    : The type of merge strategy. Currently supported strategies are:
  ## None - all logged values are returned as individual metrics.
  ## MergeToVector - merges multiple values into a vector of values.
  ## Default - the system determines the behavior.
  ##   experimentName: string (required)
  ##                 : The experiment name.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_574282 = newJObject()
  var query_574283 = newJObject()
  var body_574284 = newJObject()
  if queryParams != nil:
    body_574284 = queryParams
  add(path_574282, "resourceGroupName", newJString(resourceGroupName))
  add(query_574283, "MergeStrategyOptions", newJString(MergeStrategyOptions))
  add(path_574282, "subscriptionId", newJString(subscriptionId))
  add(query_574283, "MergeStrategySettings.Version",
      newJString(MergeStrategySettingsVersion))
  add(query_574283, "MergeStrategySettings.SelectMetrics",
      newJString(MergeStrategySettingsSelectMetrics))
  add(query_574283, "MergeStrategyType", newJString(MergeStrategyType))
  add(path_574282, "experimentName", newJString(experimentName))
  add(path_574282, "workspaceName", newJString(workspaceName))
  result = call_574281.call(path_574282, query_574283, nil, nil, body_574284)

var runMetricsGetByQuery* = Call_RunMetricsGetByQuery_574255(
    name: "runMetricsGetByQuery", meth: HttpMethod.HttpPost, host: "azure.local", route: "/history/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/experiments/{experimentName}/metrics:query",
    validator: validate_RunMetricsGetByQuery_574256, base: "",
    url: url_RunMetricsGetByQuery_574257, schemes: {Scheme.Https})
type
  Call_RunsGet_574285 = ref object of OpenApiRestCall_573641
proc url_RunsGet_574287(protocol: Scheme; host: string; base: string; route: string;
                       path: JsonNode; query: JsonNode): Uri =
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
    segments = @[(kind: ConstantSegment, value: "/history/v1.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/experiments/"),
               (kind: VariableSegment, value: "experimentName"),
               (kind: ConstantSegment, value: "/runs/"),
               (kind: VariableSegment, value: "runId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunsGet_574286(path: JsonNode; query: JsonNode; header: JsonNode;
                            formData: JsonNode; body: JsonNode): JsonNode =
  ## Get Run details of a specific Run Id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   runId: JString (required)
  ##        : The identifier of the Run.
  ##   experimentName: JString (required)
  ##                 : The experiment name.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574288 = path.getOrDefault("resourceGroupName")
  valid_574288 = validateParameter(valid_574288, JString, required = true,
                                 default = nil)
  if valid_574288 != nil:
    section.add "resourceGroupName", valid_574288
  var valid_574289 = path.getOrDefault("subscriptionId")
  valid_574289 = validateParameter(valid_574289, JString, required = true,
                                 default = nil)
  if valid_574289 != nil:
    section.add "subscriptionId", valid_574289
  var valid_574290 = path.getOrDefault("runId")
  valid_574290 = validateParameter(valid_574290, JString, required = true,
                                 default = nil)
  if valid_574290 != nil:
    section.add "runId", valid_574290
  var valid_574291 = path.getOrDefault("experimentName")
  valid_574291 = validateParameter(valid_574291, JString, required = true,
                                 default = nil)
  if valid_574291 != nil:
    section.add "experimentName", valid_574291
  var valid_574292 = path.getOrDefault("workspaceName")
  valid_574292 = validateParameter(valid_574292, JString, required = true,
                                 default = nil)
  if valid_574292 != nil:
    section.add "workspaceName", valid_574292
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574293: Call_RunsGet_574285; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get Run details of a specific Run Id.
  ## 
  let valid = call_574293.validator(path, query, header, formData, body)
  let scheme = call_574293.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574293.url(scheme.get, call_574293.host, call_574293.base,
                         call_574293.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574293, url, valid)

proc call*(call_574294: Call_RunsGet_574285; resourceGroupName: string;
          subscriptionId: string; runId: string; experimentName: string;
          workspaceName: string): Recallable =
  ## runsGet
  ## Get Run details of a specific Run Id.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   runId: string (required)
  ##        : The identifier of the Run.
  ##   experimentName: string (required)
  ##                 : The experiment name.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_574295 = newJObject()
  add(path_574295, "resourceGroupName", newJString(resourceGroupName))
  add(path_574295, "subscriptionId", newJString(subscriptionId))
  add(path_574295, "runId", newJString(runId))
  add(path_574295, "experimentName", newJString(experimentName))
  add(path_574295, "workspaceName", newJString(workspaceName))
  result = call_574294.call(path_574295, nil, nil, nil, nil)

var runsGet* = Call_RunsGet_574285(name: "runsGet", meth: HttpMethod.HttpGet,
                                host: "azure.local", route: "/history/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/experiments/{experimentName}/runs/{runId}",
                                validator: validate_RunsGet_574286, base: "",
                                url: url_RunsGet_574287, schemes: {Scheme.Https})
type
  Call_RunsPatch_574296 = ref object of OpenApiRestCall_573641
proc url_RunsPatch_574298(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
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
    segments = @[(kind: ConstantSegment, value: "/history/v1.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/experiments/"),
               (kind: VariableSegment, value: "experimentName"),
               (kind: ConstantSegment, value: "/runs/"),
               (kind: VariableSegment, value: "runId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunsPatch_574297(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Add a new Run or Modify an existing Run.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   runId: JString (required)
  ##        : The identifier of the Run.
  ##   experimentName: JString (required)
  ##                 : The experiment name.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574299 = path.getOrDefault("resourceGroupName")
  valid_574299 = validateParameter(valid_574299, JString, required = true,
                                 default = nil)
  if valid_574299 != nil:
    section.add "resourceGroupName", valid_574299
  var valid_574300 = path.getOrDefault("subscriptionId")
  valid_574300 = validateParameter(valid_574300, JString, required = true,
                                 default = nil)
  if valid_574300 != nil:
    section.add "subscriptionId", valid_574300
  var valid_574301 = path.getOrDefault("runId")
  valid_574301 = validateParameter(valid_574301, JString, required = true,
                                 default = nil)
  if valid_574301 != nil:
    section.add "runId", valid_574301
  var valid_574302 = path.getOrDefault("experimentName")
  valid_574302 = validateParameter(valid_574302, JString, required = true,
                                 default = nil)
  if valid_574302 != nil:
    section.add "experimentName", valid_574302
  var valid_574303 = path.getOrDefault("workspaceName")
  valid_574303 = validateParameter(valid_574303, JString, required = true,
                                 default = nil)
  if valid_574303 != nil:
    section.add "workspaceName", valid_574303
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   createRunDto: JObject
  ##               : The requested Run parameter Additions/modifications.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574305: Call_RunsPatch_574296; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Add a new Run or Modify an existing Run.
  ## 
  let valid = call_574305.validator(path, query, header, formData, body)
  let scheme = call_574305.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574305.url(scheme.get, call_574305.host, call_574305.base,
                         call_574305.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574305, url, valid)

proc call*(call_574306: Call_RunsPatch_574296; resourceGroupName: string;
          subscriptionId: string; runId: string; experimentName: string;
          workspaceName: string; createRunDto: JsonNode = nil): Recallable =
  ## runsPatch
  ## Add a new Run or Modify an existing Run.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   runId: string (required)
  ##        : The identifier of the Run.
  ##   createRunDto: JObject
  ##               : The requested Run parameter Additions/modifications.
  ##   experimentName: string (required)
  ##                 : The experiment name.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_574307 = newJObject()
  var body_574308 = newJObject()
  add(path_574307, "resourceGroupName", newJString(resourceGroupName))
  add(path_574307, "subscriptionId", newJString(subscriptionId))
  add(path_574307, "runId", newJString(runId))
  if createRunDto != nil:
    body_574308 = createRunDto
  add(path_574307, "experimentName", newJString(experimentName))
  add(path_574307, "workspaceName", newJString(workspaceName))
  result = call_574306.call(path_574307, nil, nil, nil, body_574308)

var runsPatch* = Call_RunsPatch_574296(name: "runsPatch", meth: HttpMethod.HttpPatch,
                                    host: "azure.local", route: "/history/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/experiments/{experimentName}/runs/{runId}",
                                    validator: validate_RunsPatch_574297,
                                    base: "", url: url_RunsPatch_574298,
                                    schemes: {Scheme.Https})
type
  Call_RunArtifactsListInContainer_574309 = ref object of OpenApiRestCall_573641
proc url_RunArtifactsListInContainer_574311(protocol: Scheme; host: string;
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
    segments = @[(kind: ConstantSegment, value: "/history/v1.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/experiments/"),
               (kind: VariableSegment, value: "experimentName"),
               (kind: ConstantSegment, value: "/runs/"),
               (kind: VariableSegment, value: "runId"),
               (kind: ConstantSegment, value: "/artifacts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunArtifactsListInContainer_574310(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get Artifacts in container for a specific Run Id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   runId: JString (required)
  ##        : The identifier of the Run.
  ##   experimentName: JString (required)
  ##                 : The experiment name.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574312 = path.getOrDefault("resourceGroupName")
  valid_574312 = validateParameter(valid_574312, JString, required = true,
                                 default = nil)
  if valid_574312 != nil:
    section.add "resourceGroupName", valid_574312
  var valid_574313 = path.getOrDefault("subscriptionId")
  valid_574313 = validateParameter(valid_574313, JString, required = true,
                                 default = nil)
  if valid_574313 != nil:
    section.add "subscriptionId", valid_574313
  var valid_574314 = path.getOrDefault("runId")
  valid_574314 = validateParameter(valid_574314, JString, required = true,
                                 default = nil)
  if valid_574314 != nil:
    section.add "runId", valid_574314
  var valid_574315 = path.getOrDefault("experimentName")
  valid_574315 = validateParameter(valid_574315, JString, required = true,
                                 default = nil)
  if valid_574315 != nil:
    section.add "experimentName", valid_574315
  var valid_574316 = path.getOrDefault("workspaceName")
  valid_574316 = validateParameter(valid_574316, JString, required = true,
                                 default = nil)
  if valid_574316 != nil:
    section.add "workspaceName", valid_574316
  result.add "path", section
  ## parameters in `query` object:
  ##   continuationToken: JString
  ##                    : The Continuation Token.
  section = newJObject()
  var valid_574317 = query.getOrDefault("continuationToken")
  valid_574317 = validateParameter(valid_574317, JString, required = false,
                                 default = nil)
  if valid_574317 != nil:
    section.add "continuationToken", valid_574317
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574318: Call_RunArtifactsListInContainer_574309; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get Artifacts in container for a specific Run Id.
  ## 
  let valid = call_574318.validator(path, query, header, formData, body)
  let scheme = call_574318.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574318.url(scheme.get, call_574318.host, call_574318.base,
                         call_574318.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574318, url, valid)

proc call*(call_574319: Call_RunArtifactsListInContainer_574309;
          resourceGroupName: string; subscriptionId: string; runId: string;
          experimentName: string; workspaceName: string;
          continuationToken: string = ""): Recallable =
  ## runArtifactsListInContainer
  ## Get Artifacts in container for a specific Run Id.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   runId: string (required)
  ##        : The identifier of the Run.
  ##   continuationToken: string
  ##                    : The Continuation Token.
  ##   experimentName: string (required)
  ##                 : The experiment name.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_574320 = newJObject()
  var query_574321 = newJObject()
  add(path_574320, "resourceGroupName", newJString(resourceGroupName))
  add(path_574320, "subscriptionId", newJString(subscriptionId))
  add(path_574320, "runId", newJString(runId))
  add(query_574321, "continuationToken", newJString(continuationToken))
  add(path_574320, "experimentName", newJString(experimentName))
  add(path_574320, "workspaceName", newJString(workspaceName))
  result = call_574319.call(path_574320, query_574321, nil, nil, nil)

var runArtifactsListInContainer* = Call_RunArtifactsListInContainer_574309(
    name: "runArtifactsListInContainer", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/history/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/experiments/{experimentName}/runs/{runId}/artifacts",
    validator: validate_RunArtifactsListInContainer_574310, base: "",
    url: url_RunArtifactsListInContainer_574311, schemes: {Scheme.Https})
type
  Call_RunArtifactsGetSasUri_574322 = ref object of OpenApiRestCall_573641
proc url_RunArtifactsGetSasUri_574324(protocol: Scheme; host: string; base: string;
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
  assert "runId" in path, "`runId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/history/v1.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/experiments/"),
               (kind: VariableSegment, value: "experimentName"),
               (kind: ConstantSegment, value: "/runs/"),
               (kind: VariableSegment, value: "runId"),
               (kind: ConstantSegment, value: "/artifacts/artifacturi")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunArtifactsGetSasUri_574323(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get URI of an Artifact for a specific Run Id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   runId: JString (required)
  ##        : The identifier of the Run.
  ##   experimentName: JString (required)
  ##                 : The experiment name.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574325 = path.getOrDefault("resourceGroupName")
  valid_574325 = validateParameter(valid_574325, JString, required = true,
                                 default = nil)
  if valid_574325 != nil:
    section.add "resourceGroupName", valid_574325
  var valid_574326 = path.getOrDefault("subscriptionId")
  valid_574326 = validateParameter(valid_574326, JString, required = true,
                                 default = nil)
  if valid_574326 != nil:
    section.add "subscriptionId", valid_574326
  var valid_574327 = path.getOrDefault("runId")
  valid_574327 = validateParameter(valid_574327, JString, required = true,
                                 default = nil)
  if valid_574327 != nil:
    section.add "runId", valid_574327
  var valid_574328 = path.getOrDefault("experimentName")
  valid_574328 = validateParameter(valid_574328, JString, required = true,
                                 default = nil)
  if valid_574328 != nil:
    section.add "experimentName", valid_574328
  var valid_574329 = path.getOrDefault("workspaceName")
  valid_574329 = validateParameter(valid_574329, JString, required = true,
                                 default = nil)
  if valid_574329 != nil:
    section.add "workspaceName", valid_574329
  result.add "path", section
  ## parameters in `query` object:
  ##   path: JString
  ##       : The Artifact Path.
  section = newJObject()
  var valid_574330 = query.getOrDefault("path")
  valid_574330 = validateParameter(valid_574330, JString, required = false,
                                 default = nil)
  if valid_574330 != nil:
    section.add "path", valid_574330
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574331: Call_RunArtifactsGetSasUri_574322; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get URI of an Artifact for a specific Run Id.
  ## 
  let valid = call_574331.validator(path, query, header, formData, body)
  let scheme = call_574331.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574331.url(scheme.get, call_574331.host, call_574331.base,
                         call_574331.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574331, url, valid)

proc call*(call_574332: Call_RunArtifactsGetSasUri_574322;
          resourceGroupName: string; subscriptionId: string; runId: string;
          experimentName: string; workspaceName: string; path: string = ""): Recallable =
  ## runArtifactsGetSasUri
  ## Get URI of an Artifact for a specific Run Id.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   path: string
  ##       : The Artifact Path.
  ##   runId: string (required)
  ##        : The identifier of the Run.
  ##   experimentName: string (required)
  ##                 : The experiment name.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_574333 = newJObject()
  var query_574334 = newJObject()
  add(path_574333, "resourceGroupName", newJString(resourceGroupName))
  add(path_574333, "subscriptionId", newJString(subscriptionId))
  add(query_574334, "path", newJString(path))
  add(path_574333, "runId", newJString(runId))
  add(path_574333, "experimentName", newJString(experimentName))
  add(path_574333, "workspaceName", newJString(workspaceName))
  result = call_574332.call(path_574333, query_574334, nil, nil, nil)

var runArtifactsGetSasUri* = Call_RunArtifactsGetSasUri_574322(
    name: "runArtifactsGetSasUri", meth: HttpMethod.HttpGet, host: "azure.local", route: "/history/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/experiments/{experimentName}/runs/{runId}/artifacts/artifacturi",
    validator: validate_RunArtifactsGetSasUri_574323, base: "",
    url: url_RunArtifactsGetSasUri_574324, schemes: {Scheme.Https})
type
  Call_RunArtifactsBatchCreateEmptyArtifacts_574335 = ref object of OpenApiRestCall_573641
proc url_RunArtifactsBatchCreateEmptyArtifacts_574337(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
    segments = @[(kind: ConstantSegment, value: "/history/v1.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/experiments/"),
               (kind: VariableSegment, value: "experimentName"),
               (kind: ConstantSegment, value: "/runs/"),
               (kind: VariableSegment, value: "runId"),
               (kind: ConstantSegment, value: "/artifacts/batch/metadata")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunArtifactsBatchCreateEmptyArtifacts_574336(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a batch of empty Artifacts in a specific Run.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   runId: JString (required)
  ##        : The identifier of the Run.
  ##   experimentName: JString (required)
  ##                 : The experiment name.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574338 = path.getOrDefault("resourceGroupName")
  valid_574338 = validateParameter(valid_574338, JString, required = true,
                                 default = nil)
  if valid_574338 != nil:
    section.add "resourceGroupName", valid_574338
  var valid_574339 = path.getOrDefault("subscriptionId")
  valid_574339 = validateParameter(valid_574339, JString, required = true,
                                 default = nil)
  if valid_574339 != nil:
    section.add "subscriptionId", valid_574339
  var valid_574340 = path.getOrDefault("runId")
  valid_574340 = validateParameter(valid_574340, JString, required = true,
                                 default = nil)
  if valid_574340 != nil:
    section.add "runId", valid_574340
  var valid_574341 = path.getOrDefault("experimentName")
  valid_574341 = validateParameter(valid_574341, JString, required = true,
                                 default = nil)
  if valid_574341 != nil:
    section.add "experimentName", valid_574341
  var valid_574342 = path.getOrDefault("workspaceName")
  valid_574342 = validateParameter(valid_574342, JString, required = true,
                                 default = nil)
  if valid_574342 != nil:
    section.add "workspaceName", valid_574342
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   artifactPaths: JObject
  ##                : The list of artifact paths.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574344: Call_RunArtifactsBatchCreateEmptyArtifacts_574335;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a batch of empty Artifacts in a specific Run.
  ## 
  let valid = call_574344.validator(path, query, header, formData, body)
  let scheme = call_574344.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574344.url(scheme.get, call_574344.host, call_574344.base,
                         call_574344.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574344, url, valid)

proc call*(call_574345: Call_RunArtifactsBatchCreateEmptyArtifacts_574335;
          resourceGroupName: string; subscriptionId: string; runId: string;
          experimentName: string; workspaceName: string;
          artifactPaths: JsonNode = nil): Recallable =
  ## runArtifactsBatchCreateEmptyArtifacts
  ## Create a batch of empty Artifacts in a specific Run.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   runId: string (required)
  ##        : The identifier of the Run.
  ##   artifactPaths: JObject
  ##                : The list of artifact paths.
  ##   experimentName: string (required)
  ##                 : The experiment name.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_574346 = newJObject()
  var body_574347 = newJObject()
  add(path_574346, "resourceGroupName", newJString(resourceGroupName))
  add(path_574346, "subscriptionId", newJString(subscriptionId))
  add(path_574346, "runId", newJString(runId))
  if artifactPaths != nil:
    body_574347 = artifactPaths
  add(path_574346, "experimentName", newJString(experimentName))
  add(path_574346, "workspaceName", newJString(workspaceName))
  result = call_574345.call(path_574346, nil, nil, nil, body_574347)

var runArtifactsBatchCreateEmptyArtifacts* = Call_RunArtifactsBatchCreateEmptyArtifacts_574335(
    name: "runArtifactsBatchCreateEmptyArtifacts", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/history/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/experiments/{experimentName}/runs/{runId}/artifacts/batch/metadata",
    validator: validate_RunArtifactsBatchCreateEmptyArtifacts_574336, base: "",
    url: url_RunArtifactsBatchCreateEmptyArtifacts_574337, schemes: {Scheme.Https})
type
  Call_RunArtifactsGetContentInformation_574348 = ref object of OpenApiRestCall_573641
proc url_RunArtifactsGetContentInformation_574350(protocol: Scheme; host: string;
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
    segments = @[(kind: ConstantSegment, value: "/history/v1.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/experiments/"),
               (kind: VariableSegment, value: "experimentName"),
               (kind: ConstantSegment, value: "/runs/"),
               (kind: VariableSegment, value: "runId"),
               (kind: ConstantSegment, value: "/artifacts/contentinfo")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunArtifactsGetContentInformation_574349(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get Artifact content information for give Run Id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   runId: JString (required)
  ##        : The identifier of the Run.
  ##   experimentName: JString (required)
  ##                 : The experiment name.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574351 = path.getOrDefault("resourceGroupName")
  valid_574351 = validateParameter(valid_574351, JString, required = true,
                                 default = nil)
  if valid_574351 != nil:
    section.add "resourceGroupName", valid_574351
  var valid_574352 = path.getOrDefault("subscriptionId")
  valid_574352 = validateParameter(valid_574352, JString, required = true,
                                 default = nil)
  if valid_574352 != nil:
    section.add "subscriptionId", valid_574352
  var valid_574353 = path.getOrDefault("runId")
  valid_574353 = validateParameter(valid_574353, JString, required = true,
                                 default = nil)
  if valid_574353 != nil:
    section.add "runId", valid_574353
  var valid_574354 = path.getOrDefault("experimentName")
  valid_574354 = validateParameter(valid_574354, JString, required = true,
                                 default = nil)
  if valid_574354 != nil:
    section.add "experimentName", valid_574354
  var valid_574355 = path.getOrDefault("workspaceName")
  valid_574355 = validateParameter(valid_574355, JString, required = true,
                                 default = nil)
  if valid_574355 != nil:
    section.add "workspaceName", valid_574355
  result.add "path", section
  ## parameters in `query` object:
  ##   path: JString
  ##       : The Artifact Path.
  section = newJObject()
  var valid_574356 = query.getOrDefault("path")
  valid_574356 = validateParameter(valid_574356, JString, required = false,
                                 default = nil)
  if valid_574356 != nil:
    section.add "path", valid_574356
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574357: Call_RunArtifactsGetContentInformation_574348;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get Artifact content information for give Run Id.
  ## 
  let valid = call_574357.validator(path, query, header, formData, body)
  let scheme = call_574357.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574357.url(scheme.get, call_574357.host, call_574357.base,
                         call_574357.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574357, url, valid)

proc call*(call_574358: Call_RunArtifactsGetContentInformation_574348;
          resourceGroupName: string; subscriptionId: string; runId: string;
          experimentName: string; workspaceName: string; path: string = ""): Recallable =
  ## runArtifactsGetContentInformation
  ## Get Artifact content information for give Run Id.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   path: string
  ##       : The Artifact Path.
  ##   runId: string (required)
  ##        : The identifier of the Run.
  ##   experimentName: string (required)
  ##                 : The experiment name.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_574359 = newJObject()
  var query_574360 = newJObject()
  add(path_574359, "resourceGroupName", newJString(resourceGroupName))
  add(path_574359, "subscriptionId", newJString(subscriptionId))
  add(query_574360, "path", newJString(path))
  add(path_574359, "runId", newJString(runId))
  add(path_574359, "experimentName", newJString(experimentName))
  add(path_574359, "workspaceName", newJString(workspaceName))
  result = call_574358.call(path_574359, query_574360, nil, nil, nil)

var runArtifactsGetContentInformation* = Call_RunArtifactsGetContentInformation_574348(
    name: "runArtifactsGetContentInformation", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/history/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/experiments/{experimentName}/runs/{runId}/artifacts/contentinfo",
    validator: validate_RunArtifactsGetContentInformation_574349, base: "",
    url: url_RunArtifactsGetContentInformation_574350, schemes: {Scheme.Https})
type
  Call_RunArtifactsGetById_574361 = ref object of OpenApiRestCall_573641
proc url_RunArtifactsGetById_574363(protocol: Scheme; host: string; base: string;
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
  assert "runId" in path, "`runId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/history/v1.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/experiments/"),
               (kind: VariableSegment, value: "experimentName"),
               (kind: ConstantSegment, value: "/runs/"),
               (kind: VariableSegment, value: "runId"),
               (kind: ConstantSegment, value: "/artifacts/metadata")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunArtifactsGetById_574362(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Get Artifact for a specific Id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   runId: JString (required)
  ##        : The identifier of the Run.
  ##   experimentName: JString (required)
  ##                 : The experiment name.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574364 = path.getOrDefault("resourceGroupName")
  valid_574364 = validateParameter(valid_574364, JString, required = true,
                                 default = nil)
  if valid_574364 != nil:
    section.add "resourceGroupName", valid_574364
  var valid_574365 = path.getOrDefault("subscriptionId")
  valid_574365 = validateParameter(valid_574365, JString, required = true,
                                 default = nil)
  if valid_574365 != nil:
    section.add "subscriptionId", valid_574365
  var valid_574366 = path.getOrDefault("runId")
  valid_574366 = validateParameter(valid_574366, JString, required = true,
                                 default = nil)
  if valid_574366 != nil:
    section.add "runId", valid_574366
  var valid_574367 = path.getOrDefault("experimentName")
  valid_574367 = validateParameter(valid_574367, JString, required = true,
                                 default = nil)
  if valid_574367 != nil:
    section.add "experimentName", valid_574367
  var valid_574368 = path.getOrDefault("workspaceName")
  valid_574368 = validateParameter(valid_574368, JString, required = true,
                                 default = nil)
  if valid_574368 != nil:
    section.add "workspaceName", valid_574368
  result.add "path", section
  ## parameters in `query` object:
  ##   path: JString
  ##       : The Artifact Path.
  section = newJObject()
  var valid_574369 = query.getOrDefault("path")
  valid_574369 = validateParameter(valid_574369, JString, required = false,
                                 default = nil)
  if valid_574369 != nil:
    section.add "path", valid_574369
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574370: Call_RunArtifactsGetById_574361; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get Artifact for a specific Id.
  ## 
  let valid = call_574370.validator(path, query, header, formData, body)
  let scheme = call_574370.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574370.url(scheme.get, call_574370.host, call_574370.base,
                         call_574370.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574370, url, valid)

proc call*(call_574371: Call_RunArtifactsGetById_574361; resourceGroupName: string;
          subscriptionId: string; runId: string; experimentName: string;
          workspaceName: string; path: string = ""): Recallable =
  ## runArtifactsGetById
  ## Get Artifact for a specific Id.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   path: string
  ##       : The Artifact Path.
  ##   runId: string (required)
  ##        : The identifier of the Run.
  ##   experimentName: string (required)
  ##                 : The experiment name.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_574372 = newJObject()
  var query_574373 = newJObject()
  add(path_574372, "resourceGroupName", newJString(resourceGroupName))
  add(path_574372, "subscriptionId", newJString(subscriptionId))
  add(query_574373, "path", newJString(path))
  add(path_574372, "runId", newJString(runId))
  add(path_574372, "experimentName", newJString(experimentName))
  add(path_574372, "workspaceName", newJString(workspaceName))
  result = call_574371.call(path_574372, query_574373, nil, nil, nil)

var runArtifactsGetById* = Call_RunArtifactsGetById_574361(
    name: "runArtifactsGetById", meth: HttpMethod.HttpGet, host: "azure.local", route: "/history/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/experiments/{experimentName}/runs/{runId}/artifacts/metadata",
    validator: validate_RunArtifactsGetById_574362, base: "",
    url: url_RunArtifactsGetById_574363, schemes: {Scheme.Https})
type
  Call_RunArtifactsListInPath_574374 = ref object of OpenApiRestCall_573641
proc url_RunArtifactsListInPath_574376(protocol: Scheme; host: string; base: string;
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
  assert "runId" in path, "`runId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/history/v1.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/experiments/"),
               (kind: VariableSegment, value: "experimentName"),
               (kind: ConstantSegment, value: "/runs/"),
               (kind: VariableSegment, value: "runId"),
               (kind: ConstantSegment, value: "/artifacts/path")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunArtifactsListInPath_574375(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get Artifacts in the provided path for a specific Run Id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   runId: JString (required)
  ##        : The identifier of the Run.
  ##   experimentName: JString (required)
  ##                 : The experiment name.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574377 = path.getOrDefault("resourceGroupName")
  valid_574377 = validateParameter(valid_574377, JString, required = true,
                                 default = nil)
  if valid_574377 != nil:
    section.add "resourceGroupName", valid_574377
  var valid_574378 = path.getOrDefault("subscriptionId")
  valid_574378 = validateParameter(valid_574378, JString, required = true,
                                 default = nil)
  if valid_574378 != nil:
    section.add "subscriptionId", valid_574378
  var valid_574379 = path.getOrDefault("runId")
  valid_574379 = validateParameter(valid_574379, JString, required = true,
                                 default = nil)
  if valid_574379 != nil:
    section.add "runId", valid_574379
  var valid_574380 = path.getOrDefault("experimentName")
  valid_574380 = validateParameter(valid_574380, JString, required = true,
                                 default = nil)
  if valid_574380 != nil:
    section.add "experimentName", valid_574380
  var valid_574381 = path.getOrDefault("workspaceName")
  valid_574381 = validateParameter(valid_574381, JString, required = true,
                                 default = nil)
  if valid_574381 != nil:
    section.add "workspaceName", valid_574381
  result.add "path", section
  ## parameters in `query` object:
  ##   path: JString
  ##       : The Artifact Path.
  ##   continuationToken: JString
  ##                    : The Continuation Token.
  section = newJObject()
  var valid_574382 = query.getOrDefault("path")
  valid_574382 = validateParameter(valid_574382, JString, required = false,
                                 default = nil)
  if valid_574382 != nil:
    section.add "path", valid_574382
  var valid_574383 = query.getOrDefault("continuationToken")
  valid_574383 = validateParameter(valid_574383, JString, required = false,
                                 default = nil)
  if valid_574383 != nil:
    section.add "continuationToken", valid_574383
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574384: Call_RunArtifactsListInPath_574374; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get Artifacts in the provided path for a specific Run Id.
  ## 
  let valid = call_574384.validator(path, query, header, formData, body)
  let scheme = call_574384.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574384.url(scheme.get, call_574384.host, call_574384.base,
                         call_574384.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574384, url, valid)

proc call*(call_574385: Call_RunArtifactsListInPath_574374;
          resourceGroupName: string; subscriptionId: string; runId: string;
          experimentName: string; workspaceName: string; path: string = "";
          continuationToken: string = ""): Recallable =
  ## runArtifactsListInPath
  ## Get Artifacts in the provided path for a specific Run Id.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   path: string
  ##       : The Artifact Path.
  ##   runId: string (required)
  ##        : The identifier of the Run.
  ##   continuationToken: string
  ##                    : The Continuation Token.
  ##   experimentName: string (required)
  ##                 : The experiment name.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_574386 = newJObject()
  var query_574387 = newJObject()
  add(path_574386, "resourceGroupName", newJString(resourceGroupName))
  add(path_574386, "subscriptionId", newJString(subscriptionId))
  add(query_574387, "path", newJString(path))
  add(path_574386, "runId", newJString(runId))
  add(query_574387, "continuationToken", newJString(continuationToken))
  add(path_574386, "experimentName", newJString(experimentName))
  add(path_574386, "workspaceName", newJString(workspaceName))
  result = call_574385.call(path_574386, query_574387, nil, nil, nil)

var runArtifactsListInPath* = Call_RunArtifactsListInPath_574374(
    name: "runArtifactsListInPath", meth: HttpMethod.HttpGet, host: "azure.local", route: "/history/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/experiments/{experimentName}/runs/{runId}/artifacts/path",
    validator: validate_RunArtifactsListInPath_574375, base: "",
    url: url_RunArtifactsListInPath_574376, schemes: {Scheme.Https})
type
  Call_RunArtifactsListSasByPrefix_574388 = ref object of OpenApiRestCall_573641
proc url_RunArtifactsListSasByPrefix_574390(protocol: Scheme; host: string;
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
    segments = @[(kind: ConstantSegment, value: "/history/v1.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/experiments/"),
               (kind: VariableSegment, value: "experimentName"),
               (kind: ConstantSegment, value: "/runs/"),
               (kind: VariableSegment, value: "runId"),
               (kind: ConstantSegment, value: "/artifacts/prefix/contentinfo")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunArtifactsListSasByPrefix_574389(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get SAS of an Artifact in the specified path.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   runId: JString (required)
  ##        : The identifier of the Run.
  ##   experimentName: JString (required)
  ##                 : The experiment name.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574391 = path.getOrDefault("resourceGroupName")
  valid_574391 = validateParameter(valid_574391, JString, required = true,
                                 default = nil)
  if valid_574391 != nil:
    section.add "resourceGroupName", valid_574391
  var valid_574392 = path.getOrDefault("subscriptionId")
  valid_574392 = validateParameter(valid_574392, JString, required = true,
                                 default = nil)
  if valid_574392 != nil:
    section.add "subscriptionId", valid_574392
  var valid_574393 = path.getOrDefault("runId")
  valid_574393 = validateParameter(valid_574393, JString, required = true,
                                 default = nil)
  if valid_574393 != nil:
    section.add "runId", valid_574393
  var valid_574394 = path.getOrDefault("experimentName")
  valid_574394 = validateParameter(valid_574394, JString, required = true,
                                 default = nil)
  if valid_574394 != nil:
    section.add "experimentName", valid_574394
  var valid_574395 = path.getOrDefault("workspaceName")
  valid_574395 = validateParameter(valid_574395, JString, required = true,
                                 default = nil)
  if valid_574395 != nil:
    section.add "workspaceName", valid_574395
  result.add "path", section
  ## parameters in `query` object:
  ##   path: JString
  ##       : The Artifact Path.
  ##   continuationToken: JString
  ##                    : The Continuation Token.
  section = newJObject()
  var valid_574396 = query.getOrDefault("path")
  valid_574396 = validateParameter(valid_574396, JString, required = false,
                                 default = nil)
  if valid_574396 != nil:
    section.add "path", valid_574396
  var valid_574397 = query.getOrDefault("continuationToken")
  valid_574397 = validateParameter(valid_574397, JString, required = false,
                                 default = nil)
  if valid_574397 != nil:
    section.add "continuationToken", valid_574397
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574398: Call_RunArtifactsListSasByPrefix_574388; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get SAS of an Artifact in the specified path.
  ## 
  let valid = call_574398.validator(path, query, header, formData, body)
  let scheme = call_574398.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574398.url(scheme.get, call_574398.host, call_574398.base,
                         call_574398.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574398, url, valid)

proc call*(call_574399: Call_RunArtifactsListSasByPrefix_574388;
          resourceGroupName: string; subscriptionId: string; runId: string;
          experimentName: string; workspaceName: string; path: string = "";
          continuationToken: string = ""): Recallable =
  ## runArtifactsListSasByPrefix
  ## Get SAS of an Artifact in the specified path.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   path: string
  ##       : The Artifact Path.
  ##   runId: string (required)
  ##        : The identifier of the Run.
  ##   continuationToken: string
  ##                    : The Continuation Token.
  ##   experimentName: string (required)
  ##                 : The experiment name.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_574400 = newJObject()
  var query_574401 = newJObject()
  add(path_574400, "resourceGroupName", newJString(resourceGroupName))
  add(path_574400, "subscriptionId", newJString(subscriptionId))
  add(query_574401, "path", newJString(path))
  add(path_574400, "runId", newJString(runId))
  add(query_574401, "continuationToken", newJString(continuationToken))
  add(path_574400, "experimentName", newJString(experimentName))
  add(path_574400, "workspaceName", newJString(workspaceName))
  result = call_574399.call(path_574400, query_574401, nil, nil, nil)

var runArtifactsListSasByPrefix* = Call_RunArtifactsListSasByPrefix_574388(
    name: "runArtifactsListSasByPrefix", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/history/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/experiments/{experimentName}/runs/{runId}/artifacts/prefix/contentinfo",
    validator: validate_RunArtifactsListSasByPrefix_574389, base: "",
    url: url_RunArtifactsListSasByPrefix_574390, schemes: {Scheme.Https})
type
  Call_RunMetricsBatchPost_574402 = ref object of OpenApiRestCall_573641
proc url_RunMetricsBatchPost_574404(protocol: Scheme; host: string; base: string;
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
  assert "runId" in path, "`runId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/history/v1.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/experiments/"),
               (kind: VariableSegment, value: "experimentName"),
               (kind: ConstantSegment, value: "/runs/"),
               (kind: VariableSegment, value: "runId"),
               (kind: ConstantSegment, value: "/batch/metrics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunMetricsBatchPost_574403(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Post Metrics to a specific Run Id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   runId: JString (required)
  ##        : The identifier for a run.
  ##   experimentName: JString (required)
  ##                 : The experiment name.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574405 = path.getOrDefault("resourceGroupName")
  valid_574405 = validateParameter(valid_574405, JString, required = true,
                                 default = nil)
  if valid_574405 != nil:
    section.add "resourceGroupName", valid_574405
  var valid_574406 = path.getOrDefault("subscriptionId")
  valid_574406 = validateParameter(valid_574406, JString, required = true,
                                 default = nil)
  if valid_574406 != nil:
    section.add "subscriptionId", valid_574406
  var valid_574407 = path.getOrDefault("runId")
  valid_574407 = validateParameter(valid_574407, JString, required = true,
                                 default = nil)
  if valid_574407 != nil:
    section.add "runId", valid_574407
  var valid_574408 = path.getOrDefault("experimentName")
  valid_574408 = validateParameter(valid_574408, JString, required = true,
                                 default = nil)
  if valid_574408 != nil:
    section.add "experimentName", valid_574408
  var valid_574409 = path.getOrDefault("workspaceName")
  valid_574409 = validateParameter(valid_574409, JString, required = true,
                                 default = nil)
  if valid_574409 != nil:
    section.add "workspaceName", valid_574409
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   batchMetricDto: JObject
  ##                 : Details of the Metrics which will be added to the Run Id.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574411: Call_RunMetricsBatchPost_574402; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Post Metrics to a specific Run Id.
  ## 
  let valid = call_574411.validator(path, query, header, formData, body)
  let scheme = call_574411.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574411.url(scheme.get, call_574411.host, call_574411.base,
                         call_574411.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574411, url, valid)

proc call*(call_574412: Call_RunMetricsBatchPost_574402; resourceGroupName: string;
          subscriptionId: string; runId: string; experimentName: string;
          workspaceName: string; batchMetricDto: JsonNode = nil): Recallable =
  ## runMetricsBatchPost
  ## Post Metrics to a specific Run Id.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   batchMetricDto: JObject
  ##                 : Details of the Metrics which will be added to the Run Id.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   runId: string (required)
  ##        : The identifier for a run.
  ##   experimentName: string (required)
  ##                 : The experiment name.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_574413 = newJObject()
  var body_574414 = newJObject()
  add(path_574413, "resourceGroupName", newJString(resourceGroupName))
  if batchMetricDto != nil:
    body_574414 = batchMetricDto
  add(path_574413, "subscriptionId", newJString(subscriptionId))
  add(path_574413, "runId", newJString(runId))
  add(path_574413, "experimentName", newJString(experimentName))
  add(path_574413, "workspaceName", newJString(workspaceName))
  result = call_574412.call(path_574413, nil, nil, nil, body_574414)

var runMetricsBatchPost* = Call_RunMetricsBatchPost_574402(
    name: "runMetricsBatchPost", meth: HttpMethod.HttpPost, host: "azure.local", route: "/history/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/experiments/{experimentName}/runs/{runId}/batch/metrics",
    validator: validate_RunMetricsBatchPost_574403, base: "",
    url: url_RunMetricsBatchPost_574404, schemes: {Scheme.Https})
type
  Call_RunsGetChild_574415 = ref object of OpenApiRestCall_573641
proc url_RunsGetChild_574417(protocol: Scheme; host: string; base: string;
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
  assert "runId" in path, "`runId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/history/v1.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/experiments/"),
               (kind: VariableSegment, value: "experimentName"),
               (kind: ConstantSegment, value: "/runs/"),
               (kind: VariableSegment, value: "runId"),
               (kind: ConstantSegment, value: "/children")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunsGetChild_574416(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Get details of all child runs for the specified Run Id with the specified filters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   runId: JString (required)
  ##        : The identifier of the Run.
  ##   experimentName: JString (required)
  ##                 : The experiment name.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574419 = path.getOrDefault("resourceGroupName")
  valid_574419 = validateParameter(valid_574419, JString, required = true,
                                 default = nil)
  if valid_574419 != nil:
    section.add "resourceGroupName", valid_574419
  var valid_574420 = path.getOrDefault("subscriptionId")
  valid_574420 = validateParameter(valid_574420, JString, required = true,
                                 default = nil)
  if valid_574420 != nil:
    section.add "subscriptionId", valid_574420
  var valid_574421 = path.getOrDefault("runId")
  valid_574421 = validateParameter(valid_574421, JString, required = true,
                                 default = nil)
  if valid_574421 != nil:
    section.add "runId", valid_574421
  var valid_574422 = path.getOrDefault("experimentName")
  valid_574422 = validateParameter(valid_574422, JString, required = true,
                                 default = nil)
  if valid_574422 != nil:
    section.add "experimentName", valid_574422
  var valid_574423 = path.getOrDefault("workspaceName")
  valid_574423 = validateParameter(valid_574423, JString, required = true,
                                 default = nil)
  if valid_574423 != nil:
    section.add "workspaceName", valid_574423
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JArray
  ##           : The list of resource properties to use for sorting the requested resources.
  ##   $top: JInt
  ##       : The maximum number of items in the resource collection to be included in the result.
  ## If not specified, all items are returned.
  ##   $count: JBool
  ##         : Whether to include a count of the matching resources along with the resources returned in the response.
  ##   $sortorder: JString
  ##             : The sort order of the returned resources. Not used, specify asc or desc after each property name in the OrderBy parameter.
  ##   $continuationtoken: JString
  ##                     : The continuation token to use for getting the next set of resources.
  ##   $filter: JString
  ##          : Allows for filtering the collection of resources.
  ## The expression specified is evaluated for each resource in the collection, and only items where the expression evaluates to true are included in the response.
  section = newJObject()
  var valid_574424 = query.getOrDefault("$orderby")
  valid_574424 = validateParameter(valid_574424, JArray, required = false,
                                 default = nil)
  if valid_574424 != nil:
    section.add "$orderby", valid_574424
  var valid_574425 = query.getOrDefault("$top")
  valid_574425 = validateParameter(valid_574425, JInt, required = false, default = nil)
  if valid_574425 != nil:
    section.add "$top", valid_574425
  var valid_574426 = query.getOrDefault("$count")
  valid_574426 = validateParameter(valid_574426, JBool, required = false, default = nil)
  if valid_574426 != nil:
    section.add "$count", valid_574426
  var valid_574427 = query.getOrDefault("$sortorder")
  valid_574427 = validateParameter(valid_574427, JString, required = false,
                                 default = newJString("Asc"))
  if valid_574427 != nil:
    section.add "$sortorder", valid_574427
  var valid_574428 = query.getOrDefault("$continuationtoken")
  valid_574428 = validateParameter(valid_574428, JString, required = false,
                                 default = nil)
  if valid_574428 != nil:
    section.add "$continuationtoken", valid_574428
  var valid_574429 = query.getOrDefault("$filter")
  valid_574429 = validateParameter(valid_574429, JString, required = false,
                                 default = nil)
  if valid_574429 != nil:
    section.add "$filter", valid_574429
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574430: Call_RunsGetChild_574415; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get details of all child runs for the specified Run Id with the specified filters.
  ## 
  let valid = call_574430.validator(path, query, header, formData, body)
  let scheme = call_574430.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574430.url(scheme.get, call_574430.host, call_574430.base,
                         call_574430.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574430, url, valid)

proc call*(call_574431: Call_RunsGetChild_574415; resourceGroupName: string;
          subscriptionId: string; runId: string; experimentName: string;
          workspaceName: string; Orderby: JsonNode = nil; Top: int = 0;
          Count: bool = false; Sortorder: string = "Asc";
          Continuationtoken: string = ""; Filter: string = ""): Recallable =
  ## runsGetChild
  ## Get details of all child runs for the specified Run Id with the specified filters.
  ##   Orderby: JArray
  ##          : The list of resource properties to use for sorting the requested resources.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   Top: int
  ##      : The maximum number of items in the resource collection to be included in the result.
  ## If not specified, all items are returned.
  ##   runId: string (required)
  ##        : The identifier of the Run.
  ##   Count: bool
  ##        : Whether to include a count of the matching resources along with the resources returned in the response.
  ##   Sortorder: string
  ##            : The sort order of the returned resources. Not used, specify asc or desc after each property name in the OrderBy parameter.
  ##   Continuationtoken: string
  ##                    : The continuation token to use for getting the next set of resources.
  ##   experimentName: string (required)
  ##                 : The experiment name.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   Filter: string
  ##         : Allows for filtering the collection of resources.
  ## The expression specified is evaluated for each resource in the collection, and only items where the expression evaluates to true are included in the response.
  var path_574432 = newJObject()
  var query_574433 = newJObject()
  if Orderby != nil:
    query_574433.add "$orderby", Orderby
  add(path_574432, "resourceGroupName", newJString(resourceGroupName))
  add(path_574432, "subscriptionId", newJString(subscriptionId))
  add(query_574433, "$top", newJInt(Top))
  add(path_574432, "runId", newJString(runId))
  add(query_574433, "$count", newJBool(Count))
  add(query_574433, "$sortorder", newJString(Sortorder))
  add(query_574433, "$continuationtoken", newJString(Continuationtoken))
  add(path_574432, "experimentName", newJString(experimentName))
  add(path_574432, "workspaceName", newJString(workspaceName))
  add(query_574433, "$filter", newJString(Filter))
  result = call_574431.call(path_574432, query_574433, nil, nil, nil)

var runsGetChild* = Call_RunsGetChild_574415(name: "runsGetChild",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/history/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/experiments/{experimentName}/runs/{runId}/children",
    validator: validate_RunsGetChild_574416, base: "", url: url_RunsGetChild_574417,
    schemes: {Scheme.Https})
type
  Call_RunsGetDetails_574434 = ref object of OpenApiRestCall_573641
proc url_RunsGetDetails_574436(protocol: Scheme; host: string; base: string;
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
  assert "runId" in path, "`runId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/history/v1.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/experiments/"),
               (kind: VariableSegment, value: "experimentName"),
               (kind: ConstantSegment, value: "/runs/"),
               (kind: VariableSegment, value: "runId"),
               (kind: ConstantSegment, value: "/details")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunsGetDetails_574435(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Get Run Details for a specific Run Id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   runId: JString (required)
  ##        : The identifier of the Run.
  ##   experimentName: JString (required)
  ##                 : The experiment name.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574437 = path.getOrDefault("resourceGroupName")
  valid_574437 = validateParameter(valid_574437, JString, required = true,
                                 default = nil)
  if valid_574437 != nil:
    section.add "resourceGroupName", valid_574437
  var valid_574438 = path.getOrDefault("subscriptionId")
  valid_574438 = validateParameter(valid_574438, JString, required = true,
                                 default = nil)
  if valid_574438 != nil:
    section.add "subscriptionId", valid_574438
  var valid_574439 = path.getOrDefault("runId")
  valid_574439 = validateParameter(valid_574439, JString, required = true,
                                 default = nil)
  if valid_574439 != nil:
    section.add "runId", valid_574439
  var valid_574440 = path.getOrDefault("experimentName")
  valid_574440 = validateParameter(valid_574440, JString, required = true,
                                 default = nil)
  if valid_574440 != nil:
    section.add "experimentName", valid_574440
  var valid_574441 = path.getOrDefault("workspaceName")
  valid_574441 = validateParameter(valid_574441, JString, required = true,
                                 default = nil)
  if valid_574441 != nil:
    section.add "workspaceName", valid_574441
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574442: Call_RunsGetDetails_574434; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get Run Details for a specific Run Id.
  ## 
  let valid = call_574442.validator(path, query, header, formData, body)
  let scheme = call_574442.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574442.url(scheme.get, call_574442.host, call_574442.base,
                         call_574442.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574442, url, valid)

proc call*(call_574443: Call_RunsGetDetails_574434; resourceGroupName: string;
          subscriptionId: string; runId: string; experimentName: string;
          workspaceName: string): Recallable =
  ## runsGetDetails
  ## Get Run Details for a specific Run Id.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   runId: string (required)
  ##        : The identifier of the Run.
  ##   experimentName: string (required)
  ##                 : The experiment name.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_574444 = newJObject()
  add(path_574444, "resourceGroupName", newJString(resourceGroupName))
  add(path_574444, "subscriptionId", newJString(subscriptionId))
  add(path_574444, "runId", newJString(runId))
  add(path_574444, "experimentName", newJString(experimentName))
  add(path_574444, "workspaceName", newJString(workspaceName))
  result = call_574443.call(path_574444, nil, nil, nil, nil)

var runsGetDetails* = Call_RunsGetDetails_574434(name: "runsGetDetails",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/history/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/experiments/{experimentName}/runs/{runId}/details",
    validator: validate_RunsGetDetails_574435, base: "", url: url_RunsGetDetails_574436,
    schemes: {Scheme.Https})
type
  Call_EventsPost_574445 = ref object of OpenApiRestCall_573641
proc url_EventsPost_574447(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
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
    segments = @[(kind: ConstantSegment, value: "/history/v1.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/experiments/"),
               (kind: VariableSegment, value: "experimentName"),
               (kind: ConstantSegment, value: "/runs/"),
               (kind: VariableSegment, value: "runId"),
               (kind: ConstantSegment, value: "/events")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EventsPost_574446(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Post event data to a specific Run Id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   runId: JString (required)
  ##        : The identifier of the Run.
  ##   experimentName: JString (required)
  ##                 : The experiment name.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574448 = path.getOrDefault("resourceGroupName")
  valid_574448 = validateParameter(valid_574448, JString, required = true,
                                 default = nil)
  if valid_574448 != nil:
    section.add "resourceGroupName", valid_574448
  var valid_574449 = path.getOrDefault("subscriptionId")
  valid_574449 = validateParameter(valid_574449, JString, required = true,
                                 default = nil)
  if valid_574449 != nil:
    section.add "subscriptionId", valid_574449
  var valid_574450 = path.getOrDefault("runId")
  valid_574450 = validateParameter(valid_574450, JString, required = true,
                                 default = nil)
  if valid_574450 != nil:
    section.add "runId", valid_574450
  var valid_574451 = path.getOrDefault("experimentName")
  valid_574451 = validateParameter(valid_574451, JString, required = true,
                                 default = nil)
  if valid_574451 != nil:
    section.add "experimentName", valid_574451
  var valid_574452 = path.getOrDefault("workspaceName")
  valid_574452 = validateParameter(valid_574452, JString, required = true,
                                 default = nil)
  if valid_574452 != nil:
    section.add "workspaceName", valid_574452
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   eventMessage: JObject
  ##               : The Event details.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574454: Call_EventsPost_574445; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Post event data to a specific Run Id.
  ## 
  let valid = call_574454.validator(path, query, header, formData, body)
  let scheme = call_574454.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574454.url(scheme.get, call_574454.host, call_574454.base,
                         call_574454.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574454, url, valid)

proc call*(call_574455: Call_EventsPost_574445; resourceGroupName: string;
          subscriptionId: string; runId: string; experimentName: string;
          workspaceName: string; eventMessage: JsonNode = nil): Recallable =
  ## eventsPost
  ## Post event data to a specific Run Id.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   runId: string (required)
  ##        : The identifier of the Run.
  ##   experimentName: string (required)
  ##                 : The experiment name.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   eventMessage: JObject
  ##               : The Event details.
  var path_574456 = newJObject()
  var body_574457 = newJObject()
  add(path_574456, "resourceGroupName", newJString(resourceGroupName))
  add(path_574456, "subscriptionId", newJString(subscriptionId))
  add(path_574456, "runId", newJString(runId))
  add(path_574456, "experimentName", newJString(experimentName))
  add(path_574456, "workspaceName", newJString(workspaceName))
  if eventMessage != nil:
    body_574457 = eventMessage
  result = call_574455.call(path_574456, nil, nil, nil, body_574457)

var eventsPost* = Call_EventsPost_574445(name: "eventsPost",
                                      meth: HttpMethod.HttpPost,
                                      host: "azure.local", route: "/history/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/experiments/{experimentName}/runs/{runId}/events",
                                      validator: validate_EventsPost_574446,
                                      base: "", url: url_EventsPost_574447,
                                      schemes: {Scheme.Https})
type
  Call_RunMetricsPost_574458 = ref object of OpenApiRestCall_573641
proc url_RunMetricsPost_574460(protocol: Scheme; host: string; base: string;
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
  assert "runId" in path, "`runId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/history/v1.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/experiments/"),
               (kind: VariableSegment, value: "experimentName"),
               (kind: ConstantSegment, value: "/runs/"),
               (kind: VariableSegment, value: "runId"),
               (kind: ConstantSegment, value: "/metrics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunMetricsPost_574459(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Post a Metric to a specific Run Id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   runId: JString (required)
  ##        : The identifier for a run.
  ##   experimentName: JString (required)
  ##                 : The experiment name.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574461 = path.getOrDefault("resourceGroupName")
  valid_574461 = validateParameter(valid_574461, JString, required = true,
                                 default = nil)
  if valid_574461 != nil:
    section.add "resourceGroupName", valid_574461
  var valid_574462 = path.getOrDefault("subscriptionId")
  valid_574462 = validateParameter(valid_574462, JString, required = true,
                                 default = nil)
  if valid_574462 != nil:
    section.add "subscriptionId", valid_574462
  var valid_574463 = path.getOrDefault("runId")
  valid_574463 = validateParameter(valid_574463, JString, required = true,
                                 default = nil)
  if valid_574463 != nil:
    section.add "runId", valid_574463
  var valid_574464 = path.getOrDefault("experimentName")
  valid_574464 = validateParameter(valid_574464, JString, required = true,
                                 default = nil)
  if valid_574464 != nil:
    section.add "experimentName", valid_574464
  var valid_574465 = path.getOrDefault("workspaceName")
  valid_574465 = validateParameter(valid_574465, JString, required = true,
                                 default = nil)
  if valid_574465 != nil:
    section.add "workspaceName", valid_574465
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   metricDto: JObject
  ##            : Details of the metric which will be added to the Run Id.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574467: Call_RunMetricsPost_574458; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Post a Metric to a specific Run Id.
  ## 
  let valid = call_574467.validator(path, query, header, formData, body)
  let scheme = call_574467.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574467.url(scheme.get, call_574467.host, call_574467.base,
                         call_574467.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574467, url, valid)

proc call*(call_574468: Call_RunMetricsPost_574458; resourceGroupName: string;
          subscriptionId: string; runId: string; experimentName: string;
          workspaceName: string; metricDto: JsonNode = nil): Recallable =
  ## runMetricsPost
  ## Post a Metric to a specific Run Id.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   metricDto: JObject
  ##            : Details of the metric which will be added to the Run Id.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   runId: string (required)
  ##        : The identifier for a run.
  ##   experimentName: string (required)
  ##                 : The experiment name.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_574469 = newJObject()
  var body_574470 = newJObject()
  add(path_574469, "resourceGroupName", newJString(resourceGroupName))
  if metricDto != nil:
    body_574470 = metricDto
  add(path_574469, "subscriptionId", newJString(subscriptionId))
  add(path_574469, "runId", newJString(runId))
  add(path_574469, "experimentName", newJString(experimentName))
  add(path_574469, "workspaceName", newJString(workspaceName))
  result = call_574468.call(path_574469, nil, nil, nil, body_574470)

var runMetricsPost* = Call_RunMetricsPost_574458(name: "runMetricsPost",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/history/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/experiments/{experimentName}/runs/{runId}/metrics",
    validator: validate_RunMetricsPost_574459, base: "", url: url_RunMetricsPost_574460,
    schemes: {Scheme.Https})
type
  Call_RunsDeleteTags_574471 = ref object of OpenApiRestCall_573641
proc url_RunsDeleteTags_574473(protocol: Scheme; host: string; base: string;
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
  assert "runId" in path, "`runId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/history/v1.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/experiments/"),
               (kind: VariableSegment, value: "experimentName"),
               (kind: ConstantSegment, value: "/runs/"),
               (kind: VariableSegment, value: "runId"),
               (kind: ConstantSegment, value: "/tags")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunsDeleteTags_574472(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Delete list of Tags from a specific Run Id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   runId: JString (required)
  ##        : The identifier of the Run.
  ##   experimentName: JString (required)
  ##                 : The experiment name.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574474 = path.getOrDefault("resourceGroupName")
  valid_574474 = validateParameter(valid_574474, JString, required = true,
                                 default = nil)
  if valid_574474 != nil:
    section.add "resourceGroupName", valid_574474
  var valid_574475 = path.getOrDefault("subscriptionId")
  valid_574475 = validateParameter(valid_574475, JString, required = true,
                                 default = nil)
  if valid_574475 != nil:
    section.add "subscriptionId", valid_574475
  var valid_574476 = path.getOrDefault("runId")
  valid_574476 = validateParameter(valid_574476, JString, required = true,
                                 default = nil)
  if valid_574476 != nil:
    section.add "runId", valid_574476
  var valid_574477 = path.getOrDefault("experimentName")
  valid_574477 = validateParameter(valid_574477, JString, required = true,
                                 default = nil)
  if valid_574477 != nil:
    section.add "experimentName", valid_574477
  var valid_574478 = path.getOrDefault("workspaceName")
  valid_574478 = validateParameter(valid_574478, JString, required = true,
                                 default = nil)
  if valid_574478 != nil:
    section.add "workspaceName", valid_574478
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   tags: JArray
  ##       : The requested tags list to be deleted.
  section = validateParameter(body, JArray, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574480: Call_RunsDeleteTags_574471; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete list of Tags from a specific Run Id.
  ## 
  let valid = call_574480.validator(path, query, header, formData, body)
  let scheme = call_574480.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574480.url(scheme.get, call_574480.host, call_574480.base,
                         call_574480.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574480, url, valid)

proc call*(call_574481: Call_RunsDeleteTags_574471; resourceGroupName: string;
          subscriptionId: string; runId: string; experimentName: string;
          workspaceName: string; tags: JsonNode = nil): Recallable =
  ## runsDeleteTags
  ## Delete list of Tags from a specific Run Id.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   runId: string (required)
  ##        : The identifier of the Run.
  ##   experimentName: string (required)
  ##                 : The experiment name.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   tags: JArray
  ##       : The requested tags list to be deleted.
  var path_574482 = newJObject()
  var body_574483 = newJObject()
  add(path_574482, "resourceGroupName", newJString(resourceGroupName))
  add(path_574482, "subscriptionId", newJString(subscriptionId))
  add(path_574482, "runId", newJString(runId))
  add(path_574482, "experimentName", newJString(experimentName))
  add(path_574482, "workspaceName", newJString(workspaceName))
  if tags != nil:
    body_574483 = tags
  result = call_574481.call(path_574482, nil, nil, nil, body_574483)

var runsDeleteTags* = Call_RunsDeleteTags_574471(name: "runsDeleteTags",
    meth: HttpMethod.HttpDelete, host: "azure.local", route: "/history/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/experiments/{experimentName}/runs/{runId}/tags",
    validator: validate_RunsDeleteTags_574472, base: "", url: url_RunsDeleteTags_574473,
    schemes: {Scheme.Https})
type
  Call_RunsGetByQuery_574484 = ref object of OpenApiRestCall_573641
proc url_RunsGetByQuery_574486(protocol: Scheme; host: string; base: string;
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
    segments = @[(kind: ConstantSegment, value: "/history/v1.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/experiments/"),
               (kind: VariableSegment, value: "experimentName"),
               (kind: ConstantSegment, value: "/runs:query")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunsGetByQuery_574485(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Get all Runs for a specific Experiment with the specified query filters.
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
  var valid_574487 = path.getOrDefault("resourceGroupName")
  valid_574487 = validateParameter(valid_574487, JString, required = true,
                                 default = nil)
  if valid_574487 != nil:
    section.add "resourceGroupName", valid_574487
  var valid_574488 = path.getOrDefault("subscriptionId")
  valid_574488 = validateParameter(valid_574488, JString, required = true,
                                 default = nil)
  if valid_574488 != nil:
    section.add "subscriptionId", valid_574488
  var valid_574489 = path.getOrDefault("experimentName")
  valid_574489 = validateParameter(valid_574489, JString, required = true,
                                 default = nil)
  if valid_574489 != nil:
    section.add "experimentName", valid_574489
  var valid_574490 = path.getOrDefault("workspaceName")
  valid_574490 = validateParameter(valid_574490, JString, required = true,
                                 default = nil)
  if valid_574490 != nil:
    section.add "workspaceName", valid_574490
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   queryParams: JObject
  ##              : Query parameters for data sorting and filtering.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574492: Call_RunsGetByQuery_574484; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all Runs for a specific Experiment with the specified query filters.
  ## 
  let valid = call_574492.validator(path, query, header, formData, body)
  let scheme = call_574492.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574492.url(scheme.get, call_574492.host, call_574492.base,
                         call_574492.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574492, url, valid)

proc call*(call_574493: Call_RunsGetByQuery_574484; resourceGroupName: string;
          subscriptionId: string; experimentName: string; workspaceName: string;
          queryParams: JsonNode = nil): Recallable =
  ## runsGetByQuery
  ## Get all Runs for a specific Experiment with the specified query filters.
  ##   queryParams: JObject
  ##              : Query parameters for data sorting and filtering.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   experimentName: string (required)
  ##                 : The experiment name.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_574494 = newJObject()
  var body_574495 = newJObject()
  if queryParams != nil:
    body_574495 = queryParams
  add(path_574494, "resourceGroupName", newJString(resourceGroupName))
  add(path_574494, "subscriptionId", newJString(subscriptionId))
  add(path_574494, "experimentName", newJString(experimentName))
  add(path_574494, "workspaceName", newJString(workspaceName))
  result = call_574493.call(path_574494, nil, nil, nil, body_574495)

var runsGetByQuery* = Call_RunsGetByQuery_574484(name: "runsGetByQuery",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/history/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/experiments/{experimentName}/runs:query",
    validator: validate_RunsGetByQuery_574485, base: "", url: url_RunsGetByQuery_574486,
    schemes: {Scheme.Https})
type
  Call_ExperimentsGetByQuery_574496 = ref object of OpenApiRestCall_573641
proc url_ExperimentsGetByQuery_574498(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/history/v1.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/experiments:query")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExperimentsGetByQuery_574497(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get all experiments in a specific workspace with the specified query filters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574499 = path.getOrDefault("resourceGroupName")
  valid_574499 = validateParameter(valid_574499, JString, required = true,
                                 default = nil)
  if valid_574499 != nil:
    section.add "resourceGroupName", valid_574499
  var valid_574500 = path.getOrDefault("subscriptionId")
  valid_574500 = validateParameter(valid_574500, JString, required = true,
                                 default = nil)
  if valid_574500 != nil:
    section.add "subscriptionId", valid_574500
  var valid_574501 = path.getOrDefault("workspaceName")
  valid_574501 = validateParameter(valid_574501, JString, required = true,
                                 default = nil)
  if valid_574501 != nil:
    section.add "workspaceName", valid_574501
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   queryParams: JObject
  ##              : Query parameters for data sorting and filtering.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574503: Call_ExperimentsGetByQuery_574496; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all experiments in a specific workspace with the specified query filters.
  ## 
  let valid = call_574503.validator(path, query, header, formData, body)
  let scheme = call_574503.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574503.url(scheme.get, call_574503.host, call_574503.base,
                         call_574503.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574503, url, valid)

proc call*(call_574504: Call_ExperimentsGetByQuery_574496;
          resourceGroupName: string; subscriptionId: string; workspaceName: string;
          queryParams: JsonNode = nil): Recallable =
  ## experimentsGetByQuery
  ## Get all experiments in a specific workspace with the specified query filters.
  ##   queryParams: JObject
  ##              : Query parameters for data sorting and filtering.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_574505 = newJObject()
  var body_574506 = newJObject()
  if queryParams != nil:
    body_574506 = queryParams
  add(path_574505, "resourceGroupName", newJString(resourceGroupName))
  add(path_574505, "subscriptionId", newJString(subscriptionId))
  add(path_574505, "workspaceName", newJString(workspaceName))
  result = call_574504.call(path_574505, nil, nil, nil, body_574506)

var experimentsGetByQuery* = Call_ExperimentsGetByQuery_574496(
    name: "experimentsGetByQuery", meth: HttpMethod.HttpPost, host: "azure.local", route: "/history/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/experiments:query",
    validator: validate_ExperimentsGetByQuery_574497, base: "",
    url: url_ExperimentsGetByQuery_574498, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
