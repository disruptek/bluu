
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: Artifact
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
  macServiceName = "machinelearningservices-artifact"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ArtifactsBatchGetById_563761 = ref object of OpenApiRestCall_563539
proc url_ArtifactsBatchGetById_563763(protocol: Scheme; host: string; base: string;
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
    segments = @[(kind: ConstantSegment, value: "/artifact/v2.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/artifacts/batch/metadata")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ArtifactsBatchGetById_563762(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get Batch Artifacts by the specific Ids.
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
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   artifactIds: JObject (required)
  ##              : The command for Batch Artifact get request.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_563964: Call_ArtifactsBatchGetById_563761; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get Batch Artifacts by the specific Ids.
  ## 
  let valid = call_563964.validator(path, query, header, formData, body)
  let scheme = call_563964.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563964.url(scheme.get, call_563964.host, call_563964.base,
                         call_563964.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563964, url, valid)

proc call*(call_564035: Call_ArtifactsBatchGetById_563761; subscriptionId: string;
          artifactIds: JsonNode; resourceGroupName: string; workspaceName: string): Recallable =
  ## artifactsBatchGetById
  ## Get Batch Artifacts by the specific Ids.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   artifactIds: JObject (required)
  ##              : The command for Batch Artifact get request.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_564036 = newJObject()
  var body_564038 = newJObject()
  add(path_564036, "subscriptionId", newJString(subscriptionId))
  if artifactIds != nil:
    body_564038 = artifactIds
  add(path_564036, "resourceGroupName", newJString(resourceGroupName))
  add(path_564036, "workspaceName", newJString(workspaceName))
  result = call_564035.call(path_564036, nil, nil, nil, body_564038)

var artifactsBatchGetById* = Call_ArtifactsBatchGetById_563761(
    name: "artifactsBatchGetById", meth: HttpMethod.HttpPost, host: "azure.local", route: "/artifact/v2.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/artifacts/batch/metadata",
    validator: validate_ArtifactsBatchGetById_563762, base: "",
    url: url_ArtifactsBatchGetById_563763, schemes: {Scheme.Https})
type
  Call_ArtifactsCreate_564077 = ref object of OpenApiRestCall_563539
proc url_ArtifactsCreate_564079(protocol: Scheme; host: string; base: string;
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
    segments = @[(kind: ConstantSegment, value: "/artifact/v2.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/artifacts/metadata")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ArtifactsCreate_564078(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Create an Artifact.
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
  var valid_564080 = path.getOrDefault("subscriptionId")
  valid_564080 = validateParameter(valid_564080, JString, required = true,
                                 default = nil)
  if valid_564080 != nil:
    section.add "subscriptionId", valid_564080
  var valid_564081 = path.getOrDefault("resourceGroupName")
  valid_564081 = validateParameter(valid_564081, JString, required = true,
                                 default = nil)
  if valid_564081 != nil:
    section.add "resourceGroupName", valid_564081
  var valid_564082 = path.getOrDefault("workspaceName")
  valid_564082 = validateParameter(valid_564082, JString, required = true,
                                 default = nil)
  if valid_564082 != nil:
    section.add "workspaceName", valid_564082
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   artifact: JObject (required)
  ##           : The Artifact details.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564084: Call_ArtifactsCreate_564077; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create an Artifact.
  ## 
  let valid = call_564084.validator(path, query, header, formData, body)
  let scheme = call_564084.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564084.url(scheme.get, call_564084.host, call_564084.base,
                         call_564084.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564084, url, valid)

proc call*(call_564085: Call_ArtifactsCreate_564077; artifact: JsonNode;
          subscriptionId: string; resourceGroupName: string; workspaceName: string): Recallable =
  ## artifactsCreate
  ## Create an Artifact.
  ##   artifact: JObject (required)
  ##           : The Artifact details.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_564086 = newJObject()
  var body_564087 = newJObject()
  if artifact != nil:
    body_564087 = artifact
  add(path_564086, "subscriptionId", newJString(subscriptionId))
  add(path_564086, "resourceGroupName", newJString(resourceGroupName))
  add(path_564086, "workspaceName", newJString(workspaceName))
  result = call_564085.call(path_564086, nil, nil, nil, body_564087)

var artifactsCreate* = Call_ArtifactsCreate_564077(name: "artifactsCreate",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/artifact/v2.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/artifacts/metadata",
    validator: validate_ArtifactsCreate_564078, base: "", url: url_ArtifactsCreate_564079,
    schemes: {Scheme.Https})
type
  Call_ArtifactsRegister_564088 = ref object of OpenApiRestCall_563539
proc url_ArtifactsRegister_564090(protocol: Scheme; host: string; base: string;
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
    segments = @[(kind: ConstantSegment, value: "/artifact/v2.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/artifacts/register")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ArtifactsRegister_564089(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Create an Artifact for an existing dataPath.
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
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   artifact: JObject (required)
  ##           : The Artifact creation details.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564095: Call_ArtifactsRegister_564088; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create an Artifact for an existing dataPath.
  ## 
  let valid = call_564095.validator(path, query, header, formData, body)
  let scheme = call_564095.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564095.url(scheme.get, call_564095.host, call_564095.base,
                         call_564095.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564095, url, valid)

proc call*(call_564096: Call_ArtifactsRegister_564088; artifact: JsonNode;
          subscriptionId: string; resourceGroupName: string; workspaceName: string): Recallable =
  ## artifactsRegister
  ## Create an Artifact for an existing dataPath.
  ##   artifact: JObject (required)
  ##           : The Artifact creation details.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_564097 = newJObject()
  var body_564098 = newJObject()
  if artifact != nil:
    body_564098 = artifact
  add(path_564097, "subscriptionId", newJString(subscriptionId))
  add(path_564097, "resourceGroupName", newJString(resourceGroupName))
  add(path_564097, "workspaceName", newJString(workspaceName))
  result = call_564096.call(path_564097, nil, nil, nil, body_564098)

var artifactsRegister* = Call_ArtifactsRegister_564088(name: "artifactsRegister",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/artifact/v2.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/artifacts/register",
    validator: validate_ArtifactsRegister_564089, base: "",
    url: url_ArtifactsRegister_564090, schemes: {Scheme.Https})
type
  Call_ArtifactsBatchGetStorageById_564099 = ref object of OpenApiRestCall_563539
proc url_ArtifactsBatchGetStorageById_564101(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/artifact/v2.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment, value: "/artifacts/storageuri/batch/metadata")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ArtifactsBatchGetStorageById_564100(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get Batch Artifacts storage by specific Ids.
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
  var valid_564102 = path.getOrDefault("subscriptionId")
  valid_564102 = validateParameter(valid_564102, JString, required = true,
                                 default = nil)
  if valid_564102 != nil:
    section.add "subscriptionId", valid_564102
  var valid_564103 = path.getOrDefault("resourceGroupName")
  valid_564103 = validateParameter(valid_564103, JString, required = true,
                                 default = nil)
  if valid_564103 != nil:
    section.add "resourceGroupName", valid_564103
  var valid_564104 = path.getOrDefault("workspaceName")
  valid_564104 = validateParameter(valid_564104, JString, required = true,
                                 default = nil)
  if valid_564104 != nil:
    section.add "workspaceName", valid_564104
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   artifactIds: JObject (required)
  ##              : The list of artifactIds to get.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564106: Call_ArtifactsBatchGetStorageById_564099; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get Batch Artifacts storage by specific Ids.
  ## 
  let valid = call_564106.validator(path, query, header, formData, body)
  let scheme = call_564106.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564106.url(scheme.get, call_564106.host, call_564106.base,
                         call_564106.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564106, url, valid)

proc call*(call_564107: Call_ArtifactsBatchGetStorageById_564099;
          subscriptionId: string; artifactIds: JsonNode; resourceGroupName: string;
          workspaceName: string): Recallable =
  ## artifactsBatchGetStorageById
  ## Get Batch Artifacts storage by specific Ids.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   artifactIds: JObject (required)
  ##              : The list of artifactIds to get.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_564108 = newJObject()
  var body_564109 = newJObject()
  add(path_564108, "subscriptionId", newJString(subscriptionId))
  if artifactIds != nil:
    body_564109 = artifactIds
  add(path_564108, "resourceGroupName", newJString(resourceGroupName))
  add(path_564108, "workspaceName", newJString(workspaceName))
  result = call_564107.call(path_564108, nil, nil, nil, body_564109)

var artifactsBatchGetStorageById* = Call_ArtifactsBatchGetStorageById_564099(
    name: "artifactsBatchGetStorageById", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/artifact/v2.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/artifacts/storageuri/batch/metadata",
    validator: validate_ArtifactsBatchGetStorageById_564100, base: "",
    url: url_ArtifactsBatchGetStorageById_564101, schemes: {Scheme.Https})
type
  Call_ArtifactsListInContainer_564110 = ref object of OpenApiRestCall_563539
proc url_ArtifactsListInContainer_564112(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "origin" in path, "`origin` is a required path parameter"
  assert "container" in path, "`container` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/artifact/v2.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/artifacts/"),
               (kind: VariableSegment, value: "origin"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "container")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ArtifactsListInContainer_564111(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get Artifacts metadata in a specific container or path.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   origin: JString (required)
  ##         : The origin of the Artifact.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   container: JString (required)
  ##            : The container name.
  ##   resourceGroupName: JString (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `origin` field"
  var valid_564113 = path.getOrDefault("origin")
  valid_564113 = validateParameter(valid_564113, JString, required = true,
                                 default = nil)
  if valid_564113 != nil:
    section.add "origin", valid_564113
  var valid_564114 = path.getOrDefault("subscriptionId")
  valid_564114 = validateParameter(valid_564114, JString, required = true,
                                 default = nil)
  if valid_564114 != nil:
    section.add "subscriptionId", valid_564114
  var valid_564115 = path.getOrDefault("container")
  valid_564115 = validateParameter(valid_564115, JString, required = true,
                                 default = nil)
  if valid_564115 != nil:
    section.add "container", valid_564115
  var valid_564116 = path.getOrDefault("resourceGroupName")
  valid_564116 = validateParameter(valid_564116, JString, required = true,
                                 default = nil)
  if valid_564116 != nil:
    section.add "resourceGroupName", valid_564116
  var valid_564117 = path.getOrDefault("workspaceName")
  valid_564117 = validateParameter(valid_564117, JString, required = true,
                                 default = nil)
  if valid_564117 != nil:
    section.add "workspaceName", valid_564117
  result.add "path", section
  ## parameters in `query` object:
  ##   path: JString
  ##       : The Artifact Path.
  ##   continuationToken: JString
  ##                    : The continuation token.
  section = newJObject()
  var valid_564118 = query.getOrDefault("path")
  valid_564118 = validateParameter(valid_564118, JString, required = false,
                                 default = nil)
  if valid_564118 != nil:
    section.add "path", valid_564118
  var valid_564119 = query.getOrDefault("continuationToken")
  valid_564119 = validateParameter(valid_564119, JString, required = false,
                                 default = nil)
  if valid_564119 != nil:
    section.add "continuationToken", valid_564119
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564120: Call_ArtifactsListInContainer_564110; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get Artifacts metadata in a specific container or path.
  ## 
  let valid = call_564120.validator(path, query, header, formData, body)
  let scheme = call_564120.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564120.url(scheme.get, call_564120.host, call_564120.base,
                         call_564120.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564120, url, valid)

proc call*(call_564121: Call_ArtifactsListInContainer_564110; origin: string;
          subscriptionId: string; container: string; resourceGroupName: string;
          workspaceName: string; path: string = ""; continuationToken: string = ""): Recallable =
  ## artifactsListInContainer
  ## Get Artifacts metadata in a specific container or path.
  ##   origin: string (required)
  ##         : The origin of the Artifact.
  ##   path: string
  ##       : The Artifact Path.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   continuationToken: string
  ##                    : The continuation token.
  ##   container: string (required)
  ##            : The container name.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_564122 = newJObject()
  var query_564123 = newJObject()
  add(path_564122, "origin", newJString(origin))
  add(query_564123, "path", newJString(path))
  add(path_564122, "subscriptionId", newJString(subscriptionId))
  add(query_564123, "continuationToken", newJString(continuationToken))
  add(path_564122, "container", newJString(container))
  add(path_564122, "resourceGroupName", newJString(resourceGroupName))
  add(path_564122, "workspaceName", newJString(workspaceName))
  result = call_564121.call(path_564122, query_564123, nil, nil, nil)

var artifactsListInContainer* = Call_ArtifactsListInContainer_564110(
    name: "artifactsListInContainer", meth: HttpMethod.HttpGet, host: "azure.local", route: "/artifact/v2.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/artifacts/{origin}/{container}",
    validator: validate_ArtifactsListInContainer_564111, base: "",
    url: url_ArtifactsListInContainer_564112, schemes: {Scheme.Https})
type
  Call_ArtifactsDeleteMetaDataInContainer_564124 = ref object of OpenApiRestCall_563539
proc url_ArtifactsDeleteMetaDataInContainer_564126(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "origin" in path, "`origin` is a required path parameter"
  assert "container" in path, "`container` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/artifact/v2.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/artifacts/"),
               (kind: VariableSegment, value: "origin"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "container"),
               (kind: ConstantSegment, value: "/batch")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ArtifactsDeleteMetaDataInContainer_564125(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete Artifact Metadata in a specific container.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   origin: JString (required)
  ##         : The origin of the Artifact.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   container: JString (required)
  ##            : The container name.
  ##   resourceGroupName: JString (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `origin` field"
  var valid_564127 = path.getOrDefault("origin")
  valid_564127 = validateParameter(valid_564127, JString, required = true,
                                 default = nil)
  if valid_564127 != nil:
    section.add "origin", valid_564127
  var valid_564128 = path.getOrDefault("subscriptionId")
  valid_564128 = validateParameter(valid_564128, JString, required = true,
                                 default = nil)
  if valid_564128 != nil:
    section.add "subscriptionId", valid_564128
  var valid_564129 = path.getOrDefault("container")
  valid_564129 = validateParameter(valid_564129, JString, required = true,
                                 default = nil)
  if valid_564129 != nil:
    section.add "container", valid_564129
  var valid_564130 = path.getOrDefault("resourceGroupName")
  valid_564130 = validateParameter(valid_564130, JString, required = true,
                                 default = nil)
  if valid_564130 != nil:
    section.add "resourceGroupName", valid_564130
  var valid_564131 = path.getOrDefault("workspaceName")
  valid_564131 = validateParameter(valid_564131, JString, required = true,
                                 default = nil)
  if valid_564131 != nil:
    section.add "workspaceName", valid_564131
  result.add "path", section
  ## parameters in `query` object:
  ##   hardDelete: JBool
  ##             : If set to true. The delete cannot be revert at later time.
  section = newJObject()
  var valid_564145 = query.getOrDefault("hardDelete")
  valid_564145 = validateParameter(valid_564145, JBool, required = false,
                                 default = newJBool(false))
  if valid_564145 != nil:
    section.add "hardDelete", valid_564145
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564146: Call_ArtifactsDeleteMetaDataInContainer_564124;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete Artifact Metadata in a specific container.
  ## 
  let valid = call_564146.validator(path, query, header, formData, body)
  let scheme = call_564146.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564146.url(scheme.get, call_564146.host, call_564146.base,
                         call_564146.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564146, url, valid)

proc call*(call_564147: Call_ArtifactsDeleteMetaDataInContainer_564124;
          origin: string; subscriptionId: string; container: string;
          resourceGroupName: string; workspaceName: string; hardDelete: bool = false): Recallable =
  ## artifactsDeleteMetaDataInContainer
  ## Delete Artifact Metadata in a specific container.
  ##   hardDelete: bool
  ##             : If set to true. The delete cannot be revert at later time.
  ##   origin: string (required)
  ##         : The origin of the Artifact.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   container: string (required)
  ##            : The container name.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_564148 = newJObject()
  var query_564149 = newJObject()
  add(query_564149, "hardDelete", newJBool(hardDelete))
  add(path_564148, "origin", newJString(origin))
  add(path_564148, "subscriptionId", newJString(subscriptionId))
  add(path_564148, "container", newJString(container))
  add(path_564148, "resourceGroupName", newJString(resourceGroupName))
  add(path_564148, "workspaceName", newJString(workspaceName))
  result = call_564147.call(path_564148, query_564149, nil, nil, nil)

var artifactsDeleteMetaDataInContainer* = Call_ArtifactsDeleteMetaDataInContainer_564124(
    name: "artifactsDeleteMetaDataInContainer", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/artifact/v2.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/artifacts/{origin}/{container}/batch",
    validator: validate_ArtifactsDeleteMetaDataInContainer_564125, base: "",
    url: url_ArtifactsDeleteMetaDataInContainer_564126, schemes: {Scheme.Https})
type
  Call_ArtifactsBatchIngestFromSas_564150 = ref object of OpenApiRestCall_563539
proc url_ArtifactsBatchIngestFromSas_564152(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "origin" in path, "`origin` is a required path parameter"
  assert "container" in path, "`container` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/artifact/v2.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/artifacts/"),
               (kind: VariableSegment, value: "origin"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "container"),
               (kind: ConstantSegment, value: "/batch/ingest/containersas")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ArtifactsBatchIngestFromSas_564151(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Ingest Batch Artifacts using shared access signature.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   origin: JString (required)
  ##         : The origin of the Artifact.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   container: JString (required)
  ##            : The container name.
  ##   resourceGroupName: JString (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `origin` field"
  var valid_564153 = path.getOrDefault("origin")
  valid_564153 = validateParameter(valid_564153, JString, required = true,
                                 default = nil)
  if valid_564153 != nil:
    section.add "origin", valid_564153
  var valid_564154 = path.getOrDefault("subscriptionId")
  valid_564154 = validateParameter(valid_564154, JString, required = true,
                                 default = nil)
  if valid_564154 != nil:
    section.add "subscriptionId", valid_564154
  var valid_564155 = path.getOrDefault("container")
  valid_564155 = validateParameter(valid_564155, JString, required = true,
                                 default = nil)
  if valid_564155 != nil:
    section.add "container", valid_564155
  var valid_564156 = path.getOrDefault("resourceGroupName")
  valid_564156 = validateParameter(valid_564156, JString, required = true,
                                 default = nil)
  if valid_564156 != nil:
    section.add "resourceGroupName", valid_564156
  var valid_564157 = path.getOrDefault("workspaceName")
  valid_564157 = validateParameter(valid_564157, JString, required = true,
                                 default = nil)
  if valid_564157 != nil:
    section.add "workspaceName", valid_564157
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   artifactContainerSas: JObject (required)
  ##                       : The artifact container shared access signature to use for batch ingest.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564159: Call_ArtifactsBatchIngestFromSas_564150; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Ingest Batch Artifacts using shared access signature.
  ## 
  let valid = call_564159.validator(path, query, header, formData, body)
  let scheme = call_564159.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564159.url(scheme.get, call_564159.host, call_564159.base,
                         call_564159.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564159, url, valid)

proc call*(call_564160: Call_ArtifactsBatchIngestFromSas_564150; origin: string;
          artifactContainerSas: JsonNode; subscriptionId: string; container: string;
          resourceGroupName: string; workspaceName: string): Recallable =
  ## artifactsBatchIngestFromSas
  ## Ingest Batch Artifacts using shared access signature.
  ##   origin: string (required)
  ##         : The origin of the Artifact.
  ##   artifactContainerSas: JObject (required)
  ##                       : The artifact container shared access signature to use for batch ingest.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   container: string (required)
  ##            : The container name.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_564161 = newJObject()
  var body_564162 = newJObject()
  add(path_564161, "origin", newJString(origin))
  if artifactContainerSas != nil:
    body_564162 = artifactContainerSas
  add(path_564161, "subscriptionId", newJString(subscriptionId))
  add(path_564161, "container", newJString(container))
  add(path_564161, "resourceGroupName", newJString(resourceGroupName))
  add(path_564161, "workspaceName", newJString(workspaceName))
  result = call_564160.call(path_564161, nil, nil, nil, body_564162)

var artifactsBatchIngestFromSas* = Call_ArtifactsBatchIngestFromSas_564150(
    name: "artifactsBatchIngestFromSas", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/artifact/v2.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/artifacts/{origin}/{container}/batch/ingest/containersas",
    validator: validate_ArtifactsBatchIngestFromSas_564151, base: "",
    url: url_ArtifactsBatchIngestFromSas_564152, schemes: {Scheme.Https})
type
  Call_ArtifactsBatchCreateEmptyArtifacts_564163 = ref object of OpenApiRestCall_563539
proc url_ArtifactsBatchCreateEmptyArtifacts_564165(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "origin" in path, "`origin` is a required path parameter"
  assert "container" in path, "`container` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/artifact/v2.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/artifacts/"),
               (kind: VariableSegment, value: "origin"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "container"),
               (kind: ConstantSegment, value: "/batch/metadata")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ArtifactsBatchCreateEmptyArtifacts_564164(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a Batch of empty Artifacts from the supplied paths.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   origin: JString (required)
  ##         : The origin of the Artifact.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   container: JString (required)
  ##            : The container name.
  ##   resourceGroupName: JString (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `origin` field"
  var valid_564166 = path.getOrDefault("origin")
  valid_564166 = validateParameter(valid_564166, JString, required = true,
                                 default = nil)
  if valid_564166 != nil:
    section.add "origin", valid_564166
  var valid_564167 = path.getOrDefault("subscriptionId")
  valid_564167 = validateParameter(valid_564167, JString, required = true,
                                 default = nil)
  if valid_564167 != nil:
    section.add "subscriptionId", valid_564167
  var valid_564168 = path.getOrDefault("container")
  valid_564168 = validateParameter(valid_564168, JString, required = true,
                                 default = nil)
  if valid_564168 != nil:
    section.add "container", valid_564168
  var valid_564169 = path.getOrDefault("resourceGroupName")
  valid_564169 = validateParameter(valid_564169, JString, required = true,
                                 default = nil)
  if valid_564169 != nil:
    section.add "resourceGroupName", valid_564169
  var valid_564170 = path.getOrDefault("workspaceName")
  valid_564170 = validateParameter(valid_564170, JString, required = true,
                                 default = nil)
  if valid_564170 != nil:
    section.add "workspaceName", valid_564170
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   artifactPaths: JObject (required)
  ##                : The list of Artifact paths to create.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564172: Call_ArtifactsBatchCreateEmptyArtifacts_564163;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a Batch of empty Artifacts from the supplied paths.
  ## 
  let valid = call_564172.validator(path, query, header, formData, body)
  let scheme = call_564172.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564172.url(scheme.get, call_564172.host, call_564172.base,
                         call_564172.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564172, url, valid)

proc call*(call_564173: Call_ArtifactsBatchCreateEmptyArtifacts_564163;
          origin: string; subscriptionId: string; container: string;
          resourceGroupName: string; artifactPaths: JsonNode; workspaceName: string): Recallable =
  ## artifactsBatchCreateEmptyArtifacts
  ## Create a Batch of empty Artifacts from the supplied paths.
  ##   origin: string (required)
  ##         : The origin of the Artifact.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   container: string (required)
  ##            : The container name.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   artifactPaths: JObject (required)
  ##                : The list of Artifact paths to create.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_564174 = newJObject()
  var body_564175 = newJObject()
  add(path_564174, "origin", newJString(origin))
  add(path_564174, "subscriptionId", newJString(subscriptionId))
  add(path_564174, "container", newJString(container))
  add(path_564174, "resourceGroupName", newJString(resourceGroupName))
  if artifactPaths != nil:
    body_564175 = artifactPaths
  add(path_564174, "workspaceName", newJString(workspaceName))
  result = call_564173.call(path_564174, nil, nil, nil, body_564175)

var artifactsBatchCreateEmptyArtifacts* = Call_ArtifactsBatchCreateEmptyArtifacts_564163(
    name: "artifactsBatchCreateEmptyArtifacts", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/artifact/v2.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/artifacts/{origin}/{container}/batch/metadata",
    validator: validate_ArtifactsBatchCreateEmptyArtifacts_564164, base: "",
    url: url_ArtifactsBatchCreateEmptyArtifacts_564165, schemes: {Scheme.Https})
type
  Call_ArtifactsDeleteBatchMetaData_564176 = ref object of OpenApiRestCall_563539
proc url_ArtifactsDeleteBatchMetaData_564178(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "origin" in path, "`origin` is a required path parameter"
  assert "container" in path, "`container` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/artifact/v2.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/artifacts/"),
               (kind: VariableSegment, value: "origin"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "container"),
               (kind: ConstantSegment, value: "/batch/metadata:delete")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ArtifactsDeleteBatchMetaData_564177(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a Batch of Artifact Metadata.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   origin: JString (required)
  ##         : The origin of the Artifact.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   container: JString (required)
  ##            : The container name.
  ##   resourceGroupName: JString (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `origin` field"
  var valid_564179 = path.getOrDefault("origin")
  valid_564179 = validateParameter(valid_564179, JString, required = true,
                                 default = nil)
  if valid_564179 != nil:
    section.add "origin", valid_564179
  var valid_564180 = path.getOrDefault("subscriptionId")
  valid_564180 = validateParameter(valid_564180, JString, required = true,
                                 default = nil)
  if valid_564180 != nil:
    section.add "subscriptionId", valid_564180
  var valid_564181 = path.getOrDefault("container")
  valid_564181 = validateParameter(valid_564181, JString, required = true,
                                 default = nil)
  if valid_564181 != nil:
    section.add "container", valid_564181
  var valid_564182 = path.getOrDefault("resourceGroupName")
  valid_564182 = validateParameter(valid_564182, JString, required = true,
                                 default = nil)
  if valid_564182 != nil:
    section.add "resourceGroupName", valid_564182
  var valid_564183 = path.getOrDefault("workspaceName")
  valid_564183 = validateParameter(valid_564183, JString, required = true,
                                 default = nil)
  if valid_564183 != nil:
    section.add "workspaceName", valid_564183
  result.add "path", section
  ## parameters in `query` object:
  ##   hardDelete: JBool
  ##             : If set to true, the delete cannot be reverted at a later time.
  section = newJObject()
  var valid_564184 = query.getOrDefault("hardDelete")
  valid_564184 = validateParameter(valid_564184, JBool, required = false,
                                 default = newJBool(false))
  if valid_564184 != nil:
    section.add "hardDelete", valid_564184
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   artifactPaths: JObject (required)
  ##                : The list of Artifact paths to delete.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564186: Call_ArtifactsDeleteBatchMetaData_564176; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a Batch of Artifact Metadata.
  ## 
  let valid = call_564186.validator(path, query, header, formData, body)
  let scheme = call_564186.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564186.url(scheme.get, call_564186.host, call_564186.base,
                         call_564186.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564186, url, valid)

proc call*(call_564187: Call_ArtifactsDeleteBatchMetaData_564176; origin: string;
          subscriptionId: string; container: string; resourceGroupName: string;
          artifactPaths: JsonNode; workspaceName: string; hardDelete: bool = false): Recallable =
  ## artifactsDeleteBatchMetaData
  ## Delete a Batch of Artifact Metadata.
  ##   hardDelete: bool
  ##             : If set to true, the delete cannot be reverted at a later time.
  ##   origin: string (required)
  ##         : The origin of the Artifact.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   container: string (required)
  ##            : The container name.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   artifactPaths: JObject (required)
  ##                : The list of Artifact paths to delete.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_564188 = newJObject()
  var query_564189 = newJObject()
  var body_564190 = newJObject()
  add(query_564189, "hardDelete", newJBool(hardDelete))
  add(path_564188, "origin", newJString(origin))
  add(path_564188, "subscriptionId", newJString(subscriptionId))
  add(path_564188, "container", newJString(container))
  add(path_564188, "resourceGroupName", newJString(resourceGroupName))
  if artifactPaths != nil:
    body_564190 = artifactPaths
  add(path_564188, "workspaceName", newJString(workspaceName))
  result = call_564187.call(path_564188, query_564189, nil, nil, body_564190)

var artifactsDeleteBatchMetaData* = Call_ArtifactsDeleteBatchMetaData_564176(
    name: "artifactsDeleteBatchMetaData", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/artifact/v2.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/artifacts/{origin}/{container}/batch/metadata:delete",
    validator: validate_ArtifactsDeleteBatchMetaData_564177, base: "",
    url: url_ArtifactsDeleteBatchMetaData_564178, schemes: {Scheme.Https})
type
  Call_ArtifactsUpload_564204 = ref object of OpenApiRestCall_563539
proc url_ArtifactsUpload_564206(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "origin" in path, "`origin` is a required path parameter"
  assert "container" in path, "`container` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/artifact/v2.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/artifacts/"),
               (kind: VariableSegment, value: "origin"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "container"),
               (kind: ConstantSegment, value: "/content")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ArtifactsUpload_564205(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Upload content to an Artifact.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   origin: JString (required)
  ##         : The origin of the Artifact.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   container: JString (required)
  ##            : The container name.
  ##   resourceGroupName: JString (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `origin` field"
  var valid_564207 = path.getOrDefault("origin")
  valid_564207 = validateParameter(valid_564207, JString, required = true,
                                 default = nil)
  if valid_564207 != nil:
    section.add "origin", valid_564207
  var valid_564208 = path.getOrDefault("subscriptionId")
  valid_564208 = validateParameter(valid_564208, JString, required = true,
                                 default = nil)
  if valid_564208 != nil:
    section.add "subscriptionId", valid_564208
  var valid_564209 = path.getOrDefault("container")
  valid_564209 = validateParameter(valid_564209, JString, required = true,
                                 default = nil)
  if valid_564209 != nil:
    section.add "container", valid_564209
  var valid_564210 = path.getOrDefault("resourceGroupName")
  valid_564210 = validateParameter(valid_564210, JString, required = true,
                                 default = nil)
  if valid_564210 != nil:
    section.add "resourceGroupName", valid_564210
  var valid_564211 = path.getOrDefault("workspaceName")
  valid_564211 = validateParameter(valid_564211, JString, required = true,
                                 default = nil)
  if valid_564211 != nil:
    section.add "workspaceName", valid_564211
  result.add "path", section
  ## parameters in `query` object:
  ##   allowOverwrite: JBool
  ##                 : whether to allow overwrite if Artifact Content exist already. when set to true, Overwrite happens if Artifact Content already exists
  ##   append: JBool
  ##         : Whether or not to append the content or replace it.
  ##   index: JInt
  ##        : The index.
  ##   path: JString
  ##       : The Artifact Path.
  section = newJObject()
  var valid_564212 = query.getOrDefault("allowOverwrite")
  valid_564212 = validateParameter(valid_564212, JBool, required = false,
                                 default = newJBool(false))
  if valid_564212 != nil:
    section.add "allowOverwrite", valid_564212
  var valid_564213 = query.getOrDefault("append")
  valid_564213 = validateParameter(valid_564213, JBool, required = false,
                                 default = newJBool(false))
  if valid_564213 != nil:
    section.add "append", valid_564213
  var valid_564214 = query.getOrDefault("index")
  valid_564214 = validateParameter(valid_564214, JInt, required = false, default = nil)
  if valid_564214 != nil:
    section.add "index", valid_564214
  var valid_564215 = query.getOrDefault("path")
  valid_564215 = validateParameter(valid_564215, JString, required = false,
                                 default = nil)
  if valid_564215 != nil:
    section.add "path", valid_564215
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   content: JString (required)
  ##          : The file upload.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JString, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564217: Call_ArtifactsUpload_564204; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Upload content to an Artifact.
  ## 
  let valid = call_564217.validator(path, query, header, formData, body)
  let scheme = call_564217.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564217.url(scheme.get, call_564217.host, call_564217.base,
                         call_564217.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564217, url, valid)

proc call*(call_564218: Call_ArtifactsUpload_564204; origin: string;
          content: JsonNode; subscriptionId: string; container: string;
          resourceGroupName: string; workspaceName: string;
          allowOverwrite: bool = false; append: bool = false; index: int = 0;
          path: string = ""): Recallable =
  ## artifactsUpload
  ## Upload content to an Artifact.
  ##   origin: string (required)
  ##         : The origin of the Artifact.
  ##   allowOverwrite: bool
  ##                 : whether to allow overwrite if Artifact Content exist already. when set to true, Overwrite happens if Artifact Content already exists
  ##   append: bool
  ##         : Whether or not to append the content or replace it.
  ##   index: int
  ##        : The index.
  ##   path: string
  ##       : The Artifact Path.
  ##   content: JString (required)
  ##          : The file upload.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   container: string (required)
  ##            : The container name.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_564219 = newJObject()
  var query_564220 = newJObject()
  var body_564221 = newJObject()
  add(path_564219, "origin", newJString(origin))
  add(query_564220, "allowOverwrite", newJBool(allowOverwrite))
  add(query_564220, "append", newJBool(append))
  add(query_564220, "index", newJInt(index))
  add(query_564220, "path", newJString(path))
  if content != nil:
    body_564221 = content
  add(path_564219, "subscriptionId", newJString(subscriptionId))
  add(path_564219, "container", newJString(container))
  add(path_564219, "resourceGroupName", newJString(resourceGroupName))
  add(path_564219, "workspaceName", newJString(workspaceName))
  result = call_564218.call(path_564219, query_564220, nil, nil, body_564221)

var artifactsUpload* = Call_ArtifactsUpload_564204(name: "artifactsUpload",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/artifact/v2.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/artifacts/{origin}/{container}/content",
    validator: validate_ArtifactsUpload_564205, base: "", url: url_ArtifactsUpload_564206,
    schemes: {Scheme.Https})
type
  Call_ArtifactsDownload_564191 = ref object of OpenApiRestCall_563539
proc url_ArtifactsDownload_564193(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "origin" in path, "`origin` is a required path parameter"
  assert "container" in path, "`container` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/artifact/v2.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/artifacts/"),
               (kind: VariableSegment, value: "origin"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "container"),
               (kind: ConstantSegment, value: "/content")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ArtifactsDownload_564192(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Get Artifact content of a specific Id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   origin: JString (required)
  ##         : The origin of the Artifact.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   container: JString (required)
  ##            : The container name.
  ##   resourceGroupName: JString (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `origin` field"
  var valid_564194 = path.getOrDefault("origin")
  valid_564194 = validateParameter(valid_564194, JString, required = true,
                                 default = nil)
  if valid_564194 != nil:
    section.add "origin", valid_564194
  var valid_564195 = path.getOrDefault("subscriptionId")
  valid_564195 = validateParameter(valid_564195, JString, required = true,
                                 default = nil)
  if valid_564195 != nil:
    section.add "subscriptionId", valid_564195
  var valid_564196 = path.getOrDefault("container")
  valid_564196 = validateParameter(valid_564196, JString, required = true,
                                 default = nil)
  if valid_564196 != nil:
    section.add "container", valid_564196
  var valid_564197 = path.getOrDefault("resourceGroupName")
  valid_564197 = validateParameter(valid_564197, JString, required = true,
                                 default = nil)
  if valid_564197 != nil:
    section.add "resourceGroupName", valid_564197
  var valid_564198 = path.getOrDefault("workspaceName")
  valid_564198 = validateParameter(valid_564198, JString, required = true,
                                 default = nil)
  if valid_564198 != nil:
    section.add "workspaceName", valid_564198
  result.add "path", section
  ## parameters in `query` object:
  ##   path: JString
  ##       : The Artifact Path.
  section = newJObject()
  var valid_564199 = query.getOrDefault("path")
  valid_564199 = validateParameter(valid_564199, JString, required = false,
                                 default = nil)
  if valid_564199 != nil:
    section.add "path", valid_564199
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564200: Call_ArtifactsDownload_564191; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get Artifact content of a specific Id.
  ## 
  let valid = call_564200.validator(path, query, header, formData, body)
  let scheme = call_564200.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564200.url(scheme.get, call_564200.host, call_564200.base,
                         call_564200.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564200, url, valid)

proc call*(call_564201: Call_ArtifactsDownload_564191; origin: string;
          subscriptionId: string; container: string; resourceGroupName: string;
          workspaceName: string; path: string = ""): Recallable =
  ## artifactsDownload
  ## Get Artifact content of a specific Id.
  ##   origin: string (required)
  ##         : The origin of the Artifact.
  ##   path: string
  ##       : The Artifact Path.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   container: string (required)
  ##            : The container name.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_564202 = newJObject()
  var query_564203 = newJObject()
  add(path_564202, "origin", newJString(origin))
  add(query_564203, "path", newJString(path))
  add(path_564202, "subscriptionId", newJString(subscriptionId))
  add(path_564202, "container", newJString(container))
  add(path_564202, "resourceGroupName", newJString(resourceGroupName))
  add(path_564202, "workspaceName", newJString(workspaceName))
  result = call_564201.call(path_564202, query_564203, nil, nil, nil)

var artifactsDownload* = Call_ArtifactsDownload_564191(name: "artifactsDownload",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/artifact/v2.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/artifacts/{origin}/{container}/content",
    validator: validate_ArtifactsDownload_564192, base: "",
    url: url_ArtifactsDownload_564193, schemes: {Scheme.Https})
type
  Call_ArtifactsGetContentInformation_564222 = ref object of OpenApiRestCall_563539
proc url_ArtifactsGetContentInformation_564224(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "origin" in path, "`origin` is a required path parameter"
  assert "container" in path, "`container` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/artifact/v2.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/artifacts/"),
               (kind: VariableSegment, value: "origin"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "container"),
               (kind: ConstantSegment, value: "/contentinfo")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ArtifactsGetContentInformation_564223(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get content information of an Artifact.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   origin: JString (required)
  ##         : The origin of the Artifact.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   container: JString (required)
  ##            : The container name.
  ##   resourceGroupName: JString (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `origin` field"
  var valid_564225 = path.getOrDefault("origin")
  valid_564225 = validateParameter(valid_564225, JString, required = true,
                                 default = nil)
  if valid_564225 != nil:
    section.add "origin", valid_564225
  var valid_564226 = path.getOrDefault("subscriptionId")
  valid_564226 = validateParameter(valid_564226, JString, required = true,
                                 default = nil)
  if valid_564226 != nil:
    section.add "subscriptionId", valid_564226
  var valid_564227 = path.getOrDefault("container")
  valid_564227 = validateParameter(valid_564227, JString, required = true,
                                 default = nil)
  if valid_564227 != nil:
    section.add "container", valid_564227
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

proc call*(call_564231: Call_ArtifactsGetContentInformation_564222; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get content information of an Artifact.
  ## 
  let valid = call_564231.validator(path, query, header, formData, body)
  let scheme = call_564231.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564231.url(scheme.get, call_564231.host, call_564231.base,
                         call_564231.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564231, url, valid)

proc call*(call_564232: Call_ArtifactsGetContentInformation_564222; origin: string;
          subscriptionId: string; container: string; resourceGroupName: string;
          workspaceName: string; path: string = ""): Recallable =
  ## artifactsGetContentInformation
  ## Get content information of an Artifact.
  ##   origin: string (required)
  ##         : The origin of the Artifact.
  ##   path: string
  ##       : The Artifact Path.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   container: string (required)
  ##            : The container name.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_564233 = newJObject()
  var query_564234 = newJObject()
  add(path_564233, "origin", newJString(origin))
  add(query_564234, "path", newJString(path))
  add(path_564233, "subscriptionId", newJString(subscriptionId))
  add(path_564233, "container", newJString(container))
  add(path_564233, "resourceGroupName", newJString(resourceGroupName))
  add(path_564233, "workspaceName", newJString(workspaceName))
  result = call_564232.call(path_564233, query_564234, nil, nil, nil)

var artifactsGetContentInformation* = Call_ArtifactsGetContentInformation_564222(
    name: "artifactsGetContentInformation", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/artifact/v2.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/artifacts/{origin}/{container}/contentinfo",
    validator: validate_ArtifactsGetContentInformation_564223, base: "",
    url: url_ArtifactsGetContentInformation_564224, schemes: {Scheme.Https})
type
  Call_ArtifactsGetStorageContentInformation_564235 = ref object of OpenApiRestCall_563539
proc url_ArtifactsGetStorageContentInformation_564237(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "origin" in path, "`origin` is a required path parameter"
  assert "container" in path, "`container` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/artifact/v2.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/artifacts/"),
               (kind: VariableSegment, value: "origin"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "container"),
               (kind: ConstantSegment, value: "/contentinfo/storageuri")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ArtifactsGetStorageContentInformation_564236(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get storage content information of an Artifact.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   origin: JString (required)
  ##         : The origin of the Artifact.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   container: JString (required)
  ##            : The container name.
  ##   resourceGroupName: JString (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `origin` field"
  var valid_564238 = path.getOrDefault("origin")
  valid_564238 = validateParameter(valid_564238, JString, required = true,
                                 default = nil)
  if valid_564238 != nil:
    section.add "origin", valid_564238
  var valid_564239 = path.getOrDefault("subscriptionId")
  valid_564239 = validateParameter(valid_564239, JString, required = true,
                                 default = nil)
  if valid_564239 != nil:
    section.add "subscriptionId", valid_564239
  var valid_564240 = path.getOrDefault("container")
  valid_564240 = validateParameter(valid_564240, JString, required = true,
                                 default = nil)
  if valid_564240 != nil:
    section.add "container", valid_564240
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
  ## parameters in `query` object:
  ##   path: JString
  ##       : The Artifact Path.
  section = newJObject()
  var valid_564243 = query.getOrDefault("path")
  valid_564243 = validateParameter(valid_564243, JString, required = false,
                                 default = nil)
  if valid_564243 != nil:
    section.add "path", valid_564243
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564244: Call_ArtifactsGetStorageContentInformation_564235;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get storage content information of an Artifact.
  ## 
  let valid = call_564244.validator(path, query, header, formData, body)
  let scheme = call_564244.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564244.url(scheme.get, call_564244.host, call_564244.base,
                         call_564244.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564244, url, valid)

proc call*(call_564245: Call_ArtifactsGetStorageContentInformation_564235;
          origin: string; subscriptionId: string; container: string;
          resourceGroupName: string; workspaceName: string; path: string = ""): Recallable =
  ## artifactsGetStorageContentInformation
  ## Get storage content information of an Artifact.
  ##   origin: string (required)
  ##         : The origin of the Artifact.
  ##   path: string
  ##       : The Artifact Path.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   container: string (required)
  ##            : The container name.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_564246 = newJObject()
  var query_564247 = newJObject()
  add(path_564246, "origin", newJString(origin))
  add(query_564247, "path", newJString(path))
  add(path_564246, "subscriptionId", newJString(subscriptionId))
  add(path_564246, "container", newJString(container))
  add(path_564246, "resourceGroupName", newJString(resourceGroupName))
  add(path_564246, "workspaceName", newJString(workspaceName))
  result = call_564245.call(path_564246, query_564247, nil, nil, nil)

var artifactsGetStorageContentInformation* = Call_ArtifactsGetStorageContentInformation_564235(
    name: "artifactsGetStorageContentInformation", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/artifact/v2.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/artifacts/{origin}/{container}/contentinfo/storageuri",
    validator: validate_ArtifactsGetStorageContentInformation_564236, base: "",
    url: url_ArtifactsGetStorageContentInformation_564237, schemes: {Scheme.Https})
type
  Call_ArtifactsGet_564248 = ref object of OpenApiRestCall_563539
proc url_ArtifactsGet_564250(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "origin" in path, "`origin` is a required path parameter"
  assert "container" in path, "`container` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/artifact/v2.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/artifacts/"),
               (kind: VariableSegment, value: "origin"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "container"),
               (kind: ConstantSegment, value: "/metadata")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ArtifactsGet_564249(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Get Artifact metadata for a specific Id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   origin: JString (required)
  ##         : The origin of the Artifact.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   container: JString (required)
  ##            : The container name.
  ##   resourceGroupName: JString (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `origin` field"
  var valid_564251 = path.getOrDefault("origin")
  valid_564251 = validateParameter(valid_564251, JString, required = true,
                                 default = nil)
  if valid_564251 != nil:
    section.add "origin", valid_564251
  var valid_564252 = path.getOrDefault("subscriptionId")
  valid_564252 = validateParameter(valid_564252, JString, required = true,
                                 default = nil)
  if valid_564252 != nil:
    section.add "subscriptionId", valid_564252
  var valid_564253 = path.getOrDefault("container")
  valid_564253 = validateParameter(valid_564253, JString, required = true,
                                 default = nil)
  if valid_564253 != nil:
    section.add "container", valid_564253
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
  ##   path: JString (required)
  ##       : The Artifact Path.
  section = newJObject()
  assert query != nil, "query argument is necessary due to required `path` field"
  var valid_564256 = query.getOrDefault("path")
  valid_564256 = validateParameter(valid_564256, JString, required = true,
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

proc call*(call_564257: Call_ArtifactsGet_564248; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get Artifact metadata for a specific Id.
  ## 
  let valid = call_564257.validator(path, query, header, formData, body)
  let scheme = call_564257.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564257.url(scheme.get, call_564257.host, call_564257.base,
                         call_564257.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564257, url, valid)

proc call*(call_564258: Call_ArtifactsGet_564248; origin: string; path: string;
          subscriptionId: string; container: string; resourceGroupName: string;
          workspaceName: string): Recallable =
  ## artifactsGet
  ## Get Artifact metadata for a specific Id.
  ##   origin: string (required)
  ##         : The origin of the Artifact.
  ##   path: string (required)
  ##       : The Artifact Path.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   container: string (required)
  ##            : The container name.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_564259 = newJObject()
  var query_564260 = newJObject()
  add(path_564259, "origin", newJString(origin))
  add(query_564260, "path", newJString(path))
  add(path_564259, "subscriptionId", newJString(subscriptionId))
  add(path_564259, "container", newJString(container))
  add(path_564259, "resourceGroupName", newJString(resourceGroupName))
  add(path_564259, "workspaceName", newJString(workspaceName))
  result = call_564258.call(path_564259, query_564260, nil, nil, nil)

var artifactsGet* = Call_ArtifactsGet_564248(name: "artifactsGet",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/artifact/v2.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/artifacts/{origin}/{container}/metadata",
    validator: validate_ArtifactsGet_564249, base: "", url: url_ArtifactsGet_564250,
    schemes: {Scheme.Https})
type
  Call_ArtifactsDeleteMetaData_564261 = ref object of OpenApiRestCall_563539
proc url_ArtifactsDeleteMetaData_564263(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "origin" in path, "`origin` is a required path parameter"
  assert "container" in path, "`container` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/artifact/v2.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/artifacts/"),
               (kind: VariableSegment, value: "origin"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "container"),
               (kind: ConstantSegment, value: "/metadata")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ArtifactsDeleteMetaData_564262(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete an Artifact Metadata.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   origin: JString (required)
  ##         : The origin of the Artifact.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   container: JString (required)
  ##            : The container name.
  ##   resourceGroupName: JString (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `origin` field"
  var valid_564264 = path.getOrDefault("origin")
  valid_564264 = validateParameter(valid_564264, JString, required = true,
                                 default = nil)
  if valid_564264 != nil:
    section.add "origin", valid_564264
  var valid_564265 = path.getOrDefault("subscriptionId")
  valid_564265 = validateParameter(valid_564265, JString, required = true,
                                 default = nil)
  if valid_564265 != nil:
    section.add "subscriptionId", valid_564265
  var valid_564266 = path.getOrDefault("container")
  valid_564266 = validateParameter(valid_564266, JString, required = true,
                                 default = nil)
  if valid_564266 != nil:
    section.add "container", valid_564266
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
  ##   hardDelete: JBool
  ##             : If set to true. The delete cannot be revert at later time.
  ##   path: JString
  ##       : The Artifact Path.
  section = newJObject()
  var valid_564269 = query.getOrDefault("hardDelete")
  valid_564269 = validateParameter(valid_564269, JBool, required = false,
                                 default = newJBool(false))
  if valid_564269 != nil:
    section.add "hardDelete", valid_564269
  var valid_564270 = query.getOrDefault("path")
  valid_564270 = validateParameter(valid_564270, JString, required = false,
                                 default = nil)
  if valid_564270 != nil:
    section.add "path", valid_564270
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564271: Call_ArtifactsDeleteMetaData_564261; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete an Artifact Metadata.
  ## 
  let valid = call_564271.validator(path, query, header, formData, body)
  let scheme = call_564271.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564271.url(scheme.get, call_564271.host, call_564271.base,
                         call_564271.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564271, url, valid)

proc call*(call_564272: Call_ArtifactsDeleteMetaData_564261; origin: string;
          subscriptionId: string; container: string; resourceGroupName: string;
          workspaceName: string; hardDelete: bool = false; path: string = ""): Recallable =
  ## artifactsDeleteMetaData
  ## Delete an Artifact Metadata.
  ##   hardDelete: bool
  ##             : If set to true. The delete cannot be revert at later time.
  ##   origin: string (required)
  ##         : The origin of the Artifact.
  ##   path: string
  ##       : The Artifact Path.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   container: string (required)
  ##            : The container name.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_564273 = newJObject()
  var query_564274 = newJObject()
  add(query_564274, "hardDelete", newJBool(hardDelete))
  add(path_564273, "origin", newJString(origin))
  add(query_564274, "path", newJString(path))
  add(path_564273, "subscriptionId", newJString(subscriptionId))
  add(path_564273, "container", newJString(container))
  add(path_564273, "resourceGroupName", newJString(resourceGroupName))
  add(path_564273, "workspaceName", newJString(workspaceName))
  result = call_564272.call(path_564273, query_564274, nil, nil, nil)

var artifactsDeleteMetaData* = Call_ArtifactsDeleteMetaData_564261(
    name: "artifactsDeleteMetaData", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/artifact/v2.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/artifacts/{origin}/{container}/metadata",
    validator: validate_ArtifactsDeleteMetaData_564262, base: "",
    url: url_ArtifactsDeleteMetaData_564263, schemes: {Scheme.Https})
type
  Call_ArtifactsListSasByPrefix_564275 = ref object of OpenApiRestCall_563539
proc url_ArtifactsListSasByPrefix_564277(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "origin" in path, "`origin` is a required path parameter"
  assert "container" in path, "`container` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/artifact/v2.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/artifacts/"),
               (kind: VariableSegment, value: "origin"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "container"),
               (kind: ConstantSegment, value: "/prefix/contentinfo")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ArtifactsListSasByPrefix_564276(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get shared access signature for an Artifact in specific path.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   origin: JString (required)
  ##         : The origin of the Artifact.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   container: JString (required)
  ##            : The container name.
  ##   resourceGroupName: JString (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `origin` field"
  var valid_564278 = path.getOrDefault("origin")
  valid_564278 = validateParameter(valid_564278, JString, required = true,
                                 default = nil)
  if valid_564278 != nil:
    section.add "origin", valid_564278
  var valid_564279 = path.getOrDefault("subscriptionId")
  valid_564279 = validateParameter(valid_564279, JString, required = true,
                                 default = nil)
  if valid_564279 != nil:
    section.add "subscriptionId", valid_564279
  var valid_564280 = path.getOrDefault("container")
  valid_564280 = validateParameter(valid_564280, JString, required = true,
                                 default = nil)
  if valid_564280 != nil:
    section.add "container", valid_564280
  var valid_564281 = path.getOrDefault("resourceGroupName")
  valid_564281 = validateParameter(valid_564281, JString, required = true,
                                 default = nil)
  if valid_564281 != nil:
    section.add "resourceGroupName", valid_564281
  var valid_564282 = path.getOrDefault("workspaceName")
  valid_564282 = validateParameter(valid_564282, JString, required = true,
                                 default = nil)
  if valid_564282 != nil:
    section.add "workspaceName", valid_564282
  result.add "path", section
  ## parameters in `query` object:
  ##   path: JString
  ##       : The Artifact Path.
  ##   continuationToken: JString
  ##                    : The continuation token.
  section = newJObject()
  var valid_564283 = query.getOrDefault("path")
  valid_564283 = validateParameter(valid_564283, JString, required = false,
                                 default = nil)
  if valid_564283 != nil:
    section.add "path", valid_564283
  var valid_564284 = query.getOrDefault("continuationToken")
  valid_564284 = validateParameter(valid_564284, JString, required = false,
                                 default = nil)
  if valid_564284 != nil:
    section.add "continuationToken", valid_564284
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564285: Call_ArtifactsListSasByPrefix_564275; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get shared access signature for an Artifact in specific path.
  ## 
  let valid = call_564285.validator(path, query, header, formData, body)
  let scheme = call_564285.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564285.url(scheme.get, call_564285.host, call_564285.base,
                         call_564285.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564285, url, valid)

proc call*(call_564286: Call_ArtifactsListSasByPrefix_564275; origin: string;
          subscriptionId: string; container: string; resourceGroupName: string;
          workspaceName: string; path: string = ""; continuationToken: string = ""): Recallable =
  ## artifactsListSasByPrefix
  ## Get shared access signature for an Artifact in specific path.
  ##   origin: string (required)
  ##         : The origin of the Artifact.
  ##   path: string
  ##       : The Artifact Path.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   continuationToken: string
  ##                    : The continuation token.
  ##   container: string (required)
  ##            : The container name.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_564287 = newJObject()
  var query_564288 = newJObject()
  add(path_564287, "origin", newJString(origin))
  add(query_564288, "path", newJString(path))
  add(path_564287, "subscriptionId", newJString(subscriptionId))
  add(query_564288, "continuationToken", newJString(continuationToken))
  add(path_564287, "container", newJString(container))
  add(path_564287, "resourceGroupName", newJString(resourceGroupName))
  add(path_564287, "workspaceName", newJString(workspaceName))
  result = call_564286.call(path_564287, query_564288, nil, nil, nil)

var artifactsListSasByPrefix* = Call_ArtifactsListSasByPrefix_564275(
    name: "artifactsListSasByPrefix", meth: HttpMethod.HttpGet, host: "azure.local", route: "/artifact/v2.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/artifacts/{origin}/{container}/prefix/contentinfo",
    validator: validate_ArtifactsListSasByPrefix_564276, base: "",
    url: url_ArtifactsListSasByPrefix_564277, schemes: {Scheme.Https})
type
  Call_ArtifactsListStorageUriByPrefix_564289 = ref object of OpenApiRestCall_563539
proc url_ArtifactsListStorageUriByPrefix_564291(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "origin" in path, "`origin` is a required path parameter"
  assert "container" in path, "`container` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/artifact/v2.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/artifacts/"),
               (kind: VariableSegment, value: "origin"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "container"),
               (kind: ConstantSegment, value: "/prefix/contentinfo/storageuri")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ArtifactsListStorageUriByPrefix_564290(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get storage Uri for Artifacts in a specific path.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   origin: JString (required)
  ##         : The origin of the Artifact.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   container: JString (required)
  ##            : The container name.
  ##   resourceGroupName: JString (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `origin` field"
  var valid_564292 = path.getOrDefault("origin")
  valid_564292 = validateParameter(valid_564292, JString, required = true,
                                 default = nil)
  if valid_564292 != nil:
    section.add "origin", valid_564292
  var valid_564293 = path.getOrDefault("subscriptionId")
  valid_564293 = validateParameter(valid_564293, JString, required = true,
                                 default = nil)
  if valid_564293 != nil:
    section.add "subscriptionId", valid_564293
  var valid_564294 = path.getOrDefault("container")
  valid_564294 = validateParameter(valid_564294, JString, required = true,
                                 default = nil)
  if valid_564294 != nil:
    section.add "container", valid_564294
  var valid_564295 = path.getOrDefault("resourceGroupName")
  valid_564295 = validateParameter(valid_564295, JString, required = true,
                                 default = nil)
  if valid_564295 != nil:
    section.add "resourceGroupName", valid_564295
  var valid_564296 = path.getOrDefault("workspaceName")
  valid_564296 = validateParameter(valid_564296, JString, required = true,
                                 default = nil)
  if valid_564296 != nil:
    section.add "workspaceName", valid_564296
  result.add "path", section
  ## parameters in `query` object:
  ##   path: JString
  ##       : The Artifact Path.
  ##   continuationToken: JString
  ##                    : The continuation token.
  section = newJObject()
  var valid_564297 = query.getOrDefault("path")
  valid_564297 = validateParameter(valid_564297, JString, required = false,
                                 default = nil)
  if valid_564297 != nil:
    section.add "path", valid_564297
  var valid_564298 = query.getOrDefault("continuationToken")
  valid_564298 = validateParameter(valid_564298, JString, required = false,
                                 default = nil)
  if valid_564298 != nil:
    section.add "continuationToken", valid_564298
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564299: Call_ArtifactsListStorageUriByPrefix_564289;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get storage Uri for Artifacts in a specific path.
  ## 
  let valid = call_564299.validator(path, query, header, formData, body)
  let scheme = call_564299.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564299.url(scheme.get, call_564299.host, call_564299.base,
                         call_564299.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564299, url, valid)

proc call*(call_564300: Call_ArtifactsListStorageUriByPrefix_564289;
          origin: string; subscriptionId: string; container: string;
          resourceGroupName: string; workspaceName: string; path: string = "";
          continuationToken: string = ""): Recallable =
  ## artifactsListStorageUriByPrefix
  ## Get storage Uri for Artifacts in a specific path.
  ##   origin: string (required)
  ##         : The origin of the Artifact.
  ##   path: string
  ##       : The Artifact Path.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   continuationToken: string
  ##                    : The continuation token.
  ##   container: string (required)
  ##            : The container name.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_564301 = newJObject()
  var query_564302 = newJObject()
  add(path_564301, "origin", newJString(origin))
  add(query_564302, "path", newJString(path))
  add(path_564301, "subscriptionId", newJString(subscriptionId))
  add(query_564302, "continuationToken", newJString(continuationToken))
  add(path_564301, "container", newJString(container))
  add(path_564301, "resourceGroupName", newJString(resourceGroupName))
  add(path_564301, "workspaceName", newJString(workspaceName))
  result = call_564300.call(path_564301, query_564302, nil, nil, nil)

var artifactsListStorageUriByPrefix* = Call_ArtifactsListStorageUriByPrefix_564289(
    name: "artifactsListStorageUriByPrefix", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/artifact/v2.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/artifacts/{origin}/{container}/prefix/contentinfo/storageuri",
    validator: validate_ArtifactsListStorageUriByPrefix_564290, base: "",
    url: url_ArtifactsListStorageUriByPrefix_564291, schemes: {Scheme.Https})
type
  Call_ArtifactsGetSas_564303 = ref object of OpenApiRestCall_563539
proc url_ArtifactsGetSas_564305(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "origin" in path, "`origin` is a required path parameter"
  assert "container" in path, "`container` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/artifact/v2.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/artifacts/"),
               (kind: VariableSegment, value: "origin"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "container"),
               (kind: ConstantSegment, value: "/write")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ArtifactsGetSas_564304(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Get writable shared access signature for a specific Artifact.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   origin: JString (required)
  ##         : The origin of the Artifact.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  ##   container: JString (required)
  ##            : The container name.
  ##   resourceGroupName: JString (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `origin` field"
  var valid_564306 = path.getOrDefault("origin")
  valid_564306 = validateParameter(valid_564306, JString, required = true,
                                 default = nil)
  if valid_564306 != nil:
    section.add "origin", valid_564306
  var valid_564307 = path.getOrDefault("subscriptionId")
  valid_564307 = validateParameter(valid_564307, JString, required = true,
                                 default = nil)
  if valid_564307 != nil:
    section.add "subscriptionId", valid_564307
  var valid_564308 = path.getOrDefault("container")
  valid_564308 = validateParameter(valid_564308, JString, required = true,
                                 default = nil)
  if valid_564308 != nil:
    section.add "container", valid_564308
  var valid_564309 = path.getOrDefault("resourceGroupName")
  valid_564309 = validateParameter(valid_564309, JString, required = true,
                                 default = nil)
  if valid_564309 != nil:
    section.add "resourceGroupName", valid_564309
  var valid_564310 = path.getOrDefault("workspaceName")
  valid_564310 = validateParameter(valid_564310, JString, required = true,
                                 default = nil)
  if valid_564310 != nil:
    section.add "workspaceName", valid_564310
  result.add "path", section
  ## parameters in `query` object:
  ##   path: JString
  ##       : The Artifact Path.
  section = newJObject()
  var valid_564311 = query.getOrDefault("path")
  valid_564311 = validateParameter(valid_564311, JString, required = false,
                                 default = nil)
  if valid_564311 != nil:
    section.add "path", valid_564311
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564312: Call_ArtifactsGetSas_564303; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get writable shared access signature for a specific Artifact.
  ## 
  let valid = call_564312.validator(path, query, header, formData, body)
  let scheme = call_564312.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564312.url(scheme.get, call_564312.host, call_564312.base,
                         call_564312.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564312, url, valid)

proc call*(call_564313: Call_ArtifactsGetSas_564303; origin: string;
          subscriptionId: string; container: string; resourceGroupName: string;
          workspaceName: string; path: string = ""): Recallable =
  ## artifactsGetSas
  ## Get writable shared access signature for a specific Artifact.
  ##   origin: string (required)
  ##         : The origin of the Artifact.
  ##   path: string
  ##       : The Artifact Path.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   container: string (required)
  ##            : The container name.
  ##   resourceGroupName: string (required)
  ##                    : The Name of the resource group in which the workspace is located.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_564314 = newJObject()
  var query_564315 = newJObject()
  add(path_564314, "origin", newJString(origin))
  add(query_564315, "path", newJString(path))
  add(path_564314, "subscriptionId", newJString(subscriptionId))
  add(path_564314, "container", newJString(container))
  add(path_564314, "resourceGroupName", newJString(resourceGroupName))
  add(path_564314, "workspaceName", newJString(workspaceName))
  result = call_564313.call(path_564314, query_564315, nil, nil, nil)

var artifactsGetSas* = Call_ArtifactsGetSas_564303(name: "artifactsGetSas",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/artifact/v2.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningServices/workspaces/{workspaceName}/artifacts/{origin}/{container}/write",
    validator: validate_ArtifactsGetSas_564304, base: "", url: url_ArtifactsGetSas_564305,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
