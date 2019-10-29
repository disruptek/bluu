
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: Azure Machine Learning Model Management Service
## version: 2019-08-01
## termsOfService: (not provided)
## license: (not provided)
## 
## These APIs allow end users to manage Azure Machine Learning Models, Images, Profiles, and Services.
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

  OpenApiRestCall_563548 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563548](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563548): Option[Scheme] {.used.} =
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
  macServiceName = "machinelearningservices-modelManagement"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AssetsCreate_564106 = ref object of OpenApiRestCall_563548
proc url_AssetsCreate_564108(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroup" in path, "`resourceGroup` is a required path parameter"
  assert "workspace" in path, "`workspace` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/modelmanagement/v1.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroup"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspace"),
               (kind: ConstantSegment, value: "/assets")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AssetsCreate_564107(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Create an Asset from the provided payload.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   workspace: JString (required)
  ##            : The name of the workspace.
  ##   resourceGroup: JString (required)
  ##                : The Name of the resource group in which the workspace is located.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `workspace` field"
  var valid_564109 = path.getOrDefault("workspace")
  valid_564109 = validateParameter(valid_564109, JString, required = true,
                                 default = nil)
  if valid_564109 != nil:
    section.add "workspace", valid_564109
  var valid_564110 = path.getOrDefault("resourceGroup")
  valid_564110 = validateParameter(valid_564110, JString, required = true,
                                 default = nil)
  if valid_564110 != nil:
    section.add "resourceGroup", valid_564110
  var valid_564111 = path.getOrDefault("subscriptionId")
  valid_564111 = validateParameter(valid_564111, JString, required = true,
                                 default = nil)
  if valid_564111 != nil:
    section.add "subscriptionId", valid_564111
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   asset: JObject
  ##        : The Asset to be created.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564113: Call_AssetsCreate_564106; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create an Asset from the provided payload.
  ## 
  let valid = call_564113.validator(path, query, header, formData, body)
  let scheme = call_564113.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564113.url(scheme.get, call_564113.host, call_564113.base,
                         call_564113.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564113, url, valid)

proc call*(call_564114: Call_AssetsCreate_564106; workspace: string;
          resourceGroup: string; subscriptionId: string; asset: JsonNode = nil): Recallable =
  ## assetsCreate
  ## Create an Asset from the provided payload.
  ##   workspace: string (required)
  ##            : The name of the workspace.
  ##   resourceGroup: string (required)
  ##                : The Name of the resource group in which the workspace is located.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   asset: JObject
  ##        : The Asset to be created.
  var path_564115 = newJObject()
  var body_564116 = newJObject()
  add(path_564115, "workspace", newJString(workspace))
  add(path_564115, "resourceGroup", newJString(resourceGroup))
  add(path_564115, "subscriptionId", newJString(subscriptionId))
  if asset != nil:
    body_564116 = asset
  result = call_564114.call(path_564115, nil, nil, nil, body_564116)

var assetsCreate* = Call_AssetsCreate_564106(name: "assetsCreate",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/modelmanagement/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.MachineLearningServices/workspaces/{workspace}/assets",
    validator: validate_AssetsCreate_564107, base: "", url: url_AssetsCreate_564108,
    schemes: {Scheme.Https})
type
  Call_AssetsListQuery_563770 = ref object of OpenApiRestCall_563548
proc url_AssetsListQuery_563772(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroup" in path, "`resourceGroup` is a required path parameter"
  assert "workspace" in path, "`workspace` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/modelmanagement/v1.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroup"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspace"),
               (kind: ConstantSegment, value: "/assets")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AssetsListQuery_563771(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## If no filter is passed, the query lists all the Assets in the given workspace. The returned list is paginated and the count of items in each page is an optional parameter.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   workspace: JString (required)
  ##            : The name of the workspace.
  ##   resourceGroup: JString (required)
  ##                : The Name of the resource group in which the workspace is located.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `workspace` field"
  var valid_563948 = path.getOrDefault("workspace")
  valid_563948 = validateParameter(valid_563948, JString, required = true,
                                 default = nil)
  if valid_563948 != nil:
    section.add "workspace", valid_563948
  var valid_563949 = path.getOrDefault("resourceGroup")
  valid_563949 = validateParameter(valid_563949, JString, required = true,
                                 default = nil)
  if valid_563949 != nil:
    section.add "resourceGroup", valid_563949
  var valid_563950 = path.getOrDefault("subscriptionId")
  valid_563950 = validateParameter(valid_563950, JString, required = true,
                                 default = nil)
  if valid_563950 != nil:
    section.add "subscriptionId", valid_563950
  result.add "path", section
  ## parameters in `query` object:
  ##   name: JString
  ##       : The object name.
  ##   $skipToken: JString
  ##             : The continuation token to retrieve the next page.
  ##   tags: JString
  ##       : A set of tags with which to filter the returned models.
  ##             It is a comma separated string of tags key or tags key=value
  ##             Example: tagKey1,tagKey2,tagKey3=value3
  ##   count: JInt
  ##        : The number of items to retrieve in a page.
  ##   orderby: JString
  ##          : An option for specifying how to order the list.
  ##   properties: JString
  ##             : A set of properties with which to filter the returned models.
  ##             It is a comma separated string of properties key and/or properties key=value
  ##             Example: propKey1,propKey2,propKey3=value3
  ##   runId: JString
  ##        : The run Id associated with the Assets.
  section = newJObject()
  var valid_563951 = query.getOrDefault("name")
  valid_563951 = validateParameter(valid_563951, JString, required = false,
                                 default = nil)
  if valid_563951 != nil:
    section.add "name", valid_563951
  var valid_563952 = query.getOrDefault("$skipToken")
  valid_563952 = validateParameter(valid_563952, JString, required = false,
                                 default = nil)
  if valid_563952 != nil:
    section.add "$skipToken", valid_563952
  var valid_563953 = query.getOrDefault("tags")
  valid_563953 = validateParameter(valid_563953, JString, required = false,
                                 default = nil)
  if valid_563953 != nil:
    section.add "tags", valid_563953
  var valid_563954 = query.getOrDefault("count")
  valid_563954 = validateParameter(valid_563954, JInt, required = false, default = nil)
  if valid_563954 != nil:
    section.add "count", valid_563954
  var valid_563968 = query.getOrDefault("orderby")
  valid_563968 = validateParameter(valid_563968, JString, required = false,
                                 default = newJString("CreatedAtDesc"))
  if valid_563968 != nil:
    section.add "orderby", valid_563968
  var valid_563969 = query.getOrDefault("properties")
  valid_563969 = validateParameter(valid_563969, JString, required = false,
                                 default = nil)
  if valid_563969 != nil:
    section.add "properties", valid_563969
  var valid_563970 = query.getOrDefault("runId")
  valid_563970 = validateParameter(valid_563970, JString, required = false,
                                 default = nil)
  if valid_563970 != nil:
    section.add "runId", valid_563970
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563993: Call_AssetsListQuery_563770; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## If no filter is passed, the query lists all the Assets in the given workspace. The returned list is paginated and the count of items in each page is an optional parameter.
  ## 
  let valid = call_563993.validator(path, query, header, formData, body)
  let scheme = call_563993.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563993.url(scheme.get, call_563993.host, call_563993.base,
                         call_563993.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563993, url, valid)

proc call*(call_564064: Call_AssetsListQuery_563770; workspace: string;
          resourceGroup: string; subscriptionId: string; name: string = "";
          SkipToken: string = ""; tags: string = ""; count: int = 0;
          orderby: string = "CreatedAtDesc"; properties: string = ""; runId: string = ""): Recallable =
  ## assetsListQuery
  ## If no filter is passed, the query lists all the Assets in the given workspace. The returned list is paginated and the count of items in each page is an optional parameter.
  ##   workspace: string (required)
  ##            : The name of the workspace.
  ##   name: string
  ##       : The object name.
  ##   SkipToken: string
  ##            : The continuation token to retrieve the next page.
  ##   tags: string
  ##       : A set of tags with which to filter the returned models.
  ##             It is a comma separated string of tags key or tags key=value
  ##             Example: tagKey1,tagKey2,tagKey3=value3
  ##   resourceGroup: string (required)
  ##                : The Name of the resource group in which the workspace is located.
  ##   count: int
  ##        : The number of items to retrieve in a page.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   orderby: string
  ##          : An option for specifying how to order the list.
  ##   properties: string
  ##             : A set of properties with which to filter the returned models.
  ##             It is a comma separated string of properties key and/or properties key=value
  ##             Example: propKey1,propKey2,propKey3=value3
  ##   runId: string
  ##        : The run Id associated with the Assets.
  var path_564065 = newJObject()
  var query_564067 = newJObject()
  add(path_564065, "workspace", newJString(workspace))
  add(query_564067, "name", newJString(name))
  add(query_564067, "$skipToken", newJString(SkipToken))
  add(query_564067, "tags", newJString(tags))
  add(path_564065, "resourceGroup", newJString(resourceGroup))
  add(query_564067, "count", newJInt(count))
  add(path_564065, "subscriptionId", newJString(subscriptionId))
  add(query_564067, "orderby", newJString(orderby))
  add(query_564067, "properties", newJString(properties))
  add(query_564067, "runId", newJString(runId))
  result = call_564064.call(path_564065, query_564067, nil, nil, nil)

var assetsListQuery* = Call_AssetsListQuery_563770(name: "assetsListQuery",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/modelmanagement/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.MachineLearningServices/workspaces/{workspace}/assets",
    validator: validate_AssetsListQuery_563771, base: "", url: url_AssetsListQuery_563772,
    schemes: {Scheme.Https})
type
  Call_AssetsQueryById_564117 = ref object of OpenApiRestCall_563548
proc url_AssetsQueryById_564119(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroup" in path, "`resourceGroup` is a required path parameter"
  assert "workspace" in path, "`workspace` is a required path parameter"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/modelmanagement/v1.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroup"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspace"),
               (kind: ConstantSegment, value: "/assets/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AssetsQueryById_564118(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Get an Asset by Id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   workspace: JString (required)
  ##            : The name of the workspace.
  ##   resourceGroup: JString (required)
  ##                : The Name of the resource group in which the workspace is located.
  ##   id: JString (required)
  ##     : The Asset Id.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `workspace` field"
  var valid_564120 = path.getOrDefault("workspace")
  valid_564120 = validateParameter(valid_564120, JString, required = true,
                                 default = nil)
  if valid_564120 != nil:
    section.add "workspace", valid_564120
  var valid_564121 = path.getOrDefault("resourceGroup")
  valid_564121 = validateParameter(valid_564121, JString, required = true,
                                 default = nil)
  if valid_564121 != nil:
    section.add "resourceGroup", valid_564121
  var valid_564122 = path.getOrDefault("id")
  valid_564122 = validateParameter(valid_564122, JString, required = true,
                                 default = nil)
  if valid_564122 != nil:
    section.add "id", valid_564122
  var valid_564123 = path.getOrDefault("subscriptionId")
  valid_564123 = validateParameter(valid_564123, JString, required = true,
                                 default = nil)
  if valid_564123 != nil:
    section.add "subscriptionId", valid_564123
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564124: Call_AssetsQueryById_564117; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get an Asset by Id.
  ## 
  let valid = call_564124.validator(path, query, header, formData, body)
  let scheme = call_564124.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564124.url(scheme.get, call_564124.host, call_564124.base,
                         call_564124.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564124, url, valid)

proc call*(call_564125: Call_AssetsQueryById_564117; workspace: string;
          resourceGroup: string; id: string; subscriptionId: string): Recallable =
  ## assetsQueryById
  ## Get an Asset by Id.
  ##   workspace: string (required)
  ##            : The name of the workspace.
  ##   resourceGroup: string (required)
  ##                : The Name of the resource group in which the workspace is located.
  ##   id: string (required)
  ##     : The Asset Id.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  var path_564126 = newJObject()
  add(path_564126, "workspace", newJString(workspace))
  add(path_564126, "resourceGroup", newJString(resourceGroup))
  add(path_564126, "id", newJString(id))
  add(path_564126, "subscriptionId", newJString(subscriptionId))
  result = call_564125.call(path_564126, nil, nil, nil, nil)

var assetsQueryById* = Call_AssetsQueryById_564117(name: "assetsQueryById",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/modelmanagement/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.MachineLearningServices/workspaces/{workspace}/assets/{id}",
    validator: validate_AssetsQueryById_564118, base: "", url: url_AssetsQueryById_564119,
    schemes: {Scheme.Https})
type
  Call_AssetsPatch_564137 = ref object of OpenApiRestCall_563548
proc url_AssetsPatch_564139(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroup" in path, "`resourceGroup` is a required path parameter"
  assert "workspace" in path, "`workspace` is a required path parameter"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/modelmanagement/v1.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroup"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspace"),
               (kind: ConstantSegment, value: "/assets/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AssetsPatch_564138(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Patch a specific Asset.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   workspace: JString (required)
  ##            : The name of the workspace.
  ##   resourceGroup: JString (required)
  ##                : The Name of the resource group in which the workspace is located.
  ##   id: JString (required)
  ##     : The Id of the Asset to patch.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `workspace` field"
  var valid_564140 = path.getOrDefault("workspace")
  valid_564140 = validateParameter(valid_564140, JString, required = true,
                                 default = nil)
  if valid_564140 != nil:
    section.add "workspace", valid_564140
  var valid_564141 = path.getOrDefault("resourceGroup")
  valid_564141 = validateParameter(valid_564141, JString, required = true,
                                 default = nil)
  if valid_564141 != nil:
    section.add "resourceGroup", valid_564141
  var valid_564142 = path.getOrDefault("id")
  valid_564142 = validateParameter(valid_564142, JString, required = true,
                                 default = nil)
  if valid_564142 != nil:
    section.add "id", valid_564142
  var valid_564143 = path.getOrDefault("subscriptionId")
  valid_564143 = validateParameter(valid_564143, JString, required = true,
                                 default = nil)
  if valid_564143 != nil:
    section.add "subscriptionId", valid_564143
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   patch: JArray (required)
  ##        : The payload that is used to patch an Asset.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JArray, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564145: Call_AssetsPatch_564137; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Patch a specific Asset.
  ## 
  let valid = call_564145.validator(path, query, header, formData, body)
  let scheme = call_564145.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564145.url(scheme.get, call_564145.host, call_564145.base,
                         call_564145.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564145, url, valid)

proc call*(call_564146: Call_AssetsPatch_564137; workspace: string;
          resourceGroup: string; id: string; subscriptionId: string; patch: JsonNode): Recallable =
  ## assetsPatch
  ## Patch a specific Asset.
  ##   workspace: string (required)
  ##            : The name of the workspace.
  ##   resourceGroup: string (required)
  ##                : The Name of the resource group in which the workspace is located.
  ##   id: string (required)
  ##     : The Id of the Asset to patch.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   patch: JArray (required)
  ##        : The payload that is used to patch an Asset.
  var path_564147 = newJObject()
  var body_564148 = newJObject()
  add(path_564147, "workspace", newJString(workspace))
  add(path_564147, "resourceGroup", newJString(resourceGroup))
  add(path_564147, "id", newJString(id))
  add(path_564147, "subscriptionId", newJString(subscriptionId))
  if patch != nil:
    body_564148 = patch
  result = call_564146.call(path_564147, nil, nil, nil, body_564148)

var assetsPatch* = Call_AssetsPatch_564137(name: "assetsPatch",
                                        meth: HttpMethod.HttpPatch,
                                        host: "azure.local", route: "/modelmanagement/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.MachineLearningServices/workspaces/{workspace}/assets/{id}",
                                        validator: validate_AssetsPatch_564138,
                                        base: "", url: url_AssetsPatch_564139,
                                        schemes: {Scheme.Https})
type
  Call_AssetsDelete_564127 = ref object of OpenApiRestCall_563548
proc url_AssetsDelete_564129(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroup" in path, "`resourceGroup` is a required path parameter"
  assert "workspace" in path, "`workspace` is a required path parameter"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/modelmanagement/v1.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroup"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspace"),
               (kind: ConstantSegment, value: "/assets/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AssetsDelete_564128(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete the specified Asset.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   workspace: JString (required)
  ##            : The name of the workspace.
  ##   resourceGroup: JString (required)
  ##                : The Name of the resource group in which the workspace is located.
  ##   id: JString (required)
  ##     : The Id of the Asset to delete.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `workspace` field"
  var valid_564130 = path.getOrDefault("workspace")
  valid_564130 = validateParameter(valid_564130, JString, required = true,
                                 default = nil)
  if valid_564130 != nil:
    section.add "workspace", valid_564130
  var valid_564131 = path.getOrDefault("resourceGroup")
  valid_564131 = validateParameter(valid_564131, JString, required = true,
                                 default = nil)
  if valid_564131 != nil:
    section.add "resourceGroup", valid_564131
  var valid_564132 = path.getOrDefault("id")
  valid_564132 = validateParameter(valid_564132, JString, required = true,
                                 default = nil)
  if valid_564132 != nil:
    section.add "id", valid_564132
  var valid_564133 = path.getOrDefault("subscriptionId")
  valid_564133 = validateParameter(valid_564133, JString, required = true,
                                 default = nil)
  if valid_564133 != nil:
    section.add "subscriptionId", valid_564133
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564134: Call_AssetsDelete_564127; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete the specified Asset.
  ## 
  let valid = call_564134.validator(path, query, header, formData, body)
  let scheme = call_564134.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564134.url(scheme.get, call_564134.host, call_564134.base,
                         call_564134.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564134, url, valid)

proc call*(call_564135: Call_AssetsDelete_564127; workspace: string;
          resourceGroup: string; id: string; subscriptionId: string): Recallable =
  ## assetsDelete
  ## Delete the specified Asset.
  ##   workspace: string (required)
  ##            : The name of the workspace.
  ##   resourceGroup: string (required)
  ##                : The Name of the resource group in which the workspace is located.
  ##   id: string (required)
  ##     : The Id of the Asset to delete.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  var path_564136 = newJObject()
  add(path_564136, "workspace", newJString(workspace))
  add(path_564136, "resourceGroup", newJString(resourceGroup))
  add(path_564136, "id", newJString(id))
  add(path_564136, "subscriptionId", newJString(subscriptionId))
  result = call_564135.call(path_564136, nil, nil, nil, nil)

var assetsDelete* = Call_AssetsDelete_564127(name: "assetsDelete",
    meth: HttpMethod.HttpDelete, host: "azure.local", route: "/modelmanagement/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.MachineLearningServices/workspaces/{workspace}/assets/{id}",
    validator: validate_AssetsDelete_564128, base: "", url: url_AssetsDelete_564129,
    schemes: {Scheme.Https})
type
  Call_ProfilesCreate_564167 = ref object of OpenApiRestCall_563548
proc url_ProfilesCreate_564169(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroup" in path, "`resourceGroup` is a required path parameter"
  assert "workspace" in path, "`workspace` is a required path parameter"
  assert "imageId" in path, "`imageId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/modelmanagement/v1.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroup"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspace"),
               (kind: ConstantSegment, value: "/images/"),
               (kind: VariableSegment, value: "imageId"),
               (kind: ConstantSegment, value: "/profiles")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProfilesCreate_564168(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Create a Profile for an Image.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   imageId: JString (required)
  ##          : The Image Id.
  ##   workspace: JString (required)
  ##            : The name of the workspace.
  ##   resourceGroup: JString (required)
  ##                : The Name of the resource group in which the workspace is located.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `imageId` field"
  var valid_564170 = path.getOrDefault("imageId")
  valid_564170 = validateParameter(valid_564170, JString, required = true,
                                 default = nil)
  if valid_564170 != nil:
    section.add "imageId", valid_564170
  var valid_564171 = path.getOrDefault("workspace")
  valid_564171 = validateParameter(valid_564171, JString, required = true,
                                 default = nil)
  if valid_564171 != nil:
    section.add "workspace", valid_564171
  var valid_564172 = path.getOrDefault("resourceGroup")
  valid_564172 = validateParameter(valid_564172, JString, required = true,
                                 default = nil)
  if valid_564172 != nil:
    section.add "resourceGroup", valid_564172
  var valid_564173 = path.getOrDefault("subscriptionId")
  valid_564173 = validateParameter(valid_564173, JString, required = true,
                                 default = nil)
  if valid_564173 != nil:
    section.add "subscriptionId", valid_564173
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   inputRequest: JObject (required)
  ##               : The payload that is used to create the Profile.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564175: Call_ProfilesCreate_564167; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a Profile for an Image.
  ## 
  let valid = call_564175.validator(path, query, header, formData, body)
  let scheme = call_564175.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564175.url(scheme.get, call_564175.host, call_564175.base,
                         call_564175.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564175, url, valid)

proc call*(call_564176: Call_ProfilesCreate_564167; imageId: string;
          workspace: string; resourceGroup: string; inputRequest: JsonNode;
          subscriptionId: string): Recallable =
  ## profilesCreate
  ## Create a Profile for an Image.
  ##   imageId: string (required)
  ##          : The Image Id.
  ##   workspace: string (required)
  ##            : The name of the workspace.
  ##   resourceGroup: string (required)
  ##                : The Name of the resource group in which the workspace is located.
  ##   inputRequest: JObject (required)
  ##               : The payload that is used to create the Profile.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  var path_564177 = newJObject()
  var body_564178 = newJObject()
  add(path_564177, "imageId", newJString(imageId))
  add(path_564177, "workspace", newJString(workspace))
  add(path_564177, "resourceGroup", newJString(resourceGroup))
  if inputRequest != nil:
    body_564178 = inputRequest
  add(path_564177, "subscriptionId", newJString(subscriptionId))
  result = call_564176.call(path_564177, nil, nil, nil, body_564178)

var profilesCreate* = Call_ProfilesCreate_564167(name: "profilesCreate",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/modelmanagement/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.MachineLearningServices/workspaces/{workspace}/images/{imageId}/profiles",
    validator: validate_ProfilesCreate_564168, base: "", url: url_ProfilesCreate_564169,
    schemes: {Scheme.Https})
type
  Call_ProfilesListQuery_564149 = ref object of OpenApiRestCall_563548
proc url_ProfilesListQuery_564151(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroup" in path, "`resourceGroup` is a required path parameter"
  assert "workspace" in path, "`workspace` is a required path parameter"
  assert "imageId" in path, "`imageId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/modelmanagement/v1.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroup"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspace"),
               (kind: ConstantSegment, value: "/images/"),
               (kind: VariableSegment, value: "imageId"),
               (kind: ConstantSegment, value: "/profiles")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProfilesListQuery_564150(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## If no filter is passed, the query lists all Profiles for the Image. The returned list is paginated and the count of items in each page is an optional parameter.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   imageId: JString (required)
  ##          : The Image Id.
  ##   workspace: JString (required)
  ##            : The name of the workspace.
  ##   resourceGroup: JString (required)
  ##                : The Name of the resource group in which the workspace is located.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `imageId` field"
  var valid_564152 = path.getOrDefault("imageId")
  valid_564152 = validateParameter(valid_564152, JString, required = true,
                                 default = nil)
  if valid_564152 != nil:
    section.add "imageId", valid_564152
  var valid_564153 = path.getOrDefault("workspace")
  valid_564153 = validateParameter(valid_564153, JString, required = true,
                                 default = nil)
  if valid_564153 != nil:
    section.add "workspace", valid_564153
  var valid_564154 = path.getOrDefault("resourceGroup")
  valid_564154 = validateParameter(valid_564154, JString, required = true,
                                 default = nil)
  if valid_564154 != nil:
    section.add "resourceGroup", valid_564154
  var valid_564155 = path.getOrDefault("subscriptionId")
  valid_564155 = validateParameter(valid_564155, JString, required = true,
                                 default = nil)
  if valid_564155 != nil:
    section.add "subscriptionId", valid_564155
  result.add "path", section
  ## parameters in `query` object:
  ##   name: JString
  ##       : The Profile name.
  ##   tags: JString
  ##       : A set of tags with which to filter the returned models.
  ##             It is a comma separated string of tags key or tags key=value
  ##             Example: tagKey1,tagKey2,tagKey3=value3
  ##   $skipToken: JString
  ##             : The continuation token to retrieve the next page.
  ##   description: JString
  ##              : The Profile description.
  ##   count: JInt
  ##        : The number of items to retrieve in a page.
  ##   orderBy: JString
  ##          : The option to order the response.
  ##   properties: JString
  ##             : A set of properties with which to filter the returned models.
  ##             It is a comma separated string of properties key and/or properties key=value
  ##             Example: propKey1,propKey2,propKey3=value3
  section = newJObject()
  var valid_564156 = query.getOrDefault("name")
  valid_564156 = validateParameter(valid_564156, JString, required = false,
                                 default = nil)
  if valid_564156 != nil:
    section.add "name", valid_564156
  var valid_564157 = query.getOrDefault("tags")
  valid_564157 = validateParameter(valid_564157, JString, required = false,
                                 default = nil)
  if valid_564157 != nil:
    section.add "tags", valid_564157
  var valid_564158 = query.getOrDefault("$skipToken")
  valid_564158 = validateParameter(valid_564158, JString, required = false,
                                 default = nil)
  if valid_564158 != nil:
    section.add "$skipToken", valid_564158
  var valid_564159 = query.getOrDefault("description")
  valid_564159 = validateParameter(valid_564159, JString, required = false,
                                 default = nil)
  if valid_564159 != nil:
    section.add "description", valid_564159
  var valid_564160 = query.getOrDefault("count")
  valid_564160 = validateParameter(valid_564160, JInt, required = false, default = nil)
  if valid_564160 != nil:
    section.add "count", valid_564160
  var valid_564161 = query.getOrDefault("orderBy")
  valid_564161 = validateParameter(valid_564161, JString, required = false,
                                 default = newJString("CreatedAtDesc"))
  if valid_564161 != nil:
    section.add "orderBy", valid_564161
  var valid_564162 = query.getOrDefault("properties")
  valid_564162 = validateParameter(valid_564162, JString, required = false,
                                 default = nil)
  if valid_564162 != nil:
    section.add "properties", valid_564162
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564163: Call_ProfilesListQuery_564149; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## If no filter is passed, the query lists all Profiles for the Image. The returned list is paginated and the count of items in each page is an optional parameter.
  ## 
  let valid = call_564163.validator(path, query, header, formData, body)
  let scheme = call_564163.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564163.url(scheme.get, call_564163.host, call_564163.base,
                         call_564163.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564163, url, valid)

proc call*(call_564164: Call_ProfilesListQuery_564149; imageId: string;
          workspace: string; resourceGroup: string; subscriptionId: string;
          name: string = ""; tags: string = ""; SkipToken: string = "";
          description: string = ""; count: int = 0; orderBy: string = "CreatedAtDesc";
          properties: string = ""): Recallable =
  ## profilesListQuery
  ## If no filter is passed, the query lists all Profiles for the Image. The returned list is paginated and the count of items in each page is an optional parameter.
  ##   imageId: string (required)
  ##          : The Image Id.
  ##   workspace: string (required)
  ##            : The name of the workspace.
  ##   name: string
  ##       : The Profile name.
  ##   tags: string
  ##       : A set of tags with which to filter the returned models.
  ##             It is a comma separated string of tags key or tags key=value
  ##             Example: tagKey1,tagKey2,tagKey3=value3
  ##   SkipToken: string
  ##            : The continuation token to retrieve the next page.
  ##   description: string
  ##              : The Profile description.
  ##   resourceGroup: string (required)
  ##                : The Name of the resource group in which the workspace is located.
  ##   count: int
  ##        : The number of items to retrieve in a page.
  ##   orderBy: string
  ##          : The option to order the response.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   properties: string
  ##             : A set of properties with which to filter the returned models.
  ##             It is a comma separated string of properties key and/or properties key=value
  ##             Example: propKey1,propKey2,propKey3=value3
  var path_564165 = newJObject()
  var query_564166 = newJObject()
  add(path_564165, "imageId", newJString(imageId))
  add(path_564165, "workspace", newJString(workspace))
  add(query_564166, "name", newJString(name))
  add(query_564166, "tags", newJString(tags))
  add(query_564166, "$skipToken", newJString(SkipToken))
  add(query_564166, "description", newJString(description))
  add(path_564165, "resourceGroup", newJString(resourceGroup))
  add(query_564166, "count", newJInt(count))
  add(query_564166, "orderBy", newJString(orderBy))
  add(path_564165, "subscriptionId", newJString(subscriptionId))
  add(query_564166, "properties", newJString(properties))
  result = call_564164.call(path_564165, query_564166, nil, nil, nil)

var profilesListQuery* = Call_ProfilesListQuery_564149(name: "profilesListQuery",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/modelmanagement/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.MachineLearningServices/workspaces/{workspace}/images/{imageId}/profiles",
    validator: validate_ProfilesListQuery_564150, base: "",
    url: url_ProfilesListQuery_564151, schemes: {Scheme.Https})
type
  Call_ProfilesQueryById_564179 = ref object of OpenApiRestCall_563548
proc url_ProfilesQueryById_564181(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroup" in path, "`resourceGroup` is a required path parameter"
  assert "workspace" in path, "`workspace` is a required path parameter"
  assert "imageId" in path, "`imageId` is a required path parameter"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/modelmanagement/v1.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroup"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspace"),
               (kind: ConstantSegment, value: "/images/"),
               (kind: VariableSegment, value: "imageId"),
               (kind: ConstantSegment, value: "/profiles/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProfilesQueryById_564180(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Get the Profile for an Image.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   imageId: JString (required)
  ##          : The Image Id.
  ##   workspace: JString (required)
  ##            : The name of the workspace.
  ##   resourceGroup: JString (required)
  ##                : The Name of the resource group in which the workspace is located.
  ##   id: JString (required)
  ##     : The Profile Id.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `imageId` field"
  var valid_564182 = path.getOrDefault("imageId")
  valid_564182 = validateParameter(valid_564182, JString, required = true,
                                 default = nil)
  if valid_564182 != nil:
    section.add "imageId", valid_564182
  var valid_564183 = path.getOrDefault("workspace")
  valid_564183 = validateParameter(valid_564183, JString, required = true,
                                 default = nil)
  if valid_564183 != nil:
    section.add "workspace", valid_564183
  var valid_564184 = path.getOrDefault("resourceGroup")
  valid_564184 = validateParameter(valid_564184, JString, required = true,
                                 default = nil)
  if valid_564184 != nil:
    section.add "resourceGroup", valid_564184
  var valid_564185 = path.getOrDefault("id")
  valid_564185 = validateParameter(valid_564185, JString, required = true,
                                 default = nil)
  if valid_564185 != nil:
    section.add "id", valid_564185
  var valid_564186 = path.getOrDefault("subscriptionId")
  valid_564186 = validateParameter(valid_564186, JString, required = true,
                                 default = nil)
  if valid_564186 != nil:
    section.add "subscriptionId", valid_564186
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564187: Call_ProfilesQueryById_564179; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the Profile for an Image.
  ## 
  let valid = call_564187.validator(path, query, header, formData, body)
  let scheme = call_564187.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564187.url(scheme.get, call_564187.host, call_564187.base,
                         call_564187.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564187, url, valid)

proc call*(call_564188: Call_ProfilesQueryById_564179; imageId: string;
          workspace: string; resourceGroup: string; id: string; subscriptionId: string): Recallable =
  ## profilesQueryById
  ## Get the Profile for an Image.
  ##   imageId: string (required)
  ##          : The Image Id.
  ##   workspace: string (required)
  ##            : The name of the workspace.
  ##   resourceGroup: string (required)
  ##                : The Name of the resource group in which the workspace is located.
  ##   id: string (required)
  ##     : The Profile Id.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  var path_564189 = newJObject()
  add(path_564189, "imageId", newJString(imageId))
  add(path_564189, "workspace", newJString(workspace))
  add(path_564189, "resourceGroup", newJString(resourceGroup))
  add(path_564189, "id", newJString(id))
  add(path_564189, "subscriptionId", newJString(subscriptionId))
  result = call_564188.call(path_564189, nil, nil, nil, nil)

var profilesQueryById* = Call_ProfilesQueryById_564179(name: "profilesQueryById",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/modelmanagement/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.MachineLearningServices/workspaces/{workspace}/images/{imageId}/profiles/{id}",
    validator: validate_ProfilesQueryById_564180, base: "",
    url: url_ProfilesQueryById_564181, schemes: {Scheme.Https})
type
  Call_MlmodelsRegister_564209 = ref object of OpenApiRestCall_563548
proc url_MlmodelsRegister_564211(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroup" in path, "`resourceGroup` is a required path parameter"
  assert "workspace" in path, "`workspace` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/modelmanagement/v1.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroup"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspace"),
               (kind: ConstantSegment, value: "/models")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MlmodelsRegister_564210(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Register the model provided.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   workspace: JString (required)
  ##            : The name of the workspace.
  ##   resourceGroup: JString (required)
  ##                : The Name of the resource group in which the workspace is located.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `workspace` field"
  var valid_564212 = path.getOrDefault("workspace")
  valid_564212 = validateParameter(valid_564212, JString, required = true,
                                 default = nil)
  if valid_564212 != nil:
    section.add "workspace", valid_564212
  var valid_564213 = path.getOrDefault("resourceGroup")
  valid_564213 = validateParameter(valid_564213, JString, required = true,
                                 default = nil)
  if valid_564213 != nil:
    section.add "resourceGroup", valid_564213
  var valid_564214 = path.getOrDefault("subscriptionId")
  valid_564214 = validateParameter(valid_564214, JString, required = true,
                                 default = nil)
  if valid_564214 != nil:
    section.add "subscriptionId", valid_564214
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   model: JObject (required)
  ##        : The payload that is used to register the model.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564216: Call_MlmodelsRegister_564209; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Register the model provided.
  ## 
  let valid = call_564216.validator(path, query, header, formData, body)
  let scheme = call_564216.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564216.url(scheme.get, call_564216.host, call_564216.base,
                         call_564216.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564216, url, valid)

proc call*(call_564217: Call_MlmodelsRegister_564209; workspace: string;
          resourceGroup: string; subscriptionId: string; model: JsonNode): Recallable =
  ## mlmodelsRegister
  ## Register the model provided.
  ##   workspace: string (required)
  ##            : The name of the workspace.
  ##   resourceGroup: string (required)
  ##                : The Name of the resource group in which the workspace is located.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   model: JObject (required)
  ##        : The payload that is used to register the model.
  var path_564218 = newJObject()
  var body_564219 = newJObject()
  add(path_564218, "workspace", newJString(workspace))
  add(path_564218, "resourceGroup", newJString(resourceGroup))
  add(path_564218, "subscriptionId", newJString(subscriptionId))
  if model != nil:
    body_564219 = model
  result = call_564217.call(path_564218, nil, nil, nil, body_564219)

var mlmodelsRegister* = Call_MlmodelsRegister_564209(name: "mlmodelsRegister",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/modelmanagement/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.MachineLearningServices/workspaces/{workspace}/models",
    validator: validate_MlmodelsRegister_564210, base: "",
    url: url_MlmodelsRegister_564211, schemes: {Scheme.Https})
type
  Call_MlmodelsListQuery_564190 = ref object of OpenApiRestCall_563548
proc url_MlmodelsListQuery_564192(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroup" in path, "`resourceGroup` is a required path parameter"
  assert "workspace" in path, "`workspace` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/modelmanagement/v1.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroup"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspace"),
               (kind: ConstantSegment, value: "/models")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MlmodelsListQuery_564191(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## The result list can be filtered using tag and name. If no filter is passed, the query lists all the Models in the given workspace. The returned list is paginated and the count of items in each page is an optional parameter.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   workspace: JString (required)
  ##            : The name of the workspace.
  ##   resourceGroup: JString (required)
  ##                : The Name of the resource group in which the workspace is located.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `workspace` field"
  var valid_564193 = path.getOrDefault("workspace")
  valid_564193 = validateParameter(valid_564193, JString, required = true,
                                 default = nil)
  if valid_564193 != nil:
    section.add "workspace", valid_564193
  var valid_564194 = path.getOrDefault("resourceGroup")
  valid_564194 = validateParameter(valid_564194, JString, required = true,
                                 default = nil)
  if valid_564194 != nil:
    section.add "resourceGroup", valid_564194
  var valid_564195 = path.getOrDefault("subscriptionId")
  valid_564195 = validateParameter(valid_564195, JString, required = true,
                                 default = nil)
  if valid_564195 != nil:
    section.add "subscriptionId", valid_564195
  result.add "path", section
  ## parameters in `query` object:
  ##   framework: JString
  ##            : The framework.
  ##   name: JString
  ##       : The object name.
  ##   $skipToken: JString
  ##             : The continuation token to retrieve the next page.
  ##   tags: JString
  ##       : A set of tags with which to filter the returned models.
  ##             It is a comma separated string of tags key or tags key=value
  ##             Example: tagKey1,tagKey2,tagKey3=value3
  ##   description: JString
  ##              : The object description.
  ##   count: JInt
  ##        : The number of items to retrieve in a page.
  ##   orderBy: JString
  ##          : An option to specify how the models are ordered in the response.
  ##   properties: JString
  ##             : A set of properties with which to filter the returned models.
  ##             It is a comma separated string of properties key and/or properties key=value
  ##             Example: propKey1,propKey2,propKey3=value3
  ##   runId: JString
  ##        : The runId which created the model.
  section = newJObject()
  var valid_564196 = query.getOrDefault("framework")
  valid_564196 = validateParameter(valid_564196, JString, required = false,
                                 default = nil)
  if valid_564196 != nil:
    section.add "framework", valid_564196
  var valid_564197 = query.getOrDefault("name")
  valid_564197 = validateParameter(valid_564197, JString, required = false,
                                 default = nil)
  if valid_564197 != nil:
    section.add "name", valid_564197
  var valid_564198 = query.getOrDefault("$skipToken")
  valid_564198 = validateParameter(valid_564198, JString, required = false,
                                 default = nil)
  if valid_564198 != nil:
    section.add "$skipToken", valid_564198
  var valid_564199 = query.getOrDefault("tags")
  valid_564199 = validateParameter(valid_564199, JString, required = false,
                                 default = nil)
  if valid_564199 != nil:
    section.add "tags", valid_564199
  var valid_564200 = query.getOrDefault("description")
  valid_564200 = validateParameter(valid_564200, JString, required = false,
                                 default = nil)
  if valid_564200 != nil:
    section.add "description", valid_564200
  var valid_564201 = query.getOrDefault("count")
  valid_564201 = validateParameter(valid_564201, JInt, required = false, default = nil)
  if valid_564201 != nil:
    section.add "count", valid_564201
  var valid_564202 = query.getOrDefault("orderBy")
  valid_564202 = validateParameter(valid_564202, JString, required = false,
                                 default = newJString("CreatedAtDesc"))
  if valid_564202 != nil:
    section.add "orderBy", valid_564202
  var valid_564203 = query.getOrDefault("properties")
  valid_564203 = validateParameter(valid_564203, JString, required = false,
                                 default = nil)
  if valid_564203 != nil:
    section.add "properties", valid_564203
  var valid_564204 = query.getOrDefault("runId")
  valid_564204 = validateParameter(valid_564204, JString, required = false,
                                 default = nil)
  if valid_564204 != nil:
    section.add "runId", valid_564204
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564205: Call_MlmodelsListQuery_564190; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The result list can be filtered using tag and name. If no filter is passed, the query lists all the Models in the given workspace. The returned list is paginated and the count of items in each page is an optional parameter.
  ## 
  let valid = call_564205.validator(path, query, header, formData, body)
  let scheme = call_564205.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564205.url(scheme.get, call_564205.host, call_564205.base,
                         call_564205.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564205, url, valid)

proc call*(call_564206: Call_MlmodelsListQuery_564190; workspace: string;
          resourceGroup: string; subscriptionId: string; framework: string = "";
          name: string = ""; SkipToken: string = ""; tags: string = "";
          description: string = ""; count: int = 0; orderBy: string = "CreatedAtDesc";
          properties: string = ""; runId: string = ""): Recallable =
  ## mlmodelsListQuery
  ## The result list can be filtered using tag and name. If no filter is passed, the query lists all the Models in the given workspace. The returned list is paginated and the count of items in each page is an optional parameter.
  ##   framework: string
  ##            : The framework.
  ##   workspace: string (required)
  ##            : The name of the workspace.
  ##   name: string
  ##       : The object name.
  ##   SkipToken: string
  ##            : The continuation token to retrieve the next page.
  ##   tags: string
  ##       : A set of tags with which to filter the returned models.
  ##             It is a comma separated string of tags key or tags key=value
  ##             Example: tagKey1,tagKey2,tagKey3=value3
  ##   description: string
  ##              : The object description.
  ##   resourceGroup: string (required)
  ##                : The Name of the resource group in which the workspace is located.
  ##   count: int
  ##        : The number of items to retrieve in a page.
  ##   orderBy: string
  ##          : An option to specify how the models are ordered in the response.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   properties: string
  ##             : A set of properties with which to filter the returned models.
  ##             It is a comma separated string of properties key and/or properties key=value
  ##             Example: propKey1,propKey2,propKey3=value3
  ##   runId: string
  ##        : The runId which created the model.
  var path_564207 = newJObject()
  var query_564208 = newJObject()
  add(query_564208, "framework", newJString(framework))
  add(path_564207, "workspace", newJString(workspace))
  add(query_564208, "name", newJString(name))
  add(query_564208, "$skipToken", newJString(SkipToken))
  add(query_564208, "tags", newJString(tags))
  add(query_564208, "description", newJString(description))
  add(path_564207, "resourceGroup", newJString(resourceGroup))
  add(query_564208, "count", newJInt(count))
  add(query_564208, "orderBy", newJString(orderBy))
  add(path_564207, "subscriptionId", newJString(subscriptionId))
  add(query_564208, "properties", newJString(properties))
  add(query_564208, "runId", newJString(runId))
  result = call_564206.call(path_564207, query_564208, nil, nil, nil)

var mlmodelsListQuery* = Call_MlmodelsListQuery_564190(name: "mlmodelsListQuery",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/modelmanagement/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.MachineLearningServices/workspaces/{workspace}/models",
    validator: validate_MlmodelsListQuery_564191, base: "",
    url: url_MlmodelsListQuery_564192, schemes: {Scheme.Https})
type
  Call_MlmodelsQueryById_564220 = ref object of OpenApiRestCall_563548
proc url_MlmodelsQueryById_564222(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroup" in path, "`resourceGroup` is a required path parameter"
  assert "workspace" in path, "`workspace` is a required path parameter"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/modelmanagement/v1.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroup"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspace"),
               (kind: ConstantSegment, value: "/models/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MlmodelsQueryById_564221(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets a model by model id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   workspace: JString (required)
  ##            : The name of the workspace.
  ##   resourceGroup: JString (required)
  ##                : The Name of the resource group in which the workspace is located.
  ##   id: JString (required)
  ##     : The model id.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `workspace` field"
  var valid_564223 = path.getOrDefault("workspace")
  valid_564223 = validateParameter(valid_564223, JString, required = true,
                                 default = nil)
  if valid_564223 != nil:
    section.add "workspace", valid_564223
  var valid_564224 = path.getOrDefault("resourceGroup")
  valid_564224 = validateParameter(valid_564224, JString, required = true,
                                 default = nil)
  if valid_564224 != nil:
    section.add "resourceGroup", valid_564224
  var valid_564225 = path.getOrDefault("id")
  valid_564225 = validateParameter(valid_564225, JString, required = true,
                                 default = nil)
  if valid_564225 != nil:
    section.add "id", valid_564225
  var valid_564226 = path.getOrDefault("subscriptionId")
  valid_564226 = validateParameter(valid_564226, JString, required = true,
                                 default = nil)
  if valid_564226 != nil:
    section.add "subscriptionId", valid_564226
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564227: Call_MlmodelsQueryById_564220; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a model by model id.
  ## 
  let valid = call_564227.validator(path, query, header, formData, body)
  let scheme = call_564227.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564227.url(scheme.get, call_564227.host, call_564227.base,
                         call_564227.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564227, url, valid)

proc call*(call_564228: Call_MlmodelsQueryById_564220; workspace: string;
          resourceGroup: string; id: string; subscriptionId: string): Recallable =
  ## mlmodelsQueryById
  ## Gets a model by model id.
  ##   workspace: string (required)
  ##            : The name of the workspace.
  ##   resourceGroup: string (required)
  ##                : The Name of the resource group in which the workspace is located.
  ##   id: string (required)
  ##     : The model id.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  var path_564229 = newJObject()
  add(path_564229, "workspace", newJString(workspace))
  add(path_564229, "resourceGroup", newJString(resourceGroup))
  add(path_564229, "id", newJString(id))
  add(path_564229, "subscriptionId", newJString(subscriptionId))
  result = call_564228.call(path_564229, nil, nil, nil, nil)

var mlmodelsQueryById* = Call_MlmodelsQueryById_564220(name: "mlmodelsQueryById",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/modelmanagement/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.MachineLearningServices/workspaces/{workspace}/models/{id}",
    validator: validate_MlmodelsQueryById_564221, base: "",
    url: url_MlmodelsQueryById_564222, schemes: {Scheme.Https})
type
  Call_MlmodelsPatch_564240 = ref object of OpenApiRestCall_563548
proc url_MlmodelsPatch_564242(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroup" in path, "`resourceGroup` is a required path parameter"
  assert "workspace" in path, "`workspace` is a required path parameter"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/modelmanagement/v1.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroup"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspace"),
               (kind: ConstantSegment, value: "/models/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MlmodelsPatch_564241(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing model with the specified patch.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   workspace: JString (required)
  ##            : The name of the workspace.
  ##   resourceGroup: JString (required)
  ##                : The Name of the resource group in which the workspace is located.
  ##   id: JString (required)
  ##     : The model id.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `workspace` field"
  var valid_564243 = path.getOrDefault("workspace")
  valid_564243 = validateParameter(valid_564243, JString, required = true,
                                 default = nil)
  if valid_564243 != nil:
    section.add "workspace", valid_564243
  var valid_564244 = path.getOrDefault("resourceGroup")
  valid_564244 = validateParameter(valid_564244, JString, required = true,
                                 default = nil)
  if valid_564244 != nil:
    section.add "resourceGroup", valid_564244
  var valid_564245 = path.getOrDefault("id")
  valid_564245 = validateParameter(valid_564245, JString, required = true,
                                 default = nil)
  if valid_564245 != nil:
    section.add "id", valid_564245
  var valid_564246 = path.getOrDefault("subscriptionId")
  valid_564246 = validateParameter(valid_564246, JString, required = true,
                                 default = nil)
  if valid_564246 != nil:
    section.add "subscriptionId", valid_564246
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   patch: JArray (required)
  ##        : The payload that is used to patch the model.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JArray, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564248: Call_MlmodelsPatch_564240; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing model with the specified patch.
  ## 
  let valid = call_564248.validator(path, query, header, formData, body)
  let scheme = call_564248.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564248.url(scheme.get, call_564248.host, call_564248.base,
                         call_564248.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564248, url, valid)

proc call*(call_564249: Call_MlmodelsPatch_564240; workspace: string;
          resourceGroup: string; id: string; subscriptionId: string; patch: JsonNode): Recallable =
  ## mlmodelsPatch
  ## Updates an existing model with the specified patch.
  ##   workspace: string (required)
  ##            : The name of the workspace.
  ##   resourceGroup: string (required)
  ##                : The Name of the resource group in which the workspace is located.
  ##   id: string (required)
  ##     : The model id.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   patch: JArray (required)
  ##        : The payload that is used to patch the model.
  var path_564250 = newJObject()
  var body_564251 = newJObject()
  add(path_564250, "workspace", newJString(workspace))
  add(path_564250, "resourceGroup", newJString(resourceGroup))
  add(path_564250, "id", newJString(id))
  add(path_564250, "subscriptionId", newJString(subscriptionId))
  if patch != nil:
    body_564251 = patch
  result = call_564249.call(path_564250, nil, nil, nil, body_564251)

var mlmodelsPatch* = Call_MlmodelsPatch_564240(name: "mlmodelsPatch",
    meth: HttpMethod.HttpPatch, host: "azure.local", route: "/modelmanagement/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.MachineLearningServices/workspaces/{workspace}/models/{id}",
    validator: validate_MlmodelsPatch_564241, base: "", url: url_MlmodelsPatch_564242,
    schemes: {Scheme.Https})
type
  Call_MlmodelsDelete_564230 = ref object of OpenApiRestCall_563548
proc url_MlmodelsDelete_564232(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroup" in path, "`resourceGroup` is a required path parameter"
  assert "workspace" in path, "`workspace` is a required path parameter"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/modelmanagement/v1.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroup"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspace"),
               (kind: ConstantSegment, value: "/models/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MlmodelsDelete_564231(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Deletes a model if it exists.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   workspace: JString (required)
  ##            : The name of the workspace.
  ##   resourceGroup: JString (required)
  ##                : The Name of the resource group in which the workspace is located.
  ##   id: JString (required)
  ##     : The model id.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `workspace` field"
  var valid_564233 = path.getOrDefault("workspace")
  valid_564233 = validateParameter(valid_564233, JString, required = true,
                                 default = nil)
  if valid_564233 != nil:
    section.add "workspace", valid_564233
  var valid_564234 = path.getOrDefault("resourceGroup")
  valid_564234 = validateParameter(valid_564234, JString, required = true,
                                 default = nil)
  if valid_564234 != nil:
    section.add "resourceGroup", valid_564234
  var valid_564235 = path.getOrDefault("id")
  valid_564235 = validateParameter(valid_564235, JString, required = true,
                                 default = nil)
  if valid_564235 != nil:
    section.add "id", valid_564235
  var valid_564236 = path.getOrDefault("subscriptionId")
  valid_564236 = validateParameter(valid_564236, JString, required = true,
                                 default = nil)
  if valid_564236 != nil:
    section.add "subscriptionId", valid_564236
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564237: Call_MlmodelsDelete_564230; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a model if it exists.
  ## 
  let valid = call_564237.validator(path, query, header, formData, body)
  let scheme = call_564237.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564237.url(scheme.get, call_564237.host, call_564237.base,
                         call_564237.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564237, url, valid)

proc call*(call_564238: Call_MlmodelsDelete_564230; workspace: string;
          resourceGroup: string; id: string; subscriptionId: string): Recallable =
  ## mlmodelsDelete
  ## Deletes a model if it exists.
  ##   workspace: string (required)
  ##            : The name of the workspace.
  ##   resourceGroup: string (required)
  ##                : The Name of the resource group in which the workspace is located.
  ##   id: string (required)
  ##     : The model id.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  var path_564239 = newJObject()
  add(path_564239, "workspace", newJString(workspace))
  add(path_564239, "resourceGroup", newJString(resourceGroup))
  add(path_564239, "id", newJString(id))
  add(path_564239, "subscriptionId", newJString(subscriptionId))
  result = call_564238.call(path_564239, nil, nil, nil, nil)

var mlmodelsDelete* = Call_MlmodelsDelete_564230(name: "mlmodelsDelete",
    meth: HttpMethod.HttpDelete, host: "azure.local", route: "/modelmanagement/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.MachineLearningServices/workspaces/{workspace}/models/{id}",
    validator: validate_MlmodelsDelete_564231, base: "", url: url_MlmodelsDelete_564232,
    schemes: {Scheme.Https})
type
  Call_MlmodelsGetMetrics_564252 = ref object of OpenApiRestCall_563548
proc url_MlmodelsGetMetrics_564254(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroup" in path, "`resourceGroup` is a required path parameter"
  assert "workspace" in path, "`workspace` is a required path parameter"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/modelmanagement/v1.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroup"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspace"),
               (kind: ConstantSegment, value: "/models/"),
               (kind: VariableSegment, value: "id"),
               (kind: ConstantSegment, value: "/metrics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MlmodelsGetMetrics_564253(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## The operational events collected for the Model are returned.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   workspace: JString (required)
  ##            : The name of the workspace.
  ##   resourceGroup: JString (required)
  ##                : The Name of the resource group in which the workspace is located.
  ##   id: JString (required)
  ##     : The Model Id.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `workspace` field"
  var valid_564255 = path.getOrDefault("workspace")
  valid_564255 = validateParameter(valid_564255, JString, required = true,
                                 default = nil)
  if valid_564255 != nil:
    section.add "workspace", valid_564255
  var valid_564256 = path.getOrDefault("resourceGroup")
  valid_564256 = validateParameter(valid_564256, JString, required = true,
                                 default = nil)
  if valid_564256 != nil:
    section.add "resourceGroup", valid_564256
  var valid_564257 = path.getOrDefault("id")
  valid_564257 = validateParameter(valid_564257, JString, required = true,
                                 default = nil)
  if valid_564257 != nil:
    section.add "id", valid_564257
  var valid_564258 = path.getOrDefault("subscriptionId")
  valid_564258 = validateParameter(valid_564258, JString, required = true,
                                 default = nil)
  if valid_564258 != nil:
    section.add "subscriptionId", valid_564258
  result.add "path", section
  ## parameters in `query` object:
  ##   endDate: JString
  ##          : The end date from which to retrieve metrics, ISO 8601 literal format.
  ##   startDate: JString
  ##            : The start date from which to retrieve metrics, ISO 8601 literal format.
  section = newJObject()
  var valid_564259 = query.getOrDefault("endDate")
  valid_564259 = validateParameter(valid_564259, JString, required = false,
                                 default = nil)
  if valid_564259 != nil:
    section.add "endDate", valid_564259
  var valid_564260 = query.getOrDefault("startDate")
  valid_564260 = validateParameter(valid_564260, JString, required = false,
                                 default = nil)
  if valid_564260 != nil:
    section.add "startDate", valid_564260
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564261: Call_MlmodelsGetMetrics_564252; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operational events collected for the Model are returned.
  ## 
  let valid = call_564261.validator(path, query, header, formData, body)
  let scheme = call_564261.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564261.url(scheme.get, call_564261.host, call_564261.base,
                         call_564261.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564261, url, valid)

proc call*(call_564262: Call_MlmodelsGetMetrics_564252; workspace: string;
          resourceGroup: string; id: string; subscriptionId: string;
          endDate: string = ""; startDate: string = ""): Recallable =
  ## mlmodelsGetMetrics
  ## The operational events collected for the Model are returned.
  ##   workspace: string (required)
  ##            : The name of the workspace.
  ##   resourceGroup: string (required)
  ##                : The Name of the resource group in which the workspace is located.
  ##   id: string (required)
  ##     : The Model Id.
  ##   endDate: string
  ##          : The end date from which to retrieve metrics, ISO 8601 literal format.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   startDate: string
  ##            : The start date from which to retrieve metrics, ISO 8601 literal format.
  var path_564263 = newJObject()
  var query_564264 = newJObject()
  add(path_564263, "workspace", newJString(workspace))
  add(path_564263, "resourceGroup", newJString(resourceGroup))
  add(path_564263, "id", newJString(id))
  add(query_564264, "endDate", newJString(endDate))
  add(path_564263, "subscriptionId", newJString(subscriptionId))
  add(query_564264, "startDate", newJString(startDate))
  result = call_564262.call(path_564263, query_564264, nil, nil, nil)

var mlmodelsGetMetrics* = Call_MlmodelsGetMetrics_564252(
    name: "mlmodelsGetMetrics", meth: HttpMethod.HttpGet, host: "azure.local", route: "/modelmanagement/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.MachineLearningServices/workspaces/{workspace}/models/{id}/metrics",
    validator: validate_MlmodelsGetMetrics_564253, base: "",
    url: url_MlmodelsGetMetrics_564254, schemes: {Scheme.Https})
type
  Call_OperationsGet_564265 = ref object of OpenApiRestCall_563548
proc url_OperationsGet_564267(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroup" in path, "`resourceGroup` is a required path parameter"
  assert "workspace" in path, "`workspace` is a required path parameter"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/modelmanagement/v1.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroup"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspace"),
               (kind: ConstantSegment, value: "/operations/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_OperationsGet_564266(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the status of an async operation by operation id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   workspace: JString (required)
  ##            : The name of the workspace.
  ##   resourceGroup: JString (required)
  ##                : The Name of the resource group in which the workspace is located.
  ##   id: JString (required)
  ##     : The operation id.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `workspace` field"
  var valid_564268 = path.getOrDefault("workspace")
  valid_564268 = validateParameter(valid_564268, JString, required = true,
                                 default = nil)
  if valid_564268 != nil:
    section.add "workspace", valid_564268
  var valid_564269 = path.getOrDefault("resourceGroup")
  valid_564269 = validateParameter(valid_564269, JString, required = true,
                                 default = nil)
  if valid_564269 != nil:
    section.add "resourceGroup", valid_564269
  var valid_564270 = path.getOrDefault("id")
  valid_564270 = validateParameter(valid_564270, JString, required = true,
                                 default = nil)
  if valid_564270 != nil:
    section.add "id", valid_564270
  var valid_564271 = path.getOrDefault("subscriptionId")
  valid_564271 = validateParameter(valid_564271, JString, required = true,
                                 default = nil)
  if valid_564271 != nil:
    section.add "subscriptionId", valid_564271
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564272: Call_OperationsGet_564265; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the status of an async operation by operation id.
  ## 
  let valid = call_564272.validator(path, query, header, formData, body)
  let scheme = call_564272.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564272.url(scheme.get, call_564272.host, call_564272.base,
                         call_564272.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564272, url, valid)

proc call*(call_564273: Call_OperationsGet_564265; workspace: string;
          resourceGroup: string; id: string; subscriptionId: string): Recallable =
  ## operationsGet
  ## Get the status of an async operation by operation id.
  ##   workspace: string (required)
  ##            : The name of the workspace.
  ##   resourceGroup: string (required)
  ##                : The Name of the resource group in which the workspace is located.
  ##   id: string (required)
  ##     : The operation id.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  var path_564274 = newJObject()
  add(path_564274, "workspace", newJString(workspace))
  add(path_564274, "resourceGroup", newJString(resourceGroup))
  add(path_564274, "id", newJString(id))
  add(path_564274, "subscriptionId", newJString(subscriptionId))
  result = call_564273.call(path_564274, nil, nil, nil, nil)

var operationsGet* = Call_OperationsGet_564265(name: "operationsGet",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/modelmanagement/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.MachineLearningServices/workspaces/{workspace}/operations/{id}",
    validator: validate_OperationsGet_564266, base: "", url: url_OperationsGet_564267,
    schemes: {Scheme.Https})
type
  Call_ServicesCreate_564297 = ref object of OpenApiRestCall_563548
proc url_ServicesCreate_564299(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroup" in path, "`resourceGroup` is a required path parameter"
  assert "workspace" in path, "`workspace` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/modelmanagement/v1.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroup"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspace"),
               (kind: ConstantSegment, value: "/services")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesCreate_564298(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Create a Service with the specified payload.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   workspace: JString (required)
  ##            : The name of the workspace.
  ##   resourceGroup: JString (required)
  ##                : The Name of the resource group in which the workspace is located.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `workspace` field"
  var valid_564300 = path.getOrDefault("workspace")
  valid_564300 = validateParameter(valid_564300, JString, required = true,
                                 default = nil)
  if valid_564300 != nil:
    section.add "workspace", valid_564300
  var valid_564301 = path.getOrDefault("resourceGroup")
  valid_564301 = validateParameter(valid_564301, JString, required = true,
                                 default = nil)
  if valid_564301 != nil:
    section.add "resourceGroup", valid_564301
  var valid_564302 = path.getOrDefault("subscriptionId")
  valid_564302 = validateParameter(valid_564302, JString, required = true,
                                 default = nil)
  if valid_564302 != nil:
    section.add "subscriptionId", valid_564302
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   request: JObject (required)
  ##          : The payload that is used to create the Service.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564304: Call_ServicesCreate_564297; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a Service with the specified payload.
  ## 
  let valid = call_564304.validator(path, query, header, formData, body)
  let scheme = call_564304.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564304.url(scheme.get, call_564304.host, call_564304.base,
                         call_564304.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564304, url, valid)

proc call*(call_564305: Call_ServicesCreate_564297; workspace: string;
          resourceGroup: string; subscriptionId: string; request: JsonNode): Recallable =
  ## servicesCreate
  ## Create a Service with the specified payload.
  ##   workspace: string (required)
  ##            : The name of the workspace.
  ##   resourceGroup: string (required)
  ##                : The Name of the resource group in which the workspace is located.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   request: JObject (required)
  ##          : The payload that is used to create the Service.
  var path_564306 = newJObject()
  var body_564307 = newJObject()
  add(path_564306, "workspace", newJString(workspace))
  add(path_564306, "resourceGroup", newJString(resourceGroup))
  add(path_564306, "subscriptionId", newJString(subscriptionId))
  if request != nil:
    body_564307 = request
  result = call_564305.call(path_564306, nil, nil, nil, body_564307)

var servicesCreate* = Call_ServicesCreate_564297(name: "servicesCreate",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/modelmanagement/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.MachineLearningServices/workspaces/{workspace}/services",
    validator: validate_ServicesCreate_564298, base: "", url: url_ServicesCreate_564299,
    schemes: {Scheme.Https})
type
  Call_ServicesListQuery_564275 = ref object of OpenApiRestCall_563548
proc url_ServicesListQuery_564277(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroup" in path, "`resourceGroup` is a required path parameter"
  assert "workspace" in path, "`workspace` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/modelmanagement/v1.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroup"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspace"),
               (kind: ConstantSegment, value: "/services")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesListQuery_564276(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## If no filter is passed, the query lists all Services in the Workspace. The returned list is paginated and the count of item in each page is an optional parameter.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   workspace: JString (required)
  ##            : The name of the workspace.
  ##   resourceGroup: JString (required)
  ##                : The Name of the resource group in which the workspace is located.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `workspace` field"
  var valid_564278 = path.getOrDefault("workspace")
  valid_564278 = validateParameter(valid_564278, JString, required = true,
                                 default = nil)
  if valid_564278 != nil:
    section.add "workspace", valid_564278
  var valid_564279 = path.getOrDefault("resourceGroup")
  valid_564279 = validateParameter(valid_564279, JString, required = true,
                                 default = nil)
  if valid_564279 != nil:
    section.add "resourceGroup", valid_564279
  var valid_564280 = path.getOrDefault("subscriptionId")
  valid_564280 = validateParameter(valid_564280, JString, required = true,
                                 default = nil)
  if valid_564280 != nil:
    section.add "subscriptionId", valid_564280
  result.add "path", section
  ## parameters in `query` object:
  ##   imageId: JString
  ##          : The Image Id.
  ##   name: JString
  ##       : The object name.
  ##   $skipToken: JString
  ##             : The continuation token to retrieve the next page.
  ##   tags: JString
  ##       : A set of tags with which to filter the returned models.
  ##             It is a comma separated string of tags key or tags key=value
  ##             Example: tagKey1,tagKey2,tagKey3=value3
  ##   count: JInt
  ##        : The number of items to retrieve in a page.
  ##   imageName: JString
  ##            : The Image name.
  ##   expand: JBool
  ##         : Set to True to include Model details.
  ##   orderby: JString
  ##          : The option to order the response.
  ##   computeType: JString
  ##              : The compute environment type.
  ##   modelName: JString
  ##            : The Model name.
  ##   modelId: JString
  ##          : The Model Id.
  ##   properties: JString
  ##             : A set of properties with which to filter the returned models.
  ##             It is a comma separated string of properties key and/or properties key=value
  ##             Example: propKey1,propKey2,propKey3=value3
  section = newJObject()
  var valid_564281 = query.getOrDefault("imageId")
  valid_564281 = validateParameter(valid_564281, JString, required = false,
                                 default = nil)
  if valid_564281 != nil:
    section.add "imageId", valid_564281
  var valid_564282 = query.getOrDefault("name")
  valid_564282 = validateParameter(valid_564282, JString, required = false,
                                 default = nil)
  if valid_564282 != nil:
    section.add "name", valid_564282
  var valid_564283 = query.getOrDefault("$skipToken")
  valid_564283 = validateParameter(valid_564283, JString, required = false,
                                 default = nil)
  if valid_564283 != nil:
    section.add "$skipToken", valid_564283
  var valid_564284 = query.getOrDefault("tags")
  valid_564284 = validateParameter(valid_564284, JString, required = false,
                                 default = nil)
  if valid_564284 != nil:
    section.add "tags", valid_564284
  var valid_564285 = query.getOrDefault("count")
  valid_564285 = validateParameter(valid_564285, JInt, required = false, default = nil)
  if valid_564285 != nil:
    section.add "count", valid_564285
  var valid_564286 = query.getOrDefault("imageName")
  valid_564286 = validateParameter(valid_564286, JString, required = false,
                                 default = nil)
  if valid_564286 != nil:
    section.add "imageName", valid_564286
  var valid_564287 = query.getOrDefault("expand")
  valid_564287 = validateParameter(valid_564287, JBool, required = false,
                                 default = newJBool(false))
  if valid_564287 != nil:
    section.add "expand", valid_564287
  var valid_564288 = query.getOrDefault("orderby")
  valid_564288 = validateParameter(valid_564288, JString, required = false,
                                 default = newJString("UpdatedAtDesc"))
  if valid_564288 != nil:
    section.add "orderby", valid_564288
  var valid_564289 = query.getOrDefault("computeType")
  valid_564289 = validateParameter(valid_564289, JString, required = false,
                                 default = nil)
  if valid_564289 != nil:
    section.add "computeType", valid_564289
  var valid_564290 = query.getOrDefault("modelName")
  valid_564290 = validateParameter(valid_564290, JString, required = false,
                                 default = nil)
  if valid_564290 != nil:
    section.add "modelName", valid_564290
  var valid_564291 = query.getOrDefault("modelId")
  valid_564291 = validateParameter(valid_564291, JString, required = false,
                                 default = nil)
  if valid_564291 != nil:
    section.add "modelId", valid_564291
  var valid_564292 = query.getOrDefault("properties")
  valid_564292 = validateParameter(valid_564292, JString, required = false,
                                 default = nil)
  if valid_564292 != nil:
    section.add "properties", valid_564292
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564293: Call_ServicesListQuery_564275; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## If no filter is passed, the query lists all Services in the Workspace. The returned list is paginated and the count of item in each page is an optional parameter.
  ## 
  let valid = call_564293.validator(path, query, header, formData, body)
  let scheme = call_564293.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564293.url(scheme.get, call_564293.host, call_564293.base,
                         call_564293.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564293, url, valid)

proc call*(call_564294: Call_ServicesListQuery_564275; workspace: string;
          resourceGroup: string; subscriptionId: string; imageId: string = "";
          name: string = ""; SkipToken: string = ""; tags: string = ""; count: int = 0;
          imageName: string = ""; expand: bool = false;
          orderby: string = "UpdatedAtDesc"; computeType: string = "";
          modelName: string = ""; modelId: string = ""; properties: string = ""): Recallable =
  ## servicesListQuery
  ## If no filter is passed, the query lists all Services in the Workspace. The returned list is paginated and the count of item in each page is an optional parameter.
  ##   workspace: string (required)
  ##            : The name of the workspace.
  ##   imageId: string
  ##          : The Image Id.
  ##   name: string
  ##       : The object name.
  ##   SkipToken: string
  ##            : The continuation token to retrieve the next page.
  ##   tags: string
  ##       : A set of tags with which to filter the returned models.
  ##             It is a comma separated string of tags key or tags key=value
  ##             Example: tagKey1,tagKey2,tagKey3=value3
  ##   resourceGroup: string (required)
  ##                : The Name of the resource group in which the workspace is located.
  ##   count: int
  ##        : The number of items to retrieve in a page.
  ##   imageName: string
  ##            : The Image name.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   expand: bool
  ##         : Set to True to include Model details.
  ##   orderby: string
  ##          : The option to order the response.
  ##   computeType: string
  ##              : The compute environment type.
  ##   modelName: string
  ##            : The Model name.
  ##   modelId: string
  ##          : The Model Id.
  ##   properties: string
  ##             : A set of properties with which to filter the returned models.
  ##             It is a comma separated string of properties key and/or properties key=value
  ##             Example: propKey1,propKey2,propKey3=value3
  var path_564295 = newJObject()
  var query_564296 = newJObject()
  add(path_564295, "workspace", newJString(workspace))
  add(query_564296, "imageId", newJString(imageId))
  add(query_564296, "name", newJString(name))
  add(query_564296, "$skipToken", newJString(SkipToken))
  add(query_564296, "tags", newJString(tags))
  add(path_564295, "resourceGroup", newJString(resourceGroup))
  add(query_564296, "count", newJInt(count))
  add(query_564296, "imageName", newJString(imageName))
  add(path_564295, "subscriptionId", newJString(subscriptionId))
  add(query_564296, "expand", newJBool(expand))
  add(query_564296, "orderby", newJString(orderby))
  add(query_564296, "computeType", newJString(computeType))
  add(query_564296, "modelName", newJString(modelName))
  add(query_564296, "modelId", newJString(modelId))
  add(query_564296, "properties", newJString(properties))
  result = call_564294.call(path_564295, query_564296, nil, nil, nil)

var servicesListQuery* = Call_ServicesListQuery_564275(name: "servicesListQuery",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/modelmanagement/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.MachineLearningServices/workspaces/{workspace}/services",
    validator: validate_ServicesListQuery_564276, base: "",
    url: url_ServicesListQuery_564277, schemes: {Scheme.Https})
type
  Call_ServicesQueryById_564308 = ref object of OpenApiRestCall_563548
proc url_ServicesQueryById_564310(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroup" in path, "`resourceGroup` is a required path parameter"
  assert "workspace" in path, "`workspace` is a required path parameter"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/modelmanagement/v1.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroup"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspace"),
               (kind: ConstantSegment, value: "/services/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesQueryById_564309(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Get a Service by Id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   workspace: JString (required)
  ##            : The name of the workspace.
  ##   resourceGroup: JString (required)
  ##                : The Name of the resource group in which the workspace is located.
  ##   id: JString (required)
  ##     : The Service Id.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `workspace` field"
  var valid_564311 = path.getOrDefault("workspace")
  valid_564311 = validateParameter(valid_564311, JString, required = true,
                                 default = nil)
  if valid_564311 != nil:
    section.add "workspace", valid_564311
  var valid_564312 = path.getOrDefault("resourceGroup")
  valid_564312 = validateParameter(valid_564312, JString, required = true,
                                 default = nil)
  if valid_564312 != nil:
    section.add "resourceGroup", valid_564312
  var valid_564313 = path.getOrDefault("id")
  valid_564313 = validateParameter(valid_564313, JString, required = true,
                                 default = nil)
  if valid_564313 != nil:
    section.add "id", valid_564313
  var valid_564314 = path.getOrDefault("subscriptionId")
  valid_564314 = validateParameter(valid_564314, JString, required = true,
                                 default = nil)
  if valid_564314 != nil:
    section.add "subscriptionId", valid_564314
  result.add "path", section
  ## parameters in `query` object:
  ##   expand: JBool
  ##         : Set to True to include Model details.
  section = newJObject()
  var valid_564315 = query.getOrDefault("expand")
  valid_564315 = validateParameter(valid_564315, JBool, required = false,
                                 default = newJBool(false))
  if valid_564315 != nil:
    section.add "expand", valid_564315
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564316: Call_ServicesQueryById_564308; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a Service by Id.
  ## 
  let valid = call_564316.validator(path, query, header, formData, body)
  let scheme = call_564316.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564316.url(scheme.get, call_564316.host, call_564316.base,
                         call_564316.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564316, url, valid)

proc call*(call_564317: Call_ServicesQueryById_564308; workspace: string;
          resourceGroup: string; id: string; subscriptionId: string;
          expand: bool = false): Recallable =
  ## servicesQueryById
  ## Get a Service by Id.
  ##   workspace: string (required)
  ##            : The name of the workspace.
  ##   resourceGroup: string (required)
  ##                : The Name of the resource group in which the workspace is located.
  ##   id: string (required)
  ##     : The Service Id.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   expand: bool
  ##         : Set to True to include Model details.
  var path_564318 = newJObject()
  var query_564319 = newJObject()
  add(path_564318, "workspace", newJString(workspace))
  add(path_564318, "resourceGroup", newJString(resourceGroup))
  add(path_564318, "id", newJString(id))
  add(path_564318, "subscriptionId", newJString(subscriptionId))
  add(query_564319, "expand", newJBool(expand))
  result = call_564317.call(path_564318, query_564319, nil, nil, nil)

var servicesQueryById* = Call_ServicesQueryById_564308(name: "servicesQueryById",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/modelmanagement/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.MachineLearningServices/workspaces/{workspace}/services/{id}",
    validator: validate_ServicesQueryById_564309, base: "",
    url: url_ServicesQueryById_564310, schemes: {Scheme.Https})
type
  Call_ServicesPatch_564330 = ref object of OpenApiRestCall_563548
proc url_ServicesPatch_564332(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroup" in path, "`resourceGroup` is a required path parameter"
  assert "workspace" in path, "`workspace` is a required path parameter"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/modelmanagement/v1.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroup"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspace"),
               (kind: ConstantSegment, value: "/services/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesPatch_564331(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Patch a specific Service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   workspace: JString (required)
  ##            : The name of the workspace.
  ##   resourceGroup: JString (required)
  ##                : The Name of the resource group in which the workspace is located.
  ##   id: JString (required)
  ##     : The Service Id.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `workspace` field"
  var valid_564333 = path.getOrDefault("workspace")
  valid_564333 = validateParameter(valid_564333, JString, required = true,
                                 default = nil)
  if valid_564333 != nil:
    section.add "workspace", valid_564333
  var valid_564334 = path.getOrDefault("resourceGroup")
  valid_564334 = validateParameter(valid_564334, JString, required = true,
                                 default = nil)
  if valid_564334 != nil:
    section.add "resourceGroup", valid_564334
  var valid_564335 = path.getOrDefault("id")
  valid_564335 = validateParameter(valid_564335, JString, required = true,
                                 default = nil)
  if valid_564335 != nil:
    section.add "id", valid_564335
  var valid_564336 = path.getOrDefault("subscriptionId")
  valid_564336 = validateParameter(valid_564336, JString, required = true,
                                 default = nil)
  if valid_564336 != nil:
    section.add "subscriptionId", valid_564336
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   patch: JArray (required)
  ##        : The payload that is used to patch the Service.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JArray, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564338: Call_ServicesPatch_564330; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Patch a specific Service.
  ## 
  let valid = call_564338.validator(path, query, header, formData, body)
  let scheme = call_564338.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564338.url(scheme.get, call_564338.host, call_564338.base,
                         call_564338.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564338, url, valid)

proc call*(call_564339: Call_ServicesPatch_564330; workspace: string;
          resourceGroup: string; id: string; subscriptionId: string; patch: JsonNode): Recallable =
  ## servicesPatch
  ## Patch a specific Service.
  ##   workspace: string (required)
  ##            : The name of the workspace.
  ##   resourceGroup: string (required)
  ##                : The Name of the resource group in which the workspace is located.
  ##   id: string (required)
  ##     : The Service Id.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   patch: JArray (required)
  ##        : The payload that is used to patch the Service.
  var path_564340 = newJObject()
  var body_564341 = newJObject()
  add(path_564340, "workspace", newJString(workspace))
  add(path_564340, "resourceGroup", newJString(resourceGroup))
  add(path_564340, "id", newJString(id))
  add(path_564340, "subscriptionId", newJString(subscriptionId))
  if patch != nil:
    body_564341 = patch
  result = call_564339.call(path_564340, nil, nil, nil, body_564341)

var servicesPatch* = Call_ServicesPatch_564330(name: "servicesPatch",
    meth: HttpMethod.HttpPatch, host: "azure.local", route: "/modelmanagement/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.MachineLearningServices/workspaces/{workspace}/services/{id}",
    validator: validate_ServicesPatch_564331, base: "", url: url_ServicesPatch_564332,
    schemes: {Scheme.Https})
type
  Call_ServicesDelete_564320 = ref object of OpenApiRestCall_563548
proc url_ServicesDelete_564322(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroup" in path, "`resourceGroup` is a required path parameter"
  assert "workspace" in path, "`workspace` is a required path parameter"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/modelmanagement/v1.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroup"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspace"),
               (kind: ConstantSegment, value: "/services/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesDelete_564321(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Delete a specific Service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   workspace: JString (required)
  ##            : The name of the workspace.
  ##   resourceGroup: JString (required)
  ##                : The Name of the resource group in which the workspace is located.
  ##   id: JString (required)
  ##     : The Service Id.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `workspace` field"
  var valid_564323 = path.getOrDefault("workspace")
  valid_564323 = validateParameter(valid_564323, JString, required = true,
                                 default = nil)
  if valid_564323 != nil:
    section.add "workspace", valid_564323
  var valid_564324 = path.getOrDefault("resourceGroup")
  valid_564324 = validateParameter(valid_564324, JString, required = true,
                                 default = nil)
  if valid_564324 != nil:
    section.add "resourceGroup", valid_564324
  var valid_564325 = path.getOrDefault("id")
  valid_564325 = validateParameter(valid_564325, JString, required = true,
                                 default = nil)
  if valid_564325 != nil:
    section.add "id", valid_564325
  var valid_564326 = path.getOrDefault("subscriptionId")
  valid_564326 = validateParameter(valid_564326, JString, required = true,
                                 default = nil)
  if valid_564326 != nil:
    section.add "subscriptionId", valid_564326
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564327: Call_ServicesDelete_564320; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a specific Service.
  ## 
  let valid = call_564327.validator(path, query, header, formData, body)
  let scheme = call_564327.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564327.url(scheme.get, call_564327.host, call_564327.base,
                         call_564327.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564327, url, valid)

proc call*(call_564328: Call_ServicesDelete_564320; workspace: string;
          resourceGroup: string; id: string; subscriptionId: string): Recallable =
  ## servicesDelete
  ## Delete a specific Service.
  ##   workspace: string (required)
  ##            : The name of the workspace.
  ##   resourceGroup: string (required)
  ##                : The Name of the resource group in which the workspace is located.
  ##   id: string (required)
  ##     : The Service Id.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  var path_564329 = newJObject()
  add(path_564329, "workspace", newJString(workspace))
  add(path_564329, "resourceGroup", newJString(resourceGroup))
  add(path_564329, "id", newJString(id))
  add(path_564329, "subscriptionId", newJString(subscriptionId))
  result = call_564328.call(path_564329, nil, nil, nil, nil)

var servicesDelete* = Call_ServicesDelete_564320(name: "servicesDelete",
    meth: HttpMethod.HttpDelete, host: "azure.local", route: "/modelmanagement/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.MachineLearningServices/workspaces/{workspace}/services/{id}",
    validator: validate_ServicesDelete_564321, base: "", url: url_ServicesDelete_564322,
    schemes: {Scheme.Https})
type
  Call_ServicesListServiceKeys_564342 = ref object of OpenApiRestCall_563548
proc url_ServicesListServiceKeys_564344(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroup" in path, "`resourceGroup` is a required path parameter"
  assert "workspace" in path, "`workspace` is a required path parameter"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/modelmanagement/v1.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroup"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspace"),
               (kind: ConstantSegment, value: "/services/"),
               (kind: VariableSegment, value: "id"),
               (kind: ConstantSegment, value: "/listkeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesListServiceKeys_564343(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of Service keys.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   workspace: JString (required)
  ##            : The name of the workspace.
  ##   resourceGroup: JString (required)
  ##                : The Name of the resource group in which the workspace is located.
  ##   id: JString (required)
  ##     : The Service Id.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `workspace` field"
  var valid_564345 = path.getOrDefault("workspace")
  valid_564345 = validateParameter(valid_564345, JString, required = true,
                                 default = nil)
  if valid_564345 != nil:
    section.add "workspace", valid_564345
  var valid_564346 = path.getOrDefault("resourceGroup")
  valid_564346 = validateParameter(valid_564346, JString, required = true,
                                 default = nil)
  if valid_564346 != nil:
    section.add "resourceGroup", valid_564346
  var valid_564347 = path.getOrDefault("id")
  valid_564347 = validateParameter(valid_564347, JString, required = true,
                                 default = nil)
  if valid_564347 != nil:
    section.add "id", valid_564347
  var valid_564348 = path.getOrDefault("subscriptionId")
  valid_564348 = validateParameter(valid_564348, JString, required = true,
                                 default = nil)
  if valid_564348 != nil:
    section.add "subscriptionId", valid_564348
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564349: Call_ServicesListServiceKeys_564342; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of Service keys.
  ## 
  let valid = call_564349.validator(path, query, header, formData, body)
  let scheme = call_564349.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564349.url(scheme.get, call_564349.host, call_564349.base,
                         call_564349.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564349, url, valid)

proc call*(call_564350: Call_ServicesListServiceKeys_564342; workspace: string;
          resourceGroup: string; id: string; subscriptionId: string): Recallable =
  ## servicesListServiceKeys
  ## Gets a list of Service keys.
  ##   workspace: string (required)
  ##            : The name of the workspace.
  ##   resourceGroup: string (required)
  ##                : The Name of the resource group in which the workspace is located.
  ##   id: string (required)
  ##     : The Service Id.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  var path_564351 = newJObject()
  add(path_564351, "workspace", newJString(workspace))
  add(path_564351, "resourceGroup", newJString(resourceGroup))
  add(path_564351, "id", newJString(id))
  add(path_564351, "subscriptionId", newJString(subscriptionId))
  result = call_564350.call(path_564351, nil, nil, nil, nil)

var servicesListServiceKeys* = Call_ServicesListServiceKeys_564342(
    name: "servicesListServiceKeys", meth: HttpMethod.HttpPost, host: "azure.local", route: "/modelmanagement/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.MachineLearningServices/workspaces/{workspace}/services/{id}/listkeys",
    validator: validate_ServicesListServiceKeys_564343, base: "",
    url: url_ServicesListServiceKeys_564344, schemes: {Scheme.Https})
type
  Call_ServicesRegenerateServiceKeys_564352 = ref object of OpenApiRestCall_563548
proc url_ServicesRegenerateServiceKeys_564354(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroup" in path, "`resourceGroup` is a required path parameter"
  assert "workspace" in path, "`workspace` is a required path parameter"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/modelmanagement/v1.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroup"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspace"),
               (kind: ConstantSegment, value: "/services/"),
               (kind: VariableSegment, value: "id"),
               (kind: ConstantSegment, value: "/regenerateKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesRegenerateServiceKeys_564353(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerate and return the Service keys.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   workspace: JString (required)
  ##            : The name of the workspace.
  ##   resourceGroup: JString (required)
  ##                : The Name of the resource group in which the workspace is located.
  ##   id: JString (required)
  ##     : The Service Id.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `workspace` field"
  var valid_564355 = path.getOrDefault("workspace")
  valid_564355 = validateParameter(valid_564355, JString, required = true,
                                 default = nil)
  if valid_564355 != nil:
    section.add "workspace", valid_564355
  var valid_564356 = path.getOrDefault("resourceGroup")
  valid_564356 = validateParameter(valid_564356, JString, required = true,
                                 default = nil)
  if valid_564356 != nil:
    section.add "resourceGroup", valid_564356
  var valid_564357 = path.getOrDefault("id")
  valid_564357 = validateParameter(valid_564357, JString, required = true,
                                 default = nil)
  if valid_564357 != nil:
    section.add "id", valid_564357
  var valid_564358 = path.getOrDefault("subscriptionId")
  valid_564358 = validateParameter(valid_564358, JString, required = true,
                                 default = nil)
  if valid_564358 != nil:
    section.add "subscriptionId", valid_564358
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   request: JObject (required)
  ##          : The payload that is used to regenerate keys.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564360: Call_ServicesRegenerateServiceKeys_564352; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Regenerate and return the Service keys.
  ## 
  let valid = call_564360.validator(path, query, header, formData, body)
  let scheme = call_564360.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564360.url(scheme.get, call_564360.host, call_564360.base,
                         call_564360.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564360, url, valid)

proc call*(call_564361: Call_ServicesRegenerateServiceKeys_564352;
          workspace: string; resourceGroup: string; id: string;
          subscriptionId: string; request: JsonNode): Recallable =
  ## servicesRegenerateServiceKeys
  ## Regenerate and return the Service keys.
  ##   workspace: string (required)
  ##            : The name of the workspace.
  ##   resourceGroup: string (required)
  ##                : The Name of the resource group in which the workspace is located.
  ##   id: string (required)
  ##     : The Service Id.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  ##   request: JObject (required)
  ##          : The payload that is used to regenerate keys.
  var path_564362 = newJObject()
  var body_564363 = newJObject()
  add(path_564362, "workspace", newJString(workspace))
  add(path_564362, "resourceGroup", newJString(resourceGroup))
  add(path_564362, "id", newJString(id))
  add(path_564362, "subscriptionId", newJString(subscriptionId))
  if request != nil:
    body_564363 = request
  result = call_564361.call(path_564362, nil, nil, nil, body_564363)

var servicesRegenerateServiceKeys* = Call_ServicesRegenerateServiceKeys_564352(
    name: "servicesRegenerateServiceKeys", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/modelmanagement/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.MachineLearningServices/workspaces/{workspace}/services/{id}/regenerateKeys",
    validator: validate_ServicesRegenerateServiceKeys_564353, base: "",
    url: url_ServicesRegenerateServiceKeys_564354, schemes: {Scheme.Https})
type
  Call_ServicesGetServiceToken_564364 = ref object of OpenApiRestCall_563548
proc url_ServicesGetServiceToken_564366(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroup" in path, "`resourceGroup` is a required path parameter"
  assert "workspace" in path, "`workspace` is a required path parameter"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/modelmanagement/v1.0/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroup"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningServices/workspaces/"),
               (kind: VariableSegment, value: "workspace"),
               (kind: ConstantSegment, value: "/services/"),
               (kind: VariableSegment, value: "id"),
               (kind: ConstantSegment, value: "/token")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesGetServiceToken_564365(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets access token that can be used for calling service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   workspace: JString (required)
  ##            : The name of the workspace.
  ##   resourceGroup: JString (required)
  ##                : The Name of the resource group in which the workspace is located.
  ##   id: JString (required)
  ##     : The Service Id.
  ##   subscriptionId: JString (required)
  ##                 : The Azure Subscription ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `workspace` field"
  var valid_564367 = path.getOrDefault("workspace")
  valid_564367 = validateParameter(valid_564367, JString, required = true,
                                 default = nil)
  if valid_564367 != nil:
    section.add "workspace", valid_564367
  var valid_564368 = path.getOrDefault("resourceGroup")
  valid_564368 = validateParameter(valid_564368, JString, required = true,
                                 default = nil)
  if valid_564368 != nil:
    section.add "resourceGroup", valid_564368
  var valid_564369 = path.getOrDefault("id")
  valid_564369 = validateParameter(valid_564369, JString, required = true,
                                 default = nil)
  if valid_564369 != nil:
    section.add "id", valid_564369
  var valid_564370 = path.getOrDefault("subscriptionId")
  valid_564370 = validateParameter(valid_564370, JString, required = true,
                                 default = nil)
  if valid_564370 != nil:
    section.add "subscriptionId", valid_564370
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564371: Call_ServicesGetServiceToken_564364; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets access token that can be used for calling service.
  ## 
  let valid = call_564371.validator(path, query, header, formData, body)
  let scheme = call_564371.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564371.url(scheme.get, call_564371.host, call_564371.base,
                         call_564371.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564371, url, valid)

proc call*(call_564372: Call_ServicesGetServiceToken_564364; workspace: string;
          resourceGroup: string; id: string; subscriptionId: string): Recallable =
  ## servicesGetServiceToken
  ## Gets access token that can be used for calling service.
  ##   workspace: string (required)
  ##            : The name of the workspace.
  ##   resourceGroup: string (required)
  ##                : The Name of the resource group in which the workspace is located.
  ##   id: string (required)
  ##     : The Service Id.
  ##   subscriptionId: string (required)
  ##                 : The Azure Subscription ID.
  var path_564373 = newJObject()
  add(path_564373, "workspace", newJString(workspace))
  add(path_564373, "resourceGroup", newJString(resourceGroup))
  add(path_564373, "id", newJString(id))
  add(path_564373, "subscriptionId", newJString(subscriptionId))
  result = call_564372.call(path_564373, nil, nil, nil, nil)

var servicesGetServiceToken* = Call_ServicesGetServiceToken_564364(
    name: "servicesGetServiceToken", meth: HttpMethod.HttpPost, host: "azure.local", route: "/modelmanagement/v1.0/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.MachineLearningServices/workspaces/{workspace}/services/{id}/token",
    validator: validate_ServicesGetServiceToken_564365, base: "",
    url: url_ServicesGetServiceToken_564366, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
