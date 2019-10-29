
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

  OpenApiRestCall_563539 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563539](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563539): Option[Scheme] {.used.} =
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
  macServiceName = "machinelearningservices-runHistory"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ExperimentsGetById_563761 = ref object of OpenApiRestCall_563539
proc url_ExperimentsGetById_563763(protocol: Scheme; host: string; base: string;
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

proc validate_ExperimentsGetById_563762(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Get details of an Experiment with specific Experiment Id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  ##   experimentId: JString (required)
  ##               : The identifier of the experiment.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_563938 = path.getOrDefault("subscriptionId")
  valid_563938 = validateParameter(valid_563938, JString, required = true,
                                 default = nil)
  if valid_563938 != nil:
    section.add "subscriptionId", valid_563938
  var valid_563939 = path.getOrDefault("resourceGroupName")
  valid_563939 = validateParameter(valid_563939, JString, required = true,
                                 default = nil)
  if valid_563939 != nil:
    section.add "resourceGroupName", valid_563939
  var valid_563940 = path.getOrDefault("workspaceName")
  valid_563940 = validateParameter(valid_563940, JString, required = true,
                                 default = nil)
  if valid_563940 != nil:
    section.add "workspaceName", valid_563940
  var valid_563941 = path.getOrDefault("experimentId")
  valid_563941 = validateParameter(valid_563941, JString, required = true,
                                 default = nil)
  if valid_563941 != nil:
    section.add "experimentId", valid_563941
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563964: Call_ExperimentsGetById_563761; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get details of an Experiment with specific Experiment Id.
  ## 
  let valid = call_563964.validator(path, query, header, formData, body)
  let scheme = call_563964.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563964.url(scheme.get, call_563964.host, call_563964.base,
                         call_563964.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563964, url, valid)

proc call*(call_564035: Call_ExperimentsGetById_563761; subscriptionId: string;
          resourceGroupName: string; workspaceName: string; experimentId: string): Recallable =
  ## experimentsGetById
  ## Get details of an Experiment with specific Experiment Id.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   experimentId: string (required)
  ##               : The identifier of the experiment.
  var path_564036 = newJObject()
  add(path_564036, "subscriptionId", newJString(subscriptionId))
  add(path_564036, "resourceGroupName", newJString(resourceGroupName))
  add(path_564036, "workspaceName", newJString(workspaceName))
  add(path_564036, "experimentId", newJString(experimentId))
  result = call_564035.call(path_564036, nil, nil, nil, nil)

var experimentsGetById* = Call_ExperimentsGetById_563761(
    name: "experimentsGetById", meth: HttpMethod.HttpGet, host: "azure.local", route: "/history/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/experimentids/{experimentId}",
    validator: validate_ExperimentsGetById_563762, base: "",
    url: url_ExperimentsGetById_563763, schemes: {Scheme.Https})
type
  Call_ExperimentsUpdate_564076 = ref object of OpenApiRestCall_563539
proc url_ExperimentsUpdate_564078(protocol: Scheme; host: string; base: string;
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

proc validate_ExperimentsUpdate_564077(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Update details of an Experiment with specific Experiment Id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  ##   experimentId: JString (required)
  ##               : The identifier of the experiment.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564079 = path.getOrDefault("subscriptionId")
  valid_564079 = validateParameter(valid_564079, JString, required = true,
                                 default = nil)
  if valid_564079 != nil:
    section.add "subscriptionId", valid_564079
  var valid_564080 = path.getOrDefault("resourceGroupName")
  valid_564080 = validateParameter(valid_564080, JString, required = true,
                                 default = nil)
  if valid_564080 != nil:
    section.add "resourceGroupName", valid_564080
  var valid_564081 = path.getOrDefault("workspaceName")
  valid_564081 = validateParameter(valid_564081, JString, required = true,
                                 default = nil)
  if valid_564081 != nil:
    section.add "workspaceName", valid_564081
  var valid_564082 = path.getOrDefault("experimentId")
  valid_564082 = validateParameter(valid_564082, JString, required = true,
                                 default = nil)
  if valid_564082 != nil:
    section.add "experimentId", valid_564082
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

proc call*(call_564084: Call_ExperimentsUpdate_564076; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update details of an Experiment with specific Experiment Id.
  ## 
  let valid = call_564084.validator(path, query, header, formData, body)
  let scheme = call_564084.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564084.url(scheme.get, call_564084.host, call_564084.base,
                         call_564084.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564084, url, valid)

proc call*(call_564085: Call_ExperimentsUpdate_564076; subscriptionId: string;
          resourceGroupName: string; workspaceName: string; experimentId: string;
          modifyExperimentDto: JsonNode = nil): Recallable =
  ## experimentsUpdate
  ## Update details of an Experiment with specific Experiment Id.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   modifyExperimentDto: JObject
  ##                      : Experiment details which needs to be updated.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   experimentId: string (required)
  ##               : The identifier of the experiment.
  var path_564086 = newJObject()
  var body_564087 = newJObject()
  add(path_564086, "subscriptionId", newJString(subscriptionId))
  if modifyExperimentDto != nil:
    body_564087 = modifyExperimentDto
  add(path_564086, "resourceGroupName", newJString(resourceGroupName))
  add(path_564086, "workspaceName", newJString(workspaceName))
  add(path_564086, "experimentId", newJString(experimentId))
  result = call_564085.call(path_564086, nil, nil, nil, body_564087)

var experimentsUpdate* = Call_ExperimentsUpdate_564076(name: "experimentsUpdate",
    meth: HttpMethod.HttpPatch, host: "azure.local", route: "/history/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/experimentids/{experimentId}",
    validator: validate_ExperimentsUpdate_564077, base: "",
    url: url_ExperimentsUpdate_564078, schemes: {Scheme.Https})
type
  Call_ExperimentsDeleteTags_564088 = ref object of OpenApiRestCall_563539
proc url_ExperimentsDeleteTags_564090(protocol: Scheme; host: string; base: string;
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

proc validate_ExperimentsDeleteTags_564089(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete list of Tags from a specific Experiment Id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  ##   experimentId: JString (required)
  ##               : The identifier of the experiment.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564091 = path.getOrDefault("subscriptionId")
  valid_564091 = validateParameter(valid_564091, JString, required = true,
                                 default = nil)
  if valid_564091 != nil:
    section.add "subscriptionId", valid_564091
  var valid_564092 = path.getOrDefault("resourceGroupName")
  valid_564092 = validateParameter(valid_564092, JString, required = true,
                                 default = nil)
  if valid_564092 != nil:
    section.add "resourceGroupName", valid_564092
  var valid_564093 = path.getOrDefault("workspaceName")
  valid_564093 = validateParameter(valid_564093, JString, required = true,
                                 default = nil)
  if valid_564093 != nil:
    section.add "workspaceName", valid_564093
  var valid_564094 = path.getOrDefault("experimentId")
  valid_564094 = validateParameter(valid_564094, JString, required = true,
                                 default = nil)
  if valid_564094 != nil:
    section.add "experimentId", valid_564094
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

proc call*(call_564096: Call_ExperimentsDeleteTags_564088; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete list of Tags from a specific Experiment Id.
  ## 
  let valid = call_564096.validator(path, query, header, formData, body)
  let scheme = call_564096.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564096.url(scheme.get, call_564096.host, call_564096.base,
                         call_564096.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564096, url, valid)

proc call*(call_564097: Call_ExperimentsDeleteTags_564088; subscriptionId: string;
          resourceGroupName: string; workspaceName: string; experimentId: string;
          tags: JsonNode = nil): Recallable =
  ## experimentsDeleteTags
  ## Delete list of Tags from a specific Experiment Id.
  ##   tags: JObject
  ##       : The requested tags list to be deleted.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   experimentId: string (required)
  ##               : The identifier of the experiment.
  var path_564098 = newJObject()
  var body_564099 = newJObject()
  if tags != nil:
    body_564099 = tags
  add(path_564098, "subscriptionId", newJString(subscriptionId))
  add(path_564098, "resourceGroupName", newJString(resourceGroupName))
  add(path_564098, "workspaceName", newJString(workspaceName))
  add(path_564098, "experimentId", newJString(experimentId))
  result = call_564097.call(path_564098, nil, nil, nil, body_564099)

var experimentsDeleteTags* = Call_ExperimentsDeleteTags_564088(
    name: "experimentsDeleteTags", meth: HttpMethod.HttpDelete, host: "azure.local", route: "/history/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/experimentids/{experimentId}/tags",
    validator: validate_ExperimentsDeleteTags_564089, base: "",
    url: url_ExperimentsDeleteTags_564090, schemes: {Scheme.Https})
type
  Call_ExperimentsCreate_564110 = ref object of OpenApiRestCall_563539
proc url_ExperimentsCreate_564112(protocol: Scheme; host: string; base: string;
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

proc validate_ExperimentsCreate_564111(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Create a new Experiment.
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
  var valid_564113 = path.getOrDefault("subscriptionId")
  valid_564113 = validateParameter(valid_564113, JString, required = true,
                                 default = nil)
  if valid_564113 != nil:
    section.add "subscriptionId", valid_564113
  var valid_564114 = path.getOrDefault("experimentName")
  valid_564114 = validateParameter(valid_564114, JString, required = true,
                                 default = nil)
  if valid_564114 != nil:
    section.add "experimentName", valid_564114
  var valid_564115 = path.getOrDefault("resourceGroupName")
  valid_564115 = validateParameter(valid_564115, JString, required = true,
                                 default = nil)
  if valid_564115 != nil:
    section.add "resourceGroupName", valid_564115
  var valid_564116 = path.getOrDefault("workspaceName")
  valid_564116 = validateParameter(valid_564116, JString, required = true,
                                 default = nil)
  if valid_564116 != nil:
    section.add "workspaceName", valid_564116
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564117: Call_ExperimentsCreate_564110; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a new Experiment.
  ## 
  let valid = call_564117.validator(path, query, header, formData, body)
  let scheme = call_564117.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564117.url(scheme.get, call_564117.host, call_564117.base,
                         call_564117.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564117, url, valid)

proc call*(call_564118: Call_ExperimentsCreate_564110; subscriptionId: string;
          experimentName: string; resourceGroupName: string; workspaceName: string): Recallable =
  ## experimentsCreate
  ## Create a new Experiment.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   experimentName: string (required)
  ##                 : The experiment name.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_564119 = newJObject()
  add(path_564119, "subscriptionId", newJString(subscriptionId))
  add(path_564119, "experimentName", newJString(experimentName))
  add(path_564119, "resourceGroupName", newJString(resourceGroupName))
  add(path_564119, "workspaceName", newJString(workspaceName))
  result = call_564118.call(path_564119, nil, nil, nil, nil)

var experimentsCreate* = Call_ExperimentsCreate_564110(name: "experimentsCreate",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/history/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/experiments/{experimentName}",
    validator: validate_ExperimentsCreate_564111, base: "",
    url: url_ExperimentsCreate_564112, schemes: {Scheme.Https})
type
  Call_ExperimentsGet_564100 = ref object of OpenApiRestCall_563539
proc url_ExperimentsGet_564102(protocol: Scheme; host: string; base: string;
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

proc validate_ExperimentsGet_564101(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Get details of an Experiment with specific Experiment name.
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
  var valid_564103 = path.getOrDefault("subscriptionId")
  valid_564103 = validateParameter(valid_564103, JString, required = true,
                                 default = nil)
  if valid_564103 != nil:
    section.add "subscriptionId", valid_564103
  var valid_564104 = path.getOrDefault("experimentName")
  valid_564104 = validateParameter(valid_564104, JString, required = true,
                                 default = nil)
  if valid_564104 != nil:
    section.add "experimentName", valid_564104
  var valid_564105 = path.getOrDefault("resourceGroupName")
  valid_564105 = validateParameter(valid_564105, JString, required = true,
                                 default = nil)
  if valid_564105 != nil:
    section.add "resourceGroupName", valid_564105
  var valid_564106 = path.getOrDefault("workspaceName")
  valid_564106 = validateParameter(valid_564106, JString, required = true,
                                 default = nil)
  if valid_564106 != nil:
    section.add "workspaceName", valid_564106
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564107: Call_ExperimentsGet_564100; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get details of an Experiment with specific Experiment name.
  ## 
  let valid = call_564107.validator(path, query, header, formData, body)
  let scheme = call_564107.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564107.url(scheme.get, call_564107.host, call_564107.base,
                         call_564107.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564107, url, valid)

proc call*(call_564108: Call_ExperimentsGet_564100; subscriptionId: string;
          experimentName: string; resourceGroupName: string; workspaceName: string): Recallable =
  ## experimentsGet
  ## Get details of an Experiment with specific Experiment name.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   experimentName: string (required)
  ##                 : The experiment name.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_564109 = newJObject()
  add(path_564109, "subscriptionId", newJString(subscriptionId))
  add(path_564109, "experimentName", newJString(experimentName))
  add(path_564109, "resourceGroupName", newJString(resourceGroupName))
  add(path_564109, "workspaceName", newJString(workspaceName))
  result = call_564108.call(path_564109, nil, nil, nil, nil)

var experimentsGet* = Call_ExperimentsGet_564100(name: "experimentsGet",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/history/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/experiments/{experimentName}",
    validator: validate_ExperimentsGet_564101, base: "", url: url_ExperimentsGet_564102,
    schemes: {Scheme.Https})
type
  Call_EventsBatchPost_564120 = ref object of OpenApiRestCall_563539
proc url_EventsBatchPost_564122(protocol: Scheme; host: string; base: string;
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

proc validate_EventsBatchPost_564121(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Post event data to a specific Run Id.
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
  var valid_564123 = path.getOrDefault("subscriptionId")
  valid_564123 = validateParameter(valid_564123, JString, required = true,
                                 default = nil)
  if valid_564123 != nil:
    section.add "subscriptionId", valid_564123
  var valid_564124 = path.getOrDefault("experimentName")
  valid_564124 = validateParameter(valid_564124, JString, required = true,
                                 default = nil)
  if valid_564124 != nil:
    section.add "experimentName", valid_564124
  var valid_564125 = path.getOrDefault("resourceGroupName")
  valid_564125 = validateParameter(valid_564125, JString, required = true,
                                 default = nil)
  if valid_564125 != nil:
    section.add "resourceGroupName", valid_564125
  var valid_564126 = path.getOrDefault("workspaceName")
  valid_564126 = validateParameter(valid_564126, JString, required = true,
                                 default = nil)
  if valid_564126 != nil:
    section.add "workspaceName", valid_564126
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

proc call*(call_564128: Call_EventsBatchPost_564120; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Post event data to a specific Run Id.
  ## 
  let valid = call_564128.validator(path, query, header, formData, body)
  let scheme = call_564128.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564128.url(scheme.get, call_564128.host, call_564128.base,
                         call_564128.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564128, url, valid)

proc call*(call_564129: Call_EventsBatchPost_564120; subscriptionId: string;
          experimentName: string; resourceGroupName: string; workspaceName: string;
          batchEventCommand: JsonNode = nil): Recallable =
  ## eventsBatchPost
  ## Post event data to a specific Run Id.
  ##   batchEventCommand: JObject
  ##                    : The batch of Event details.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   experimentName: string (required)
  ##                 : The experiment name.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_564130 = newJObject()
  var body_564131 = newJObject()
  if batchEventCommand != nil:
    body_564131 = batchEventCommand
  add(path_564130, "subscriptionId", newJString(subscriptionId))
  add(path_564130, "experimentName", newJString(experimentName))
  add(path_564130, "resourceGroupName", newJString(resourceGroupName))
  add(path_564130, "workspaceName", newJString(workspaceName))
  result = call_564129.call(path_564130, nil, nil, nil, body_564131)

var eventsBatchPost* = Call_EventsBatchPost_564120(name: "eventsBatchPost",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/history/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/experiments/{experimentName}/batch/events",
    validator: validate_EventsBatchPost_564121, base: "", url: url_EventsBatchPost_564122,
    schemes: {Scheme.Https})
type
  Call_RunsBatchAddOrModify_564132 = ref object of OpenApiRestCall_563539
proc url_RunsBatchAddOrModify_564134(protocol: Scheme; host: string; base: string;
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

proc validate_RunsBatchAddOrModify_564133(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Add or Modify a batch of Runs for a given experiment.
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
  var valid_564135 = path.getOrDefault("subscriptionId")
  valid_564135 = validateParameter(valid_564135, JString, required = true,
                                 default = nil)
  if valid_564135 != nil:
    section.add "subscriptionId", valid_564135
  var valid_564136 = path.getOrDefault("experimentName")
  valid_564136 = validateParameter(valid_564136, JString, required = true,
                                 default = nil)
  if valid_564136 != nil:
    section.add "experimentName", valid_564136
  var valid_564137 = path.getOrDefault("resourceGroupName")
  valid_564137 = validateParameter(valid_564137, JString, required = true,
                                 default = nil)
  if valid_564137 != nil:
    section.add "resourceGroupName", valid_564137
  var valid_564138 = path.getOrDefault("workspaceName")
  valid_564138 = validateParameter(valid_564138, JString, required = true,
                                 default = nil)
  if valid_564138 != nil:
    section.add "workspaceName", valid_564138
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

proc call*(call_564140: Call_RunsBatchAddOrModify_564132; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Add or Modify a batch of Runs for a given experiment.
  ## 
  let valid = call_564140.validator(path, query, header, formData, body)
  let scheme = call_564140.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564140.url(scheme.get, call_564140.host, call_564140.base,
                         call_564140.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564140, url, valid)

proc call*(call_564141: Call_RunsBatchAddOrModify_564132; subscriptionId: string;
          experimentName: string; resourceGroupName: string; workspaceName: string;
          requestDto: JsonNode = nil): Recallable =
  ## runsBatchAddOrModify
  ## Add or Modify a batch of Runs for a given experiment.
  ##   requestDto: JObject
  ##             : The list of requested Run Additions/modifications in an Experiment.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   experimentName: string (required)
  ##                 : The experiment name.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_564142 = newJObject()
  var body_564143 = newJObject()
  if requestDto != nil:
    body_564143 = requestDto
  add(path_564142, "subscriptionId", newJString(subscriptionId))
  add(path_564142, "experimentName", newJString(experimentName))
  add(path_564142, "resourceGroupName", newJString(resourceGroupName))
  add(path_564142, "workspaceName", newJString(workspaceName))
  result = call_564141.call(path_564142, nil, nil, nil, body_564143)

var runsBatchAddOrModify* = Call_RunsBatchAddOrModify_564132(
    name: "runsBatchAddOrModify", meth: HttpMethod.HttpPatch, host: "azure.local", route: "/history/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/experiments/{experimentName}/batch/runs",
    validator: validate_RunsBatchAddOrModify_564133, base: "",
    url: url_RunsBatchAddOrModify_564134, schemes: {Scheme.Https})
type
  Call_RunMetricsGet_564144 = ref object of OpenApiRestCall_563539
proc url_RunMetricsGet_564146(protocol: Scheme; host: string; base: string;
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

proc validate_RunMetricsGet_564145(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Get Metric details for a specific Metric Id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   metricId: JString (required)
  ##           : The identifier for a Metric.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   experimentName: JString (required)
  ##                 : The experiment name.
  ##   resourceGroupName: JString (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `metricId` field"
  var valid_564147 = path.getOrDefault("metricId")
  valid_564147 = validateParameter(valid_564147, JString, required = true,
                                 default = nil)
  if valid_564147 != nil:
    section.add "metricId", valid_564147
  var valid_564148 = path.getOrDefault("subscriptionId")
  valid_564148 = validateParameter(valid_564148, JString, required = true,
                                 default = nil)
  if valid_564148 != nil:
    section.add "subscriptionId", valid_564148
  var valid_564149 = path.getOrDefault("experimentName")
  valid_564149 = validateParameter(valid_564149, JString, required = true,
                                 default = nil)
  if valid_564149 != nil:
    section.add "experimentName", valid_564149
  var valid_564150 = path.getOrDefault("resourceGroupName")
  valid_564150 = validateParameter(valid_564150, JString, required = true,
                                 default = nil)
  if valid_564150 != nil:
    section.add "resourceGroupName", valid_564150
  var valid_564151 = path.getOrDefault("workspaceName")
  valid_564151 = validateParameter(valid_564151, JString, required = true,
                                 default = nil)
  if valid_564151 != nil:
    section.add "workspaceName", valid_564151
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564152: Call_RunMetricsGet_564144; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get Metric details for a specific Metric Id.
  ## 
  let valid = call_564152.validator(path, query, header, formData, body)
  let scheme = call_564152.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564152.url(scheme.get, call_564152.host, call_564152.base,
                         call_564152.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564152, url, valid)

proc call*(call_564153: Call_RunMetricsGet_564144; metricId: string;
          subscriptionId: string; experimentName: string; resourceGroupName: string;
          workspaceName: string): Recallable =
  ## runMetricsGet
  ## Get Metric details for a specific Metric Id.
  ##   metricId: string (required)
  ##           : The identifier for a Metric.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   experimentName: string (required)
  ##                 : The experiment name.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_564154 = newJObject()
  add(path_564154, "metricId", newJString(metricId))
  add(path_564154, "subscriptionId", newJString(subscriptionId))
  add(path_564154, "experimentName", newJString(experimentName))
  add(path_564154, "resourceGroupName", newJString(resourceGroupName))
  add(path_564154, "workspaceName", newJString(workspaceName))
  result = call_564153.call(path_564154, nil, nil, nil, nil)

var runMetricsGet* = Call_RunMetricsGet_564144(name: "runMetricsGet",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/history/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/experiments/{experimentName}/metrics/{metricId}",
    validator: validate_RunMetricsGet_564145, base: "", url: url_RunMetricsGet_564146,
    schemes: {Scheme.Https})
type
  Call_RunMetricsGetByQuery_564155 = ref object of OpenApiRestCall_563539
proc url_RunMetricsGetByQuery_564157(protocol: Scheme; host: string; base: string;
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

proc validate_RunMetricsGetByQuery_564156(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get all Run Metrics for the specific Experiment with the specified query filters.
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
  var valid_564158 = path.getOrDefault("subscriptionId")
  valid_564158 = validateParameter(valid_564158, JString, required = true,
                                 default = nil)
  if valid_564158 != nil:
    section.add "subscriptionId", valid_564158
  var valid_564159 = path.getOrDefault("experimentName")
  valid_564159 = validateParameter(valid_564159, JString, required = true,
                                 default = nil)
  if valid_564159 != nil:
    section.add "experimentName", valid_564159
  var valid_564160 = path.getOrDefault("resourceGroupName")
  valid_564160 = validateParameter(valid_564160, JString, required = true,
                                 default = nil)
  if valid_564160 != nil:
    section.add "resourceGroupName", valid_564160
  var valid_564161 = path.getOrDefault("workspaceName")
  valid_564161 = validateParameter(valid_564161, JString, required = true,
                                 default = nil)
  if valid_564161 != nil:
    section.add "workspaceName", valid_564161
  result.add "path", section
  ## parameters in `query` object:
  ##   MergeStrategyType: JString
  ##                    : The type of merge strategy. Currently supported strategies are:
  ## None - all logged values are returned as individual metrics.
  ## MergeToVector - merges multiple values into a vector of values.
  ## Default - the system determines the behavior.
  ##   MergeStrategySettings.Version: JString
  ##                                : The strategy settings version.
  ##   MergeStrategySettings.SelectMetrics: JString
  ##                                      : Defines how to select metrics when merging them together.
  ##   MergeStrategyOptions: JString
  ##                       : Controls behavior of the merge strategy in certain cases; e.g. when a metric is not merged.
  section = newJObject()
  var valid_564175 = query.getOrDefault("MergeStrategyType")
  valid_564175 = validateParameter(valid_564175, JString, required = false,
                                 default = newJString("Default"))
  if valid_564175 != nil:
    section.add "MergeStrategyType", valid_564175
  var valid_564176 = query.getOrDefault("MergeStrategySettings.Version")
  valid_564176 = validateParameter(valid_564176, JString, required = false,
                                 default = nil)
  if valid_564176 != nil:
    section.add "MergeStrategySettings.Version", valid_564176
  var valid_564177 = query.getOrDefault("MergeStrategySettings.SelectMetrics")
  valid_564177 = validateParameter(valid_564177, JString, required = false,
                                 default = newJString("SelectAll"))
  if valid_564177 != nil:
    section.add "MergeStrategySettings.SelectMetrics", valid_564177
  var valid_564178 = query.getOrDefault("MergeStrategyOptions")
  valid_564178 = validateParameter(valid_564178, JString, required = false,
                                 default = newJString("None"))
  if valid_564178 != nil:
    section.add "MergeStrategyOptions", valid_564178
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

proc call*(call_564180: Call_RunMetricsGetByQuery_564155; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all Run Metrics for the specific Experiment with the specified query filters.
  ## 
  let valid = call_564180.validator(path, query, header, formData, body)
  let scheme = call_564180.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564180.url(scheme.get, call_564180.host, call_564180.base,
                         call_564180.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564180, url, valid)

proc call*(call_564181: Call_RunMetricsGetByQuery_564155; subscriptionId: string;
          experimentName: string; resourceGroupName: string; workspaceName: string;
          MergeStrategyType: string = "Default";
          MergeStrategySettingsVersion: string = "";
          MergeStrategySettingsSelectMetrics: string = "SelectAll";
          MergeStrategyOptions: string = "None"; queryParams: JsonNode = nil): Recallable =
  ## runMetricsGetByQuery
  ## Get all Run Metrics for the specific Experiment with the specified query filters.
  ##   MergeStrategyType: string
  ##                    : The type of merge strategy. Currently supported strategies are:
  ## None - all logged values are returned as individual metrics.
  ## MergeToVector - merges multiple values into a vector of values.
  ## Default - the system determines the behavior.
  ##   MergeStrategySettingsVersion: string
  ##                               : The strategy settings version.
  ##   MergeStrategySettingsSelectMetrics: string
  ##                                     : Defines how to select metrics when merging them together.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   experimentName: string (required)
  ##                 : The experiment name.
  ##   MergeStrategyOptions: string
  ##                       : Controls behavior of the merge strategy in certain cases; e.g. when a metric is not merged.
  ##   queryParams: JObject
  ##              : Query Parameters for data sorting and filtering.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_564182 = newJObject()
  var query_564183 = newJObject()
  var body_564184 = newJObject()
  add(query_564183, "MergeStrategyType", newJString(MergeStrategyType))
  add(query_564183, "MergeStrategySettings.Version",
      newJString(MergeStrategySettingsVersion))
  add(query_564183, "MergeStrategySettings.SelectMetrics",
      newJString(MergeStrategySettingsSelectMetrics))
  add(path_564182, "subscriptionId", newJString(subscriptionId))
  add(path_564182, "experimentName", newJString(experimentName))
  add(query_564183, "MergeStrategyOptions", newJString(MergeStrategyOptions))
  if queryParams != nil:
    body_564184 = queryParams
  add(path_564182, "resourceGroupName", newJString(resourceGroupName))
  add(path_564182, "workspaceName", newJString(workspaceName))
  result = call_564181.call(path_564182, query_564183, nil, nil, body_564184)

var runMetricsGetByQuery* = Call_RunMetricsGetByQuery_564155(
    name: "runMetricsGetByQuery", meth: HttpMethod.HttpPost, host: "azure.local", route: "/history/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/experiments/{experimentName}/metrics:query",
    validator: validate_RunMetricsGetByQuery_564156, base: "",
    url: url_RunMetricsGetByQuery_564157, schemes: {Scheme.Https})
type
  Call_RunsGet_564185 = ref object of OpenApiRestCall_563539
proc url_RunsGet_564187(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_RunsGet_564186(path: JsonNode; query: JsonNode; header: JsonNode;
                            formData: JsonNode; body: JsonNode): JsonNode =
  ## Get Run details of a specific Run Id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   runId: JString (required)
  ##        : The identifier of the Run.
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
  var valid_564188 = path.getOrDefault("runId")
  valid_564188 = validateParameter(valid_564188, JString, required = true,
                                 default = nil)
  if valid_564188 != nil:
    section.add "runId", valid_564188
  var valid_564189 = path.getOrDefault("subscriptionId")
  valid_564189 = validateParameter(valid_564189, JString, required = true,
                                 default = nil)
  if valid_564189 != nil:
    section.add "subscriptionId", valid_564189
  var valid_564190 = path.getOrDefault("experimentName")
  valid_564190 = validateParameter(valid_564190, JString, required = true,
                                 default = nil)
  if valid_564190 != nil:
    section.add "experimentName", valid_564190
  var valid_564191 = path.getOrDefault("resourceGroupName")
  valid_564191 = validateParameter(valid_564191, JString, required = true,
                                 default = nil)
  if valid_564191 != nil:
    section.add "resourceGroupName", valid_564191
  var valid_564192 = path.getOrDefault("workspaceName")
  valid_564192 = validateParameter(valid_564192, JString, required = true,
                                 default = nil)
  if valid_564192 != nil:
    section.add "workspaceName", valid_564192
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564193: Call_RunsGet_564185; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get Run details of a specific Run Id.
  ## 
  let valid = call_564193.validator(path, query, header, formData, body)
  let scheme = call_564193.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564193.url(scheme.get, call_564193.host, call_564193.base,
                         call_564193.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564193, url, valid)

proc call*(call_564194: Call_RunsGet_564185; runId: string; subscriptionId: string;
          experimentName: string; resourceGroupName: string; workspaceName: string): Recallable =
  ## runsGet
  ## Get Run details of a specific Run Id.
  ##   runId: string (required)
  ##        : The identifier of the Run.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   experimentName: string (required)
  ##                 : The experiment name.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_564195 = newJObject()
  add(path_564195, "runId", newJString(runId))
  add(path_564195, "subscriptionId", newJString(subscriptionId))
  add(path_564195, "experimentName", newJString(experimentName))
  add(path_564195, "resourceGroupName", newJString(resourceGroupName))
  add(path_564195, "workspaceName", newJString(workspaceName))
  result = call_564194.call(path_564195, nil, nil, nil, nil)

var runsGet* = Call_RunsGet_564185(name: "runsGet", meth: HttpMethod.HttpGet,
                                host: "azure.local", route: "/history/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/experiments/{experimentName}/runs/{runId}",
                                validator: validate_RunsGet_564186, base: "",
                                url: url_RunsGet_564187, schemes: {Scheme.Https})
type
  Call_RunsPatch_564196 = ref object of OpenApiRestCall_563539
proc url_RunsPatch_564198(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_RunsPatch_564197(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Add a new Run or Modify an existing Run.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   runId: JString (required)
  ##        : The identifier of the Run.
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
  var valid_564199 = path.getOrDefault("runId")
  valid_564199 = validateParameter(valid_564199, JString, required = true,
                                 default = nil)
  if valid_564199 != nil:
    section.add "runId", valid_564199
  var valid_564200 = path.getOrDefault("subscriptionId")
  valid_564200 = validateParameter(valid_564200, JString, required = true,
                                 default = nil)
  if valid_564200 != nil:
    section.add "subscriptionId", valid_564200
  var valid_564201 = path.getOrDefault("experimentName")
  valid_564201 = validateParameter(valid_564201, JString, required = true,
                                 default = nil)
  if valid_564201 != nil:
    section.add "experimentName", valid_564201
  var valid_564202 = path.getOrDefault("resourceGroupName")
  valid_564202 = validateParameter(valid_564202, JString, required = true,
                                 default = nil)
  if valid_564202 != nil:
    section.add "resourceGroupName", valid_564202
  var valid_564203 = path.getOrDefault("workspaceName")
  valid_564203 = validateParameter(valid_564203, JString, required = true,
                                 default = nil)
  if valid_564203 != nil:
    section.add "workspaceName", valid_564203
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

proc call*(call_564205: Call_RunsPatch_564196; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Add a new Run or Modify an existing Run.
  ## 
  let valid = call_564205.validator(path, query, header, formData, body)
  let scheme = call_564205.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564205.url(scheme.get, call_564205.host, call_564205.base,
                         call_564205.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564205, url, valid)

proc call*(call_564206: Call_RunsPatch_564196; runId: string; subscriptionId: string;
          experimentName: string; resourceGroupName: string; workspaceName: string;
          createRunDto: JsonNode = nil): Recallable =
  ## runsPatch
  ## Add a new Run or Modify an existing Run.
  ##   runId: string (required)
  ##        : The identifier of the Run.
  ##   createRunDto: JObject
  ##               : The requested Run parameter Additions/modifications.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   experimentName: string (required)
  ##                 : The experiment name.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_564207 = newJObject()
  var body_564208 = newJObject()
  add(path_564207, "runId", newJString(runId))
  if createRunDto != nil:
    body_564208 = createRunDto
  add(path_564207, "subscriptionId", newJString(subscriptionId))
  add(path_564207, "experimentName", newJString(experimentName))
  add(path_564207, "resourceGroupName", newJString(resourceGroupName))
  add(path_564207, "workspaceName", newJString(workspaceName))
  result = call_564206.call(path_564207, nil, nil, nil, body_564208)

var runsPatch* = Call_RunsPatch_564196(name: "runsPatch", meth: HttpMethod.HttpPatch,
                                    host: "azure.local", route: "/history/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/experiments/{experimentName}/runs/{runId}",
                                    validator: validate_RunsPatch_564197,
                                    base: "", url: url_RunsPatch_564198,
                                    schemes: {Scheme.Https})
type
  Call_RunArtifactsListInContainer_564209 = ref object of OpenApiRestCall_563539
proc url_RunArtifactsListInContainer_564211(protocol: Scheme; host: string;
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

proc validate_RunArtifactsListInContainer_564210(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get Artifacts in container for a specific Run Id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   runId: JString (required)
  ##        : The identifier of the Run.
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
  var valid_564212 = path.getOrDefault("runId")
  valid_564212 = validateParameter(valid_564212, JString, required = true,
                                 default = nil)
  if valid_564212 != nil:
    section.add "runId", valid_564212
  var valid_564213 = path.getOrDefault("subscriptionId")
  valid_564213 = validateParameter(valid_564213, JString, required = true,
                                 default = nil)
  if valid_564213 != nil:
    section.add "subscriptionId", valid_564213
  var valid_564214 = path.getOrDefault("experimentName")
  valid_564214 = validateParameter(valid_564214, JString, required = true,
                                 default = nil)
  if valid_564214 != nil:
    section.add "experimentName", valid_564214
  var valid_564215 = path.getOrDefault("resourceGroupName")
  valid_564215 = validateParameter(valid_564215, JString, required = true,
                                 default = nil)
  if valid_564215 != nil:
    section.add "resourceGroupName", valid_564215
  var valid_564216 = path.getOrDefault("workspaceName")
  valid_564216 = validateParameter(valid_564216, JString, required = true,
                                 default = nil)
  if valid_564216 != nil:
    section.add "workspaceName", valid_564216
  result.add "path", section
  ## parameters in `query` object:
  ##   continuationToken: JString
  ##                    : The Continuation Token.
  section = newJObject()
  var valid_564217 = query.getOrDefault("continuationToken")
  valid_564217 = validateParameter(valid_564217, JString, required = false,
                                 default = nil)
  if valid_564217 != nil:
    section.add "continuationToken", valid_564217
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564218: Call_RunArtifactsListInContainer_564209; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get Artifacts in container for a specific Run Id.
  ## 
  let valid = call_564218.validator(path, query, header, formData, body)
  let scheme = call_564218.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564218.url(scheme.get, call_564218.host, call_564218.base,
                         call_564218.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564218, url, valid)

proc call*(call_564219: Call_RunArtifactsListInContainer_564209; runId: string;
          subscriptionId: string; experimentName: string; resourceGroupName: string;
          workspaceName: string; continuationToken: string = ""): Recallable =
  ## runArtifactsListInContainer
  ## Get Artifacts in container for a specific Run Id.
  ##   runId: string (required)
  ##        : The identifier of the Run.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   experimentName: string (required)
  ##                 : The experiment name.
  ##   continuationToken: string
  ##                    : The Continuation Token.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_564220 = newJObject()
  var query_564221 = newJObject()
  add(path_564220, "runId", newJString(runId))
  add(path_564220, "subscriptionId", newJString(subscriptionId))
  add(path_564220, "experimentName", newJString(experimentName))
  add(query_564221, "continuationToken", newJString(continuationToken))
  add(path_564220, "resourceGroupName", newJString(resourceGroupName))
  add(path_564220, "workspaceName", newJString(workspaceName))
  result = call_564219.call(path_564220, query_564221, nil, nil, nil)

var runArtifactsListInContainer* = Call_RunArtifactsListInContainer_564209(
    name: "runArtifactsListInContainer", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/history/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/experiments/{experimentName}/runs/{runId}/artifacts",
    validator: validate_RunArtifactsListInContainer_564210, base: "",
    url: url_RunArtifactsListInContainer_564211, schemes: {Scheme.Https})
type
  Call_RunArtifactsGetSasUri_564222 = ref object of OpenApiRestCall_563539
proc url_RunArtifactsGetSasUri_564224(protocol: Scheme; host: string; base: string;
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

proc validate_RunArtifactsGetSasUri_564223(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get URI of an Artifact for a specific Run Id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   runId: JString (required)
  ##        : The identifier of the Run.
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
  var valid_564225 = path.getOrDefault("runId")
  valid_564225 = validateParameter(valid_564225, JString, required = true,
                                 default = nil)
  if valid_564225 != nil:
    section.add "runId", valid_564225
  var valid_564226 = path.getOrDefault("subscriptionId")
  valid_564226 = validateParameter(valid_564226, JString, required = true,
                                 default = nil)
  if valid_564226 != nil:
    section.add "subscriptionId", valid_564226
  var valid_564227 = path.getOrDefault("experimentName")
  valid_564227 = validateParameter(valid_564227, JString, required = true,
                                 default = nil)
  if valid_564227 != nil:
    section.add "experimentName", valid_564227
  var valid_564228 = path.getOrDefault("resourceGroupName")
  valid_564228 = validateParameter(valid_564228, JString, required = true,
                                 default = nil)
  if valid_564228 != nil:
    section.add "resourceGroupName", valid_564228
  var valid_564229 = path.getOrDefault("workspaceName")
  valid_564229 = validateParameter(valid_564229, JString, required = true,
                                 default = nil)
  if valid_564229 != nil:
    section.add "workspaceName", valid_564229
  result.add "path", section
  ## parameters in `query` object:
  ##   path: JString
  ##       : The Artifact Path.
  section = newJObject()
  var valid_564230 = query.getOrDefault("path")
  valid_564230 = validateParameter(valid_564230, JString, required = false,
                                 default = nil)
  if valid_564230 != nil:
    section.add "path", valid_564230
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564231: Call_RunArtifactsGetSasUri_564222; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get URI of an Artifact for a specific Run Id.
  ## 
  let valid = call_564231.validator(path, query, header, formData, body)
  let scheme = call_564231.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564231.url(scheme.get, call_564231.host, call_564231.base,
                         call_564231.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564231, url, valid)

proc call*(call_564232: Call_RunArtifactsGetSasUri_564222; runId: string;
          subscriptionId: string; experimentName: string; resourceGroupName: string;
          workspaceName: string; path: string = ""): Recallable =
  ## runArtifactsGetSasUri
  ## Get URI of an Artifact for a specific Run Id.
  ##   runId: string (required)
  ##        : The identifier of the Run.
  ##   path: string
  ##       : The Artifact Path.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   experimentName: string (required)
  ##                 : The experiment name.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_564233 = newJObject()
  var query_564234 = newJObject()
  add(path_564233, "runId", newJString(runId))
  add(query_564234, "path", newJString(path))
  add(path_564233, "subscriptionId", newJString(subscriptionId))
  add(path_564233, "experimentName", newJString(experimentName))
  add(path_564233, "resourceGroupName", newJString(resourceGroupName))
  add(path_564233, "workspaceName", newJString(workspaceName))
  result = call_564232.call(path_564233, query_564234, nil, nil, nil)

var runArtifactsGetSasUri* = Call_RunArtifactsGetSasUri_564222(
    name: "runArtifactsGetSasUri", meth: HttpMethod.HttpGet, host: "azure.local", route: "/history/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/experiments/{experimentName}/runs/{runId}/artifacts/artifacturi",
    validator: validate_RunArtifactsGetSasUri_564223, base: "",
    url: url_RunArtifactsGetSasUri_564224, schemes: {Scheme.Https})
type
  Call_RunArtifactsBatchCreateEmptyArtifacts_564235 = ref object of OpenApiRestCall_563539
proc url_RunArtifactsBatchCreateEmptyArtifacts_564237(protocol: Scheme;
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

proc validate_RunArtifactsBatchCreateEmptyArtifacts_564236(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a batch of empty Artifacts in a specific Run.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   runId: JString (required)
  ##        : The identifier of the Run.
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
  var valid_564238 = path.getOrDefault("runId")
  valid_564238 = validateParameter(valid_564238, JString, required = true,
                                 default = nil)
  if valid_564238 != nil:
    section.add "runId", valid_564238
  var valid_564239 = path.getOrDefault("subscriptionId")
  valid_564239 = validateParameter(valid_564239, JString, required = true,
                                 default = nil)
  if valid_564239 != nil:
    section.add "subscriptionId", valid_564239
  var valid_564240 = path.getOrDefault("experimentName")
  valid_564240 = validateParameter(valid_564240, JString, required = true,
                                 default = nil)
  if valid_564240 != nil:
    section.add "experimentName", valid_564240
  var valid_564241 = path.getOrDefault("resourceGroupName")
  valid_564241 = validateParameter(valid_564241, JString, required = true,
                                 default = nil)
  if valid_564241 != nil:
    section.add "resourceGroupName", valid_564241
  var valid_564242 = path.getOrDefault("workspaceName")
  valid_564242 = validateParameter(valid_564242, JString, required = true,
                                 default = nil)
  if valid_564242 != nil:
    section.add "workspaceName", valid_564242
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

proc call*(call_564244: Call_RunArtifactsBatchCreateEmptyArtifacts_564235;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a batch of empty Artifacts in a specific Run.
  ## 
  let valid = call_564244.validator(path, query, header, formData, body)
  let scheme = call_564244.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564244.url(scheme.get, call_564244.host, call_564244.base,
                         call_564244.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564244, url, valid)

proc call*(call_564245: Call_RunArtifactsBatchCreateEmptyArtifacts_564235;
          runId: string; subscriptionId: string; experimentName: string;
          resourceGroupName: string; workspaceName: string;
          artifactPaths: JsonNode = nil): Recallable =
  ## runArtifactsBatchCreateEmptyArtifacts
  ## Create a batch of empty Artifacts in a specific Run.
  ##   runId: string (required)
  ##        : The identifier of the Run.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   experimentName: string (required)
  ##                 : The experiment name.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   artifactPaths: JObject
  ##                : The list of artifact paths.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_564246 = newJObject()
  var body_564247 = newJObject()
  add(path_564246, "runId", newJString(runId))
  add(path_564246, "subscriptionId", newJString(subscriptionId))
  add(path_564246, "experimentName", newJString(experimentName))
  add(path_564246, "resourceGroupName", newJString(resourceGroupName))
  if artifactPaths != nil:
    body_564247 = artifactPaths
  add(path_564246, "workspaceName", newJString(workspaceName))
  result = call_564245.call(path_564246, nil, nil, nil, body_564247)

var runArtifactsBatchCreateEmptyArtifacts* = Call_RunArtifactsBatchCreateEmptyArtifacts_564235(
    name: "runArtifactsBatchCreateEmptyArtifacts", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/history/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/experiments/{experimentName}/runs/{runId}/artifacts/batch/metadata",
    validator: validate_RunArtifactsBatchCreateEmptyArtifacts_564236, base: "",
    url: url_RunArtifactsBatchCreateEmptyArtifacts_564237, schemes: {Scheme.Https})
type
  Call_RunArtifactsGetContentInformation_564248 = ref object of OpenApiRestCall_563539
proc url_RunArtifactsGetContentInformation_564250(protocol: Scheme; host: string;
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

proc validate_RunArtifactsGetContentInformation_564249(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get Artifact content information for give Run Id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   runId: JString (required)
  ##        : The identifier of the Run.
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
  var valid_564251 = path.getOrDefault("runId")
  valid_564251 = validateParameter(valid_564251, JString, required = true,
                                 default = nil)
  if valid_564251 != nil:
    section.add "runId", valid_564251
  var valid_564252 = path.getOrDefault("subscriptionId")
  valid_564252 = validateParameter(valid_564252, JString, required = true,
                                 default = nil)
  if valid_564252 != nil:
    section.add "subscriptionId", valid_564252
  var valid_564253 = path.getOrDefault("experimentName")
  valid_564253 = validateParameter(valid_564253, JString, required = true,
                                 default = nil)
  if valid_564253 != nil:
    section.add "experimentName", valid_564253
  var valid_564254 = path.getOrDefault("resourceGroupName")
  valid_564254 = validateParameter(valid_564254, JString, required = true,
                                 default = nil)
  if valid_564254 != nil:
    section.add "resourceGroupName", valid_564254
  var valid_564255 = path.getOrDefault("workspaceName")
  valid_564255 = validateParameter(valid_564255, JString, required = true,
                                 default = nil)
  if valid_564255 != nil:
    section.add "workspaceName", valid_564255
  result.add "path", section
  ## parameters in `query` object:
  ##   path: JString
  ##       : The Artifact Path.
  section = newJObject()
  var valid_564256 = query.getOrDefault("path")
  valid_564256 = validateParameter(valid_564256, JString, required = false,
                                 default = nil)
  if valid_564256 != nil:
    section.add "path", valid_564256
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564257: Call_RunArtifactsGetContentInformation_564248;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get Artifact content information for give Run Id.
  ## 
  let valid = call_564257.validator(path, query, header, formData, body)
  let scheme = call_564257.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564257.url(scheme.get, call_564257.host, call_564257.base,
                         call_564257.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564257, url, valid)

proc call*(call_564258: Call_RunArtifactsGetContentInformation_564248;
          runId: string; subscriptionId: string; experimentName: string;
          resourceGroupName: string; workspaceName: string; path: string = ""): Recallable =
  ## runArtifactsGetContentInformation
  ## Get Artifact content information for give Run Id.
  ##   runId: string (required)
  ##        : The identifier of the Run.
  ##   path: string
  ##       : The Artifact Path.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   experimentName: string (required)
  ##                 : The experiment name.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_564259 = newJObject()
  var query_564260 = newJObject()
  add(path_564259, "runId", newJString(runId))
  add(query_564260, "path", newJString(path))
  add(path_564259, "subscriptionId", newJString(subscriptionId))
  add(path_564259, "experimentName", newJString(experimentName))
  add(path_564259, "resourceGroupName", newJString(resourceGroupName))
  add(path_564259, "workspaceName", newJString(workspaceName))
  result = call_564258.call(path_564259, query_564260, nil, nil, nil)

var runArtifactsGetContentInformation* = Call_RunArtifactsGetContentInformation_564248(
    name: "runArtifactsGetContentInformation", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/history/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/experiments/{experimentName}/runs/{runId}/artifacts/contentinfo",
    validator: validate_RunArtifactsGetContentInformation_564249, base: "",
    url: url_RunArtifactsGetContentInformation_564250, schemes: {Scheme.Https})
type
  Call_RunArtifactsGetById_564261 = ref object of OpenApiRestCall_563539
proc url_RunArtifactsGetById_564263(protocol: Scheme; host: string; base: string;
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

proc validate_RunArtifactsGetById_564262(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Get Artifact for a specific Id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   runId: JString (required)
  ##        : The identifier of the Run.
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
  var valid_564264 = path.getOrDefault("runId")
  valid_564264 = validateParameter(valid_564264, JString, required = true,
                                 default = nil)
  if valid_564264 != nil:
    section.add "runId", valid_564264
  var valid_564265 = path.getOrDefault("subscriptionId")
  valid_564265 = validateParameter(valid_564265, JString, required = true,
                                 default = nil)
  if valid_564265 != nil:
    section.add "subscriptionId", valid_564265
  var valid_564266 = path.getOrDefault("experimentName")
  valid_564266 = validateParameter(valid_564266, JString, required = true,
                                 default = nil)
  if valid_564266 != nil:
    section.add "experimentName", valid_564266
  var valid_564267 = path.getOrDefault("resourceGroupName")
  valid_564267 = validateParameter(valid_564267, JString, required = true,
                                 default = nil)
  if valid_564267 != nil:
    section.add "resourceGroupName", valid_564267
  var valid_564268 = path.getOrDefault("workspaceName")
  valid_564268 = validateParameter(valid_564268, JString, required = true,
                                 default = nil)
  if valid_564268 != nil:
    section.add "workspaceName", valid_564268
  result.add "path", section
  ## parameters in `query` object:
  ##   path: JString
  ##       : The Artifact Path.
  section = newJObject()
  var valid_564269 = query.getOrDefault("path")
  valid_564269 = validateParameter(valid_564269, JString, required = false,
                                 default = nil)
  if valid_564269 != nil:
    section.add "path", valid_564269
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564270: Call_RunArtifactsGetById_564261; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get Artifact for a specific Id.
  ## 
  let valid = call_564270.validator(path, query, header, formData, body)
  let scheme = call_564270.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564270.url(scheme.get, call_564270.host, call_564270.base,
                         call_564270.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564270, url, valid)

proc call*(call_564271: Call_RunArtifactsGetById_564261; runId: string;
          subscriptionId: string; experimentName: string; resourceGroupName: string;
          workspaceName: string; path: string = ""): Recallable =
  ## runArtifactsGetById
  ## Get Artifact for a specific Id.
  ##   runId: string (required)
  ##        : The identifier of the Run.
  ##   path: string
  ##       : The Artifact Path.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   experimentName: string (required)
  ##                 : The experiment name.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_564272 = newJObject()
  var query_564273 = newJObject()
  add(path_564272, "runId", newJString(runId))
  add(query_564273, "path", newJString(path))
  add(path_564272, "subscriptionId", newJString(subscriptionId))
  add(path_564272, "experimentName", newJString(experimentName))
  add(path_564272, "resourceGroupName", newJString(resourceGroupName))
  add(path_564272, "workspaceName", newJString(workspaceName))
  result = call_564271.call(path_564272, query_564273, nil, nil, nil)

var runArtifactsGetById* = Call_RunArtifactsGetById_564261(
    name: "runArtifactsGetById", meth: HttpMethod.HttpGet, host: "azure.local", route: "/history/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/experiments/{experimentName}/runs/{runId}/artifacts/metadata",
    validator: validate_RunArtifactsGetById_564262, base: "",
    url: url_RunArtifactsGetById_564263, schemes: {Scheme.Https})
type
  Call_RunArtifactsListInPath_564274 = ref object of OpenApiRestCall_563539
proc url_RunArtifactsListInPath_564276(protocol: Scheme; host: string; base: string;
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

proc validate_RunArtifactsListInPath_564275(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get Artifacts in the provided path for a specific Run Id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   runId: JString (required)
  ##        : The identifier of the Run.
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
  var valid_564277 = path.getOrDefault("runId")
  valid_564277 = validateParameter(valid_564277, JString, required = true,
                                 default = nil)
  if valid_564277 != nil:
    section.add "runId", valid_564277
  var valid_564278 = path.getOrDefault("subscriptionId")
  valid_564278 = validateParameter(valid_564278, JString, required = true,
                                 default = nil)
  if valid_564278 != nil:
    section.add "subscriptionId", valid_564278
  var valid_564279 = path.getOrDefault("experimentName")
  valid_564279 = validateParameter(valid_564279, JString, required = true,
                                 default = nil)
  if valid_564279 != nil:
    section.add "experimentName", valid_564279
  var valid_564280 = path.getOrDefault("resourceGroupName")
  valid_564280 = validateParameter(valid_564280, JString, required = true,
                                 default = nil)
  if valid_564280 != nil:
    section.add "resourceGroupName", valid_564280
  var valid_564281 = path.getOrDefault("workspaceName")
  valid_564281 = validateParameter(valid_564281, JString, required = true,
                                 default = nil)
  if valid_564281 != nil:
    section.add "workspaceName", valid_564281
  result.add "path", section
  ## parameters in `query` object:
  ##   path: JString
  ##       : The Artifact Path.
  ##   continuationToken: JString
  ##                    : The Continuation Token.
  section = newJObject()
  var valid_564282 = query.getOrDefault("path")
  valid_564282 = validateParameter(valid_564282, JString, required = false,
                                 default = nil)
  if valid_564282 != nil:
    section.add "path", valid_564282
  var valid_564283 = query.getOrDefault("continuationToken")
  valid_564283 = validateParameter(valid_564283, JString, required = false,
                                 default = nil)
  if valid_564283 != nil:
    section.add "continuationToken", valid_564283
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564284: Call_RunArtifactsListInPath_564274; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get Artifacts in the provided path for a specific Run Id.
  ## 
  let valid = call_564284.validator(path, query, header, formData, body)
  let scheme = call_564284.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564284.url(scheme.get, call_564284.host, call_564284.base,
                         call_564284.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564284, url, valid)

proc call*(call_564285: Call_RunArtifactsListInPath_564274; runId: string;
          subscriptionId: string; experimentName: string; resourceGroupName: string;
          workspaceName: string; path: string = ""; continuationToken: string = ""): Recallable =
  ## runArtifactsListInPath
  ## Get Artifacts in the provided path for a specific Run Id.
  ##   runId: string (required)
  ##        : The identifier of the Run.
  ##   path: string
  ##       : The Artifact Path.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   experimentName: string (required)
  ##                 : The experiment name.
  ##   continuationToken: string
  ##                    : The Continuation Token.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_564286 = newJObject()
  var query_564287 = newJObject()
  add(path_564286, "runId", newJString(runId))
  add(query_564287, "path", newJString(path))
  add(path_564286, "subscriptionId", newJString(subscriptionId))
  add(path_564286, "experimentName", newJString(experimentName))
  add(query_564287, "continuationToken", newJString(continuationToken))
  add(path_564286, "resourceGroupName", newJString(resourceGroupName))
  add(path_564286, "workspaceName", newJString(workspaceName))
  result = call_564285.call(path_564286, query_564287, nil, nil, nil)

var runArtifactsListInPath* = Call_RunArtifactsListInPath_564274(
    name: "runArtifactsListInPath", meth: HttpMethod.HttpGet, host: "azure.local", route: "/history/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/experiments/{experimentName}/runs/{runId}/artifacts/path",
    validator: validate_RunArtifactsListInPath_564275, base: "",
    url: url_RunArtifactsListInPath_564276, schemes: {Scheme.Https})
type
  Call_RunArtifactsListSasByPrefix_564288 = ref object of OpenApiRestCall_563539
proc url_RunArtifactsListSasByPrefix_564290(protocol: Scheme; host: string;
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

proc validate_RunArtifactsListSasByPrefix_564289(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get SAS of an Artifact in the specified path.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   runId: JString (required)
  ##        : The identifier of the Run.
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
  var valid_564291 = path.getOrDefault("runId")
  valid_564291 = validateParameter(valid_564291, JString, required = true,
                                 default = nil)
  if valid_564291 != nil:
    section.add "runId", valid_564291
  var valid_564292 = path.getOrDefault("subscriptionId")
  valid_564292 = validateParameter(valid_564292, JString, required = true,
                                 default = nil)
  if valid_564292 != nil:
    section.add "subscriptionId", valid_564292
  var valid_564293 = path.getOrDefault("experimentName")
  valid_564293 = validateParameter(valid_564293, JString, required = true,
                                 default = nil)
  if valid_564293 != nil:
    section.add "experimentName", valid_564293
  var valid_564294 = path.getOrDefault("resourceGroupName")
  valid_564294 = validateParameter(valid_564294, JString, required = true,
                                 default = nil)
  if valid_564294 != nil:
    section.add "resourceGroupName", valid_564294
  var valid_564295 = path.getOrDefault("workspaceName")
  valid_564295 = validateParameter(valid_564295, JString, required = true,
                                 default = nil)
  if valid_564295 != nil:
    section.add "workspaceName", valid_564295
  result.add "path", section
  ## parameters in `query` object:
  ##   path: JString
  ##       : The Artifact Path.
  ##   continuationToken: JString
  ##                    : The Continuation Token.
  section = newJObject()
  var valid_564296 = query.getOrDefault("path")
  valid_564296 = validateParameter(valid_564296, JString, required = false,
                                 default = nil)
  if valid_564296 != nil:
    section.add "path", valid_564296
  var valid_564297 = query.getOrDefault("continuationToken")
  valid_564297 = validateParameter(valid_564297, JString, required = false,
                                 default = nil)
  if valid_564297 != nil:
    section.add "continuationToken", valid_564297
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564298: Call_RunArtifactsListSasByPrefix_564288; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get SAS of an Artifact in the specified path.
  ## 
  let valid = call_564298.validator(path, query, header, formData, body)
  let scheme = call_564298.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564298.url(scheme.get, call_564298.host, call_564298.base,
                         call_564298.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564298, url, valid)

proc call*(call_564299: Call_RunArtifactsListSasByPrefix_564288; runId: string;
          subscriptionId: string; experimentName: string; resourceGroupName: string;
          workspaceName: string; path: string = ""; continuationToken: string = ""): Recallable =
  ## runArtifactsListSasByPrefix
  ## Get SAS of an Artifact in the specified path.
  ##   runId: string (required)
  ##        : The identifier of the Run.
  ##   path: string
  ##       : The Artifact Path.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   experimentName: string (required)
  ##                 : The experiment name.
  ##   continuationToken: string
  ##                    : The Continuation Token.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_564300 = newJObject()
  var query_564301 = newJObject()
  add(path_564300, "runId", newJString(runId))
  add(query_564301, "path", newJString(path))
  add(path_564300, "subscriptionId", newJString(subscriptionId))
  add(path_564300, "experimentName", newJString(experimentName))
  add(query_564301, "continuationToken", newJString(continuationToken))
  add(path_564300, "resourceGroupName", newJString(resourceGroupName))
  add(path_564300, "workspaceName", newJString(workspaceName))
  result = call_564299.call(path_564300, query_564301, nil, nil, nil)

var runArtifactsListSasByPrefix* = Call_RunArtifactsListSasByPrefix_564288(
    name: "runArtifactsListSasByPrefix", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/history/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/experiments/{experimentName}/runs/{runId}/artifacts/prefix/contentinfo",
    validator: validate_RunArtifactsListSasByPrefix_564289, base: "",
    url: url_RunArtifactsListSasByPrefix_564290, schemes: {Scheme.Https})
type
  Call_RunMetricsBatchPost_564302 = ref object of OpenApiRestCall_563539
proc url_RunMetricsBatchPost_564304(protocol: Scheme; host: string; base: string;
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

proc validate_RunMetricsBatchPost_564303(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Post Metrics to a specific Run Id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   runId: JString (required)
  ##        : The identifier for a run.
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
  var valid_564305 = path.getOrDefault("runId")
  valid_564305 = validateParameter(valid_564305, JString, required = true,
                                 default = nil)
  if valid_564305 != nil:
    section.add "runId", valid_564305
  var valid_564306 = path.getOrDefault("subscriptionId")
  valid_564306 = validateParameter(valid_564306, JString, required = true,
                                 default = nil)
  if valid_564306 != nil:
    section.add "subscriptionId", valid_564306
  var valid_564307 = path.getOrDefault("experimentName")
  valid_564307 = validateParameter(valid_564307, JString, required = true,
                                 default = nil)
  if valid_564307 != nil:
    section.add "experimentName", valid_564307
  var valid_564308 = path.getOrDefault("resourceGroupName")
  valid_564308 = validateParameter(valid_564308, JString, required = true,
                                 default = nil)
  if valid_564308 != nil:
    section.add "resourceGroupName", valid_564308
  var valid_564309 = path.getOrDefault("workspaceName")
  valid_564309 = validateParameter(valid_564309, JString, required = true,
                                 default = nil)
  if valid_564309 != nil:
    section.add "workspaceName", valid_564309
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

proc call*(call_564311: Call_RunMetricsBatchPost_564302; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Post Metrics to a specific Run Id.
  ## 
  let valid = call_564311.validator(path, query, header, formData, body)
  let scheme = call_564311.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564311.url(scheme.get, call_564311.host, call_564311.base,
                         call_564311.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564311, url, valid)

proc call*(call_564312: Call_RunMetricsBatchPost_564302; runId: string;
          subscriptionId: string; experimentName: string; resourceGroupName: string;
          workspaceName: string; batchMetricDto: JsonNode = nil): Recallable =
  ## runMetricsBatchPost
  ## Post Metrics to a specific Run Id.
  ##   runId: string (required)
  ##        : The identifier for a run.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   experimentName: string (required)
  ##                 : The experiment name.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   batchMetricDto: JObject
  ##                 : Details of the Metrics which will be added to the Run Id.
  var path_564313 = newJObject()
  var body_564314 = newJObject()
  add(path_564313, "runId", newJString(runId))
  add(path_564313, "subscriptionId", newJString(subscriptionId))
  add(path_564313, "experimentName", newJString(experimentName))
  add(path_564313, "resourceGroupName", newJString(resourceGroupName))
  add(path_564313, "workspaceName", newJString(workspaceName))
  if batchMetricDto != nil:
    body_564314 = batchMetricDto
  result = call_564312.call(path_564313, nil, nil, nil, body_564314)

var runMetricsBatchPost* = Call_RunMetricsBatchPost_564302(
    name: "runMetricsBatchPost", meth: HttpMethod.HttpPost, host: "azure.local", route: "/history/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/experiments/{experimentName}/runs/{runId}/batch/metrics",
    validator: validate_RunMetricsBatchPost_564303, base: "",
    url: url_RunMetricsBatchPost_564304, schemes: {Scheme.Https})
type
  Call_RunsGetChild_564315 = ref object of OpenApiRestCall_563539
proc url_RunsGetChild_564317(protocol: Scheme; host: string; base: string;
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

proc validate_RunsGetChild_564316(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Get details of all child runs for the specified Run Id with the specified filters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   runId: JString (required)
  ##        : The identifier of the Run.
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
  var valid_564319 = path.getOrDefault("runId")
  valid_564319 = validateParameter(valid_564319, JString, required = true,
                                 default = nil)
  if valid_564319 != nil:
    section.add "runId", valid_564319
  var valid_564320 = path.getOrDefault("subscriptionId")
  valid_564320 = validateParameter(valid_564320, JString, required = true,
                                 default = nil)
  if valid_564320 != nil:
    section.add "subscriptionId", valid_564320
  var valid_564321 = path.getOrDefault("experimentName")
  valid_564321 = validateParameter(valid_564321, JString, required = true,
                                 default = nil)
  if valid_564321 != nil:
    section.add "experimentName", valid_564321
  var valid_564322 = path.getOrDefault("resourceGroupName")
  valid_564322 = validateParameter(valid_564322, JString, required = true,
                                 default = nil)
  if valid_564322 != nil:
    section.add "resourceGroupName", valid_564322
  var valid_564323 = path.getOrDefault("workspaceName")
  valid_564323 = validateParameter(valid_564323, JString, required = true,
                                 default = nil)
  if valid_564323 != nil:
    section.add "workspaceName", valid_564323
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : The maximum number of items in the resource collection to be included in the result.
  ## If not specified, all items are returned.
  ##   $count: JBool
  ##         : Whether to include a count of the matching resources along with the resources returned in the response.
  ##   $sortorder: JString
  ##             : The sort order of the returned resources. Not used, specify asc or desc after each property name in the OrderBy parameter.
  ##   $orderby: JArray
  ##           : The list of resource properties to use for sorting the requested resources.
  ##   $filter: JString
  ##          : Allows for filtering the collection of resources.
  ## The expression specified is evaluated for each resource in the collection, and only items where the expression evaluates to true are included in the response.
  ##   $continuationtoken: JString
  ##                     : The continuation token to use for getting the next set of resources.
  section = newJObject()
  var valid_564324 = query.getOrDefault("$top")
  valid_564324 = validateParameter(valid_564324, JInt, required = false, default = nil)
  if valid_564324 != nil:
    section.add "$top", valid_564324
  var valid_564325 = query.getOrDefault("$count")
  valid_564325 = validateParameter(valid_564325, JBool, required = false, default = nil)
  if valid_564325 != nil:
    section.add "$count", valid_564325
  var valid_564326 = query.getOrDefault("$sortorder")
  valid_564326 = validateParameter(valid_564326, JString, required = false,
                                 default = newJString("Asc"))
  if valid_564326 != nil:
    section.add "$sortorder", valid_564326
  var valid_564327 = query.getOrDefault("$orderby")
  valid_564327 = validateParameter(valid_564327, JArray, required = false,
                                 default = nil)
  if valid_564327 != nil:
    section.add "$orderby", valid_564327
  var valid_564328 = query.getOrDefault("$filter")
  valid_564328 = validateParameter(valid_564328, JString, required = false,
                                 default = nil)
  if valid_564328 != nil:
    section.add "$filter", valid_564328
  var valid_564329 = query.getOrDefault("$continuationtoken")
  valid_564329 = validateParameter(valid_564329, JString, required = false,
                                 default = nil)
  if valid_564329 != nil:
    section.add "$continuationtoken", valid_564329
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564330: Call_RunsGetChild_564315; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get details of all child runs for the specified Run Id with the specified filters.
  ## 
  let valid = call_564330.validator(path, query, header, formData, body)
  let scheme = call_564330.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564330.url(scheme.get, call_564330.host, call_564330.base,
                         call_564330.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564330, url, valid)

proc call*(call_564331: Call_RunsGetChild_564315; runId: string;
          subscriptionId: string; experimentName: string; resourceGroupName: string;
          workspaceName: string; Top: int = 0; Count: bool = false;
          Sortorder: string = "Asc"; Orderby: JsonNode = nil; Filter: string = "";
          Continuationtoken: string = ""): Recallable =
  ## runsGetChild
  ## Get details of all child runs for the specified Run Id with the specified filters.
  ##   runId: string (required)
  ##        : The identifier of the Run.
  ##   Top: int
  ##      : The maximum number of items in the resource collection to be included in the result.
  ## If not specified, all items are returned.
  ##   Count: bool
  ##        : Whether to include a count of the matching resources along with the resources returned in the response.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   experimentName: string (required)
  ##                 : The experiment name.
  ##   Sortorder: string
  ##            : The sort order of the returned resources. Not used, specify asc or desc after each property name in the OrderBy parameter.
  ##   Orderby: JArray
  ##          : The list of resource properties to use for sorting the requested resources.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   Filter: string
  ##         : Allows for filtering the collection of resources.
  ## The expression specified is evaluated for each resource in the collection, and only items where the expression evaluates to true are included in the response.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   Continuationtoken: string
  ##                    : The continuation token to use for getting the next set of resources.
  var path_564332 = newJObject()
  var query_564333 = newJObject()
  add(path_564332, "runId", newJString(runId))
  add(query_564333, "$top", newJInt(Top))
  add(query_564333, "$count", newJBool(Count))
  add(path_564332, "subscriptionId", newJString(subscriptionId))
  add(path_564332, "experimentName", newJString(experimentName))
  add(query_564333, "$sortorder", newJString(Sortorder))
  if Orderby != nil:
    query_564333.add "$orderby", Orderby
  add(path_564332, "resourceGroupName", newJString(resourceGroupName))
  add(query_564333, "$filter", newJString(Filter))
  add(path_564332, "workspaceName", newJString(workspaceName))
  add(query_564333, "$continuationtoken", newJString(Continuationtoken))
  result = call_564331.call(path_564332, query_564333, nil, nil, nil)

var runsGetChild* = Call_RunsGetChild_564315(name: "runsGetChild",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/history/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/experiments/{experimentName}/runs/{runId}/children",
    validator: validate_RunsGetChild_564316, base: "", url: url_RunsGetChild_564317,
    schemes: {Scheme.Https})
type
  Call_RunsGetDetails_564334 = ref object of OpenApiRestCall_563539
proc url_RunsGetDetails_564336(protocol: Scheme; host: string; base: string;
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

proc validate_RunsGetDetails_564335(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Get Run Details for a specific Run Id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   runId: JString (required)
  ##        : The identifier of the Run.
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
  var valid_564337 = path.getOrDefault("runId")
  valid_564337 = validateParameter(valid_564337, JString, required = true,
                                 default = nil)
  if valid_564337 != nil:
    section.add "runId", valid_564337
  var valid_564338 = path.getOrDefault("subscriptionId")
  valid_564338 = validateParameter(valid_564338, JString, required = true,
                                 default = nil)
  if valid_564338 != nil:
    section.add "subscriptionId", valid_564338
  var valid_564339 = path.getOrDefault("experimentName")
  valid_564339 = validateParameter(valid_564339, JString, required = true,
                                 default = nil)
  if valid_564339 != nil:
    section.add "experimentName", valid_564339
  var valid_564340 = path.getOrDefault("resourceGroupName")
  valid_564340 = validateParameter(valid_564340, JString, required = true,
                                 default = nil)
  if valid_564340 != nil:
    section.add "resourceGroupName", valid_564340
  var valid_564341 = path.getOrDefault("workspaceName")
  valid_564341 = validateParameter(valid_564341, JString, required = true,
                                 default = nil)
  if valid_564341 != nil:
    section.add "workspaceName", valid_564341
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564342: Call_RunsGetDetails_564334; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get Run Details for a specific Run Id.
  ## 
  let valid = call_564342.validator(path, query, header, formData, body)
  let scheme = call_564342.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564342.url(scheme.get, call_564342.host, call_564342.base,
                         call_564342.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564342, url, valid)

proc call*(call_564343: Call_RunsGetDetails_564334; runId: string;
          subscriptionId: string; experimentName: string; resourceGroupName: string;
          workspaceName: string): Recallable =
  ## runsGetDetails
  ## Get Run Details for a specific Run Id.
  ##   runId: string (required)
  ##        : The identifier of the Run.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   experimentName: string (required)
  ##                 : The experiment name.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_564344 = newJObject()
  add(path_564344, "runId", newJString(runId))
  add(path_564344, "subscriptionId", newJString(subscriptionId))
  add(path_564344, "experimentName", newJString(experimentName))
  add(path_564344, "resourceGroupName", newJString(resourceGroupName))
  add(path_564344, "workspaceName", newJString(workspaceName))
  result = call_564343.call(path_564344, nil, nil, nil, nil)

var runsGetDetails* = Call_RunsGetDetails_564334(name: "runsGetDetails",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/history/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/experiments/{experimentName}/runs/{runId}/details",
    validator: validate_RunsGetDetails_564335, base: "", url: url_RunsGetDetails_564336,
    schemes: {Scheme.Https})
type
  Call_EventsPost_564345 = ref object of OpenApiRestCall_563539
proc url_EventsPost_564347(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_EventsPost_564346(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Post event data to a specific Run Id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   runId: JString (required)
  ##        : The identifier of the Run.
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
  var valid_564348 = path.getOrDefault("runId")
  valid_564348 = validateParameter(valid_564348, JString, required = true,
                                 default = nil)
  if valid_564348 != nil:
    section.add "runId", valid_564348
  var valid_564349 = path.getOrDefault("subscriptionId")
  valid_564349 = validateParameter(valid_564349, JString, required = true,
                                 default = nil)
  if valid_564349 != nil:
    section.add "subscriptionId", valid_564349
  var valid_564350 = path.getOrDefault("experimentName")
  valid_564350 = validateParameter(valid_564350, JString, required = true,
                                 default = nil)
  if valid_564350 != nil:
    section.add "experimentName", valid_564350
  var valid_564351 = path.getOrDefault("resourceGroupName")
  valid_564351 = validateParameter(valid_564351, JString, required = true,
                                 default = nil)
  if valid_564351 != nil:
    section.add "resourceGroupName", valid_564351
  var valid_564352 = path.getOrDefault("workspaceName")
  valid_564352 = validateParameter(valid_564352, JString, required = true,
                                 default = nil)
  if valid_564352 != nil:
    section.add "workspaceName", valid_564352
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

proc call*(call_564354: Call_EventsPost_564345; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Post event data to a specific Run Id.
  ## 
  let valid = call_564354.validator(path, query, header, formData, body)
  let scheme = call_564354.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564354.url(scheme.get, call_564354.host, call_564354.base,
                         call_564354.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564354, url, valid)

proc call*(call_564355: Call_EventsPost_564345; runId: string;
          subscriptionId: string; experimentName: string; resourceGroupName: string;
          workspaceName: string; eventMessage: JsonNode = nil): Recallable =
  ## eventsPost
  ## Post event data to a specific Run Id.
  ##   runId: string (required)
  ##        : The identifier of the Run.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   experimentName: string (required)
  ##                 : The experiment name.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   eventMessage: JObject
  ##               : The Event details.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_564356 = newJObject()
  var body_564357 = newJObject()
  add(path_564356, "runId", newJString(runId))
  add(path_564356, "subscriptionId", newJString(subscriptionId))
  add(path_564356, "experimentName", newJString(experimentName))
  add(path_564356, "resourceGroupName", newJString(resourceGroupName))
  if eventMessage != nil:
    body_564357 = eventMessage
  add(path_564356, "workspaceName", newJString(workspaceName))
  result = call_564355.call(path_564356, nil, nil, nil, body_564357)

var eventsPost* = Call_EventsPost_564345(name: "eventsPost",
                                      meth: HttpMethod.HttpPost,
                                      host: "azure.local", route: "/history/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/experiments/{experimentName}/runs/{runId}/events",
                                      validator: validate_EventsPost_564346,
                                      base: "", url: url_EventsPost_564347,
                                      schemes: {Scheme.Https})
type
  Call_RunMetricsPost_564358 = ref object of OpenApiRestCall_563539
proc url_RunMetricsPost_564360(protocol: Scheme; host: string; base: string;
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

proc validate_RunMetricsPost_564359(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Post a Metric to a specific Run Id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   runId: JString (required)
  ##        : The identifier for a run.
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
  var valid_564361 = path.getOrDefault("runId")
  valid_564361 = validateParameter(valid_564361, JString, required = true,
                                 default = nil)
  if valid_564361 != nil:
    section.add "runId", valid_564361
  var valid_564362 = path.getOrDefault("subscriptionId")
  valid_564362 = validateParameter(valid_564362, JString, required = true,
                                 default = nil)
  if valid_564362 != nil:
    section.add "subscriptionId", valid_564362
  var valid_564363 = path.getOrDefault("experimentName")
  valid_564363 = validateParameter(valid_564363, JString, required = true,
                                 default = nil)
  if valid_564363 != nil:
    section.add "experimentName", valid_564363
  var valid_564364 = path.getOrDefault("resourceGroupName")
  valid_564364 = validateParameter(valid_564364, JString, required = true,
                                 default = nil)
  if valid_564364 != nil:
    section.add "resourceGroupName", valid_564364
  var valid_564365 = path.getOrDefault("workspaceName")
  valid_564365 = validateParameter(valid_564365, JString, required = true,
                                 default = nil)
  if valid_564365 != nil:
    section.add "workspaceName", valid_564365
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

proc call*(call_564367: Call_RunMetricsPost_564358; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Post a Metric to a specific Run Id.
  ## 
  let valid = call_564367.validator(path, query, header, formData, body)
  let scheme = call_564367.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564367.url(scheme.get, call_564367.host, call_564367.base,
                         call_564367.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564367, url, valid)

proc call*(call_564368: Call_RunMetricsPost_564358; runId: string;
          subscriptionId: string; experimentName: string; resourceGroupName: string;
          workspaceName: string; metricDto: JsonNode = nil): Recallable =
  ## runMetricsPost
  ## Post a Metric to a specific Run Id.
  ##   runId: string (required)
  ##        : The identifier for a run.
  ##   metricDto: JObject
  ##            : Details of the metric which will be added to the Run Id.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   experimentName: string (required)
  ##                 : The experiment name.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_564369 = newJObject()
  var body_564370 = newJObject()
  add(path_564369, "runId", newJString(runId))
  if metricDto != nil:
    body_564370 = metricDto
  add(path_564369, "subscriptionId", newJString(subscriptionId))
  add(path_564369, "experimentName", newJString(experimentName))
  add(path_564369, "resourceGroupName", newJString(resourceGroupName))
  add(path_564369, "workspaceName", newJString(workspaceName))
  result = call_564368.call(path_564369, nil, nil, nil, body_564370)

var runMetricsPost* = Call_RunMetricsPost_564358(name: "runMetricsPost",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/history/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/experiments/{experimentName}/runs/{runId}/metrics",
    validator: validate_RunMetricsPost_564359, base: "", url: url_RunMetricsPost_564360,
    schemes: {Scheme.Https})
type
  Call_RunsDeleteTags_564371 = ref object of OpenApiRestCall_563539
proc url_RunsDeleteTags_564373(protocol: Scheme; host: string; base: string;
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

proc validate_RunsDeleteTags_564372(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Delete list of Tags from a specific Run Id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   runId: JString (required)
  ##        : The identifier of the Run.
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
  var valid_564374 = path.getOrDefault("runId")
  valid_564374 = validateParameter(valid_564374, JString, required = true,
                                 default = nil)
  if valid_564374 != nil:
    section.add "runId", valid_564374
  var valid_564375 = path.getOrDefault("subscriptionId")
  valid_564375 = validateParameter(valid_564375, JString, required = true,
                                 default = nil)
  if valid_564375 != nil:
    section.add "subscriptionId", valid_564375
  var valid_564376 = path.getOrDefault("experimentName")
  valid_564376 = validateParameter(valid_564376, JString, required = true,
                                 default = nil)
  if valid_564376 != nil:
    section.add "experimentName", valid_564376
  var valid_564377 = path.getOrDefault("resourceGroupName")
  valid_564377 = validateParameter(valid_564377, JString, required = true,
                                 default = nil)
  if valid_564377 != nil:
    section.add "resourceGroupName", valid_564377
  var valid_564378 = path.getOrDefault("workspaceName")
  valid_564378 = validateParameter(valid_564378, JString, required = true,
                                 default = nil)
  if valid_564378 != nil:
    section.add "workspaceName", valid_564378
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

proc call*(call_564380: Call_RunsDeleteTags_564371; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete list of Tags from a specific Run Id.
  ## 
  let valid = call_564380.validator(path, query, header, formData, body)
  let scheme = call_564380.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564380.url(scheme.get, call_564380.host, call_564380.base,
                         call_564380.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564380, url, valid)

proc call*(call_564381: Call_RunsDeleteTags_564371; runId: string;
          subscriptionId: string; experimentName: string; resourceGroupName: string;
          workspaceName: string; tags: JsonNode = nil): Recallable =
  ## runsDeleteTags
  ## Delete list of Tags from a specific Run Id.
  ##   runId: string (required)
  ##        : The identifier of the Run.
  ##   tags: JArray
  ##       : The requested tags list to be deleted.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   experimentName: string (required)
  ##                 : The experiment name.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_564382 = newJObject()
  var body_564383 = newJObject()
  add(path_564382, "runId", newJString(runId))
  if tags != nil:
    body_564383 = tags
  add(path_564382, "subscriptionId", newJString(subscriptionId))
  add(path_564382, "experimentName", newJString(experimentName))
  add(path_564382, "resourceGroupName", newJString(resourceGroupName))
  add(path_564382, "workspaceName", newJString(workspaceName))
  result = call_564381.call(path_564382, nil, nil, nil, body_564383)

var runsDeleteTags* = Call_RunsDeleteTags_564371(name: "runsDeleteTags",
    meth: HttpMethod.HttpDelete, host: "azure.local", route: "/history/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/experiments/{experimentName}/runs/{runId}/tags",
    validator: validate_RunsDeleteTags_564372, base: "", url: url_RunsDeleteTags_564373,
    schemes: {Scheme.Https})
type
  Call_RunsGetByQuery_564384 = ref object of OpenApiRestCall_563539
proc url_RunsGetByQuery_564386(protocol: Scheme; host: string; base: string;
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

proc validate_RunsGetByQuery_564385(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Get all Runs for a specific Experiment with the specified query filters.
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
  var valid_564387 = path.getOrDefault("subscriptionId")
  valid_564387 = validateParameter(valid_564387, JString, required = true,
                                 default = nil)
  if valid_564387 != nil:
    section.add "subscriptionId", valid_564387
  var valid_564388 = path.getOrDefault("experimentName")
  valid_564388 = validateParameter(valid_564388, JString, required = true,
                                 default = nil)
  if valid_564388 != nil:
    section.add "experimentName", valid_564388
  var valid_564389 = path.getOrDefault("resourceGroupName")
  valid_564389 = validateParameter(valid_564389, JString, required = true,
                                 default = nil)
  if valid_564389 != nil:
    section.add "resourceGroupName", valid_564389
  var valid_564390 = path.getOrDefault("workspaceName")
  valid_564390 = validateParameter(valid_564390, JString, required = true,
                                 default = nil)
  if valid_564390 != nil:
    section.add "workspaceName", valid_564390
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

proc call*(call_564392: Call_RunsGetByQuery_564384; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all Runs for a specific Experiment with the specified query filters.
  ## 
  let valid = call_564392.validator(path, query, header, formData, body)
  let scheme = call_564392.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564392.url(scheme.get, call_564392.host, call_564392.base,
                         call_564392.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564392, url, valid)

proc call*(call_564393: Call_RunsGetByQuery_564384; subscriptionId: string;
          experimentName: string; resourceGroupName: string; workspaceName: string;
          queryParams: JsonNode = nil): Recallable =
  ## runsGetByQuery
  ## Get all Runs for a specific Experiment with the specified query filters.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   experimentName: string (required)
  ##                 : The experiment name.
  ##   queryParams: JObject
  ##              : Query parameters for data sorting and filtering.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_564394 = newJObject()
  var body_564395 = newJObject()
  add(path_564394, "subscriptionId", newJString(subscriptionId))
  add(path_564394, "experimentName", newJString(experimentName))
  if queryParams != nil:
    body_564395 = queryParams
  add(path_564394, "resourceGroupName", newJString(resourceGroupName))
  add(path_564394, "workspaceName", newJString(workspaceName))
  result = call_564393.call(path_564394, nil, nil, nil, body_564395)

var runsGetByQuery* = Call_RunsGetByQuery_564384(name: "runsGetByQuery",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/history/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/experiments/{experimentName}/runs:query",
    validator: validate_RunsGetByQuery_564385, base: "", url: url_RunsGetByQuery_564386,
    schemes: {Scheme.Https})
type
  Call_ExperimentsGetByQuery_564396 = ref object of OpenApiRestCall_563539
proc url_ExperimentsGetByQuery_564398(protocol: Scheme; host: string; base: string;
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

proc validate_ExperimentsGetByQuery_564397(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get all experiments in a specific workspace with the specified query filters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564399 = path.getOrDefault("subscriptionId")
  valid_564399 = validateParameter(valid_564399, JString, required = true,
                                 default = nil)
  if valid_564399 != nil:
    section.add "subscriptionId", valid_564399
  var valid_564400 = path.getOrDefault("resourceGroupName")
  valid_564400 = validateParameter(valid_564400, JString, required = true,
                                 default = nil)
  if valid_564400 != nil:
    section.add "resourceGroupName", valid_564400
  var valid_564401 = path.getOrDefault("workspaceName")
  valid_564401 = validateParameter(valid_564401, JString, required = true,
                                 default = nil)
  if valid_564401 != nil:
    section.add "workspaceName", valid_564401
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

proc call*(call_564403: Call_ExperimentsGetByQuery_564396; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all experiments in a specific workspace with the specified query filters.
  ## 
  let valid = call_564403.validator(path, query, header, formData, body)
  let scheme = call_564403.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564403.url(scheme.get, call_564403.host, call_564403.base,
                         call_564403.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564403, url, valid)

proc call*(call_564404: Call_ExperimentsGetByQuery_564396; subscriptionId: string;
          resourceGroupName: string; workspaceName: string;
          queryParams: JsonNode = nil): Recallable =
  ## experimentsGetByQuery
  ## Get all experiments in a specific workspace with the specified query filters.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   queryParams: JObject
  ##              : Query parameters for data sorting and filtering.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_564405 = newJObject()
  var body_564406 = newJObject()
  add(path_564405, "subscriptionId", newJString(subscriptionId))
  if queryParams != nil:
    body_564406 = queryParams
  add(path_564405, "resourceGroupName", newJString(resourceGroupName))
  add(path_564405, "workspaceName", newJString(workspaceName))
  result = call_564404.call(path_564405, nil, nil, nil, body_564406)

var experimentsGetByQuery* = Call_ExperimentsGetByQuery_564396(
    name: "experimentsGetByQuery", meth: HttpMethod.HttpPost, host: "azure.local", route: "/history/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/experiments:query",
    validator: validate_ExperimentsGetByQuery_564397, base: "",
    url: url_ExperimentsGetByQuery_564398, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
