
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: Azure Log Analytics Query Packs
## version: 2019-09-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## Azure Log Analytics API reference for management of saved Queries within Query Packs.
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
  macServiceName = "applicationinsights-QueryPackQueries_API"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_QueriesList_573880 = ref object of OpenApiRestCall_573658
proc url_QueriesList_573882(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "queryPackName" in path, "`queryPackName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/microsoft.insights/queryPacks/"),
               (kind: VariableSegment, value: "queryPackName"),
               (kind: ConstantSegment, value: "/queries")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_QueriesList_573881(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of Queries defined within a Log Analytics QueryPack.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   queryPackName: JString (required)
  ##                : The name of the Log Analytics QueryPack resource.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574056 = path.getOrDefault("resourceGroupName")
  valid_574056 = validateParameter(valid_574056, JString, required = true,
                                 default = nil)
  if valid_574056 != nil:
    section.add "resourceGroupName", valid_574056
  var valid_574057 = path.getOrDefault("queryPackName")
  valid_574057 = validateParameter(valid_574057, JString, required = true,
                                 default = nil)
  if valid_574057 != nil:
    section.add "queryPackName", valid_574057
  var valid_574058 = path.getOrDefault("subscriptionId")
  valid_574058 = validateParameter(valid_574058, JString, required = true,
                                 default = nil)
  if valid_574058 != nil:
    section.add "subscriptionId", valid_574058
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   includeBody: JBool
  ##              : Flag indicating whether or not to return the body of each applicable query. If false, only return the query information.
  ##   $top: JInt
  ##       : Maximum items returned in page.
  ##   $skipToken: JString
  ##             : Base64 encoded token used to fetch the next page of items. Default is null.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574059 = query.getOrDefault("api-version")
  valid_574059 = validateParameter(valid_574059, JString, required = true,
                                 default = nil)
  if valid_574059 != nil:
    section.add "api-version", valid_574059
  var valid_574060 = query.getOrDefault("includeBody")
  valid_574060 = validateParameter(valid_574060, JBool, required = false, default = nil)
  if valid_574060 != nil:
    section.add "includeBody", valid_574060
  var valid_574061 = query.getOrDefault("$top")
  valid_574061 = validateParameter(valid_574061, JInt, required = false, default = nil)
  if valid_574061 != nil:
    section.add "$top", valid_574061
  var valid_574062 = query.getOrDefault("$skipToken")
  valid_574062 = validateParameter(valid_574062, JString, required = false,
                                 default = nil)
  if valid_574062 != nil:
    section.add "$skipToken", valid_574062
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574085: Call_QueriesList_573880; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of Queries defined within a Log Analytics QueryPack.
  ## 
  let valid = call_574085.validator(path, query, header, formData, body)
  let scheme = call_574085.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574085.url(scheme.get, call_574085.host, call_574085.base,
                         call_574085.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574085, url, valid)

proc call*(call_574156: Call_QueriesList_573880; resourceGroupName: string;
          apiVersion: string; queryPackName: string; subscriptionId: string;
          includeBody: bool = false; Top: int = 0; SkipToken: string = ""): Recallable =
  ## queriesList
  ## Gets a list of Queries defined within a Log Analytics QueryPack.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   queryPackName: string (required)
  ##                : The name of the Log Analytics QueryPack resource.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   includeBody: bool
  ##              : Flag indicating whether or not to return the body of each applicable query. If false, only return the query information.
  ##   Top: int
  ##      : Maximum items returned in page.
  ##   SkipToken: string
  ##            : Base64 encoded token used to fetch the next page of items. Default is null.
  var path_574157 = newJObject()
  var query_574159 = newJObject()
  add(path_574157, "resourceGroupName", newJString(resourceGroupName))
  add(query_574159, "api-version", newJString(apiVersion))
  add(path_574157, "queryPackName", newJString(queryPackName))
  add(path_574157, "subscriptionId", newJString(subscriptionId))
  add(query_574159, "includeBody", newJBool(includeBody))
  add(query_574159, "$top", newJInt(Top))
  add(query_574159, "$skipToken", newJString(SkipToken))
  result = call_574156.call(path_574157, query_574159, nil, nil, nil)

var queriesList* = Call_QueriesList_573880(name: "queriesList",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/microsoft.insights/queryPacks/{queryPackName}/queries",
                                        validator: validate_QueriesList_573881,
                                        base: "", url: url_QueriesList_573882,
                                        schemes: {Scheme.Https})
type
  Call_QueriesSearch_574198 = ref object of OpenApiRestCall_573658
proc url_QueriesSearch_574200(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "queryPackName" in path, "`queryPackName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/microsoft.insights/queryPacks/"),
               (kind: VariableSegment, value: "queryPackName"),
               (kind: ConstantSegment, value: "/queries/search")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_QueriesSearch_574199(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Search a list of Queries defined within a Log Analytics QueryPack according to given search properties.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   queryPackName: JString (required)
  ##                : The name of the Log Analytics QueryPack resource.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574218 = path.getOrDefault("resourceGroupName")
  valid_574218 = validateParameter(valid_574218, JString, required = true,
                                 default = nil)
  if valid_574218 != nil:
    section.add "resourceGroupName", valid_574218
  var valid_574219 = path.getOrDefault("queryPackName")
  valid_574219 = validateParameter(valid_574219, JString, required = true,
                                 default = nil)
  if valid_574219 != nil:
    section.add "queryPackName", valid_574219
  var valid_574220 = path.getOrDefault("subscriptionId")
  valid_574220 = validateParameter(valid_574220, JString, required = true,
                                 default = nil)
  if valid_574220 != nil:
    section.add "subscriptionId", valid_574220
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   includeBody: JBool
  ##              : Flag indicating whether or not to return the body of each applicable query. If false, only return the query information.
  ##   $top: JInt
  ##       : Maximum items returned in page.
  ##   $skipToken: JString
  ##             : Base64 encoded token used to fetch the next page of items. Default is null.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574221 = query.getOrDefault("api-version")
  valid_574221 = validateParameter(valid_574221, JString, required = true,
                                 default = nil)
  if valid_574221 != nil:
    section.add "api-version", valid_574221
  var valid_574222 = query.getOrDefault("includeBody")
  valid_574222 = validateParameter(valid_574222, JBool, required = false, default = nil)
  if valid_574222 != nil:
    section.add "includeBody", valid_574222
  var valid_574223 = query.getOrDefault("$top")
  valid_574223 = validateParameter(valid_574223, JInt, required = false, default = nil)
  if valid_574223 != nil:
    section.add "$top", valid_574223
  var valid_574224 = query.getOrDefault("$skipToken")
  valid_574224 = validateParameter(valid_574224, JString, required = false,
                                 default = nil)
  if valid_574224 != nil:
    section.add "$skipToken", valid_574224
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   QuerySearchProperties: JObject (required)
  ##                        : Properties by which to search queries in the given Log Analytics QueryPack.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574226: Call_QueriesSearch_574198; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Search a list of Queries defined within a Log Analytics QueryPack according to given search properties.
  ## 
  let valid = call_574226.validator(path, query, header, formData, body)
  let scheme = call_574226.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574226.url(scheme.get, call_574226.host, call_574226.base,
                         call_574226.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574226, url, valid)

proc call*(call_574227: Call_QueriesSearch_574198; resourceGroupName: string;
          apiVersion: string; queryPackName: string; subscriptionId: string;
          QuerySearchProperties: JsonNode; includeBody: bool = false; Top: int = 0;
          SkipToken: string = ""): Recallable =
  ## queriesSearch
  ## Search a list of Queries defined within a Log Analytics QueryPack according to given search properties.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   queryPackName: string (required)
  ##                : The name of the Log Analytics QueryPack resource.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   QuerySearchProperties: JObject (required)
  ##                        : Properties by which to search queries in the given Log Analytics QueryPack.
  ##   includeBody: bool
  ##              : Flag indicating whether or not to return the body of each applicable query. If false, only return the query information.
  ##   Top: int
  ##      : Maximum items returned in page.
  ##   SkipToken: string
  ##            : Base64 encoded token used to fetch the next page of items. Default is null.
  var path_574228 = newJObject()
  var query_574229 = newJObject()
  var body_574230 = newJObject()
  add(path_574228, "resourceGroupName", newJString(resourceGroupName))
  add(query_574229, "api-version", newJString(apiVersion))
  add(path_574228, "queryPackName", newJString(queryPackName))
  add(path_574228, "subscriptionId", newJString(subscriptionId))
  if QuerySearchProperties != nil:
    body_574230 = QuerySearchProperties
  add(query_574229, "includeBody", newJBool(includeBody))
  add(query_574229, "$top", newJInt(Top))
  add(query_574229, "$skipToken", newJString(SkipToken))
  result = call_574227.call(path_574228, query_574229, nil, nil, body_574230)

var queriesSearch* = Call_QueriesSearch_574198(name: "queriesSearch",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/microsoft.insights/queryPacks/{queryPackName}/queries/search",
    validator: validate_QueriesSearch_574199, base: "", url: url_QueriesSearch_574200,
    schemes: {Scheme.Https})
type
  Call_QueriesPut_574243 = ref object of OpenApiRestCall_573658
proc url_QueriesPut_574245(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "queryPackName" in path, "`queryPackName` is a required path parameter"
  assert "queryId" in path, "`queryId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/microsoft.insights/queryPacks/"),
               (kind: VariableSegment, value: "queryPackName"),
               (kind: ConstantSegment, value: "/queries/"),
               (kind: VariableSegment, value: "queryId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_QueriesPut_574244(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds or Updates a specific Query within a Log Analytics QueryPack.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   queryId: JString (required)
  ##          : The id of a specific query defined in the Log Analytics QueryPack
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   queryPackName: JString (required)
  ##                : The name of the Log Analytics QueryPack resource.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `queryId` field"
  var valid_574246 = path.getOrDefault("queryId")
  valid_574246 = validateParameter(valid_574246, JString, required = true,
                                 default = nil)
  if valid_574246 != nil:
    section.add "queryId", valid_574246
  var valid_574247 = path.getOrDefault("resourceGroupName")
  valid_574247 = validateParameter(valid_574247, JString, required = true,
                                 default = nil)
  if valid_574247 != nil:
    section.add "resourceGroupName", valid_574247
  var valid_574248 = path.getOrDefault("queryPackName")
  valid_574248 = validateParameter(valid_574248, JString, required = true,
                                 default = nil)
  if valid_574248 != nil:
    section.add "queryPackName", valid_574248
  var valid_574249 = path.getOrDefault("subscriptionId")
  valid_574249 = validateParameter(valid_574249, JString, required = true,
                                 default = nil)
  if valid_574249 != nil:
    section.add "subscriptionId", valid_574249
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574250 = query.getOrDefault("api-version")
  valid_574250 = validateParameter(valid_574250, JString, required = true,
                                 default = nil)
  if valid_574250 != nil:
    section.add "api-version", valid_574250
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   QueryPayload: JObject (required)
  ##               : Properties that need to be specified to create a new query and add it to a Log Analytics QueryPack.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574252: Call_QueriesPut_574243; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds or Updates a specific Query within a Log Analytics QueryPack.
  ## 
  let valid = call_574252.validator(path, query, header, formData, body)
  let scheme = call_574252.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574252.url(scheme.get, call_574252.host, call_574252.base,
                         call_574252.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574252, url, valid)

proc call*(call_574253: Call_QueriesPut_574243; queryId: string;
          resourceGroupName: string; apiVersion: string; queryPackName: string;
          subscriptionId: string; QueryPayload: JsonNode): Recallable =
  ## queriesPut
  ## Adds or Updates a specific Query within a Log Analytics QueryPack.
  ##   queryId: string (required)
  ##          : The id of a specific query defined in the Log Analytics QueryPack
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   queryPackName: string (required)
  ##                : The name of the Log Analytics QueryPack resource.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   QueryPayload: JObject (required)
  ##               : Properties that need to be specified to create a new query and add it to a Log Analytics QueryPack.
  var path_574254 = newJObject()
  var query_574255 = newJObject()
  var body_574256 = newJObject()
  add(path_574254, "queryId", newJString(queryId))
  add(path_574254, "resourceGroupName", newJString(resourceGroupName))
  add(query_574255, "api-version", newJString(apiVersion))
  add(path_574254, "queryPackName", newJString(queryPackName))
  add(path_574254, "subscriptionId", newJString(subscriptionId))
  if QueryPayload != nil:
    body_574256 = QueryPayload
  result = call_574253.call(path_574254, query_574255, nil, nil, body_574256)

var queriesPut* = Call_QueriesPut_574243(name: "queriesPut",
                                      meth: HttpMethod.HttpPut,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/microsoft.insights/queryPacks/{queryPackName}/queries/{queryId}",
                                      validator: validate_QueriesPut_574244,
                                      base: "", url: url_QueriesPut_574245,
                                      schemes: {Scheme.Https})
type
  Call_QueriesGet_574231 = ref object of OpenApiRestCall_573658
proc url_QueriesGet_574233(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "queryPackName" in path, "`queryPackName` is a required path parameter"
  assert "queryId" in path, "`queryId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/microsoft.insights/queryPacks/"),
               (kind: VariableSegment, value: "queryPackName"),
               (kind: ConstantSegment, value: "/queries/"),
               (kind: VariableSegment, value: "queryId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_QueriesGet_574232(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a specific Log Analytics Query defined within a Log Analytics QueryPack.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   queryId: JString (required)
  ##          : The id of a specific query defined in the Log Analytics QueryPack
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   queryPackName: JString (required)
  ##                : The name of the Log Analytics QueryPack resource.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `queryId` field"
  var valid_574234 = path.getOrDefault("queryId")
  valid_574234 = validateParameter(valid_574234, JString, required = true,
                                 default = nil)
  if valid_574234 != nil:
    section.add "queryId", valid_574234
  var valid_574235 = path.getOrDefault("resourceGroupName")
  valid_574235 = validateParameter(valid_574235, JString, required = true,
                                 default = nil)
  if valid_574235 != nil:
    section.add "resourceGroupName", valid_574235
  var valid_574236 = path.getOrDefault("queryPackName")
  valid_574236 = validateParameter(valid_574236, JString, required = true,
                                 default = nil)
  if valid_574236 != nil:
    section.add "queryPackName", valid_574236
  var valid_574237 = path.getOrDefault("subscriptionId")
  valid_574237 = validateParameter(valid_574237, JString, required = true,
                                 default = nil)
  if valid_574237 != nil:
    section.add "subscriptionId", valid_574237
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574238 = query.getOrDefault("api-version")
  valid_574238 = validateParameter(valid_574238, JString, required = true,
                                 default = nil)
  if valid_574238 != nil:
    section.add "api-version", valid_574238
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574239: Call_QueriesGet_574231; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a specific Log Analytics Query defined within a Log Analytics QueryPack.
  ## 
  let valid = call_574239.validator(path, query, header, formData, body)
  let scheme = call_574239.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574239.url(scheme.get, call_574239.host, call_574239.base,
                         call_574239.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574239, url, valid)

proc call*(call_574240: Call_QueriesGet_574231; queryId: string;
          resourceGroupName: string; apiVersion: string; queryPackName: string;
          subscriptionId: string): Recallable =
  ## queriesGet
  ## Gets a specific Log Analytics Query defined within a Log Analytics QueryPack.
  ##   queryId: string (required)
  ##          : The id of a specific query defined in the Log Analytics QueryPack
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   queryPackName: string (required)
  ##                : The name of the Log Analytics QueryPack resource.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_574241 = newJObject()
  var query_574242 = newJObject()
  add(path_574241, "queryId", newJString(queryId))
  add(path_574241, "resourceGroupName", newJString(resourceGroupName))
  add(query_574242, "api-version", newJString(apiVersion))
  add(path_574241, "queryPackName", newJString(queryPackName))
  add(path_574241, "subscriptionId", newJString(subscriptionId))
  result = call_574240.call(path_574241, query_574242, nil, nil, nil)

var queriesGet* = Call_QueriesGet_574231(name: "queriesGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/microsoft.insights/queryPacks/{queryPackName}/queries/{queryId}",
                                      validator: validate_QueriesGet_574232,
                                      base: "", url: url_QueriesGet_574233,
                                      schemes: {Scheme.Https})
type
  Call_QueriesDelete_574257 = ref object of OpenApiRestCall_573658
proc url_QueriesDelete_574259(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "queryPackName" in path, "`queryPackName` is a required path parameter"
  assert "queryId" in path, "`queryId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/microsoft.insights/queryPacks/"),
               (kind: VariableSegment, value: "queryPackName"),
               (kind: ConstantSegment, value: "/queries/"),
               (kind: VariableSegment, value: "queryId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_QueriesDelete_574258(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a specific Query defined within an Log Analytics QueryPack.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   queryId: JString (required)
  ##          : The id of a specific query defined in the Log Analytics QueryPack
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   queryPackName: JString (required)
  ##                : The name of the Log Analytics QueryPack resource.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `queryId` field"
  var valid_574260 = path.getOrDefault("queryId")
  valid_574260 = validateParameter(valid_574260, JString, required = true,
                                 default = nil)
  if valid_574260 != nil:
    section.add "queryId", valid_574260
  var valid_574261 = path.getOrDefault("resourceGroupName")
  valid_574261 = validateParameter(valid_574261, JString, required = true,
                                 default = nil)
  if valid_574261 != nil:
    section.add "resourceGroupName", valid_574261
  var valid_574262 = path.getOrDefault("queryPackName")
  valid_574262 = validateParameter(valid_574262, JString, required = true,
                                 default = nil)
  if valid_574262 != nil:
    section.add "queryPackName", valid_574262
  var valid_574263 = path.getOrDefault("subscriptionId")
  valid_574263 = validateParameter(valid_574263, JString, required = true,
                                 default = nil)
  if valid_574263 != nil:
    section.add "subscriptionId", valid_574263
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574264 = query.getOrDefault("api-version")
  valid_574264 = validateParameter(valid_574264, JString, required = true,
                                 default = nil)
  if valid_574264 != nil:
    section.add "api-version", valid_574264
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574265: Call_QueriesDelete_574257; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a specific Query defined within an Log Analytics QueryPack.
  ## 
  let valid = call_574265.validator(path, query, header, formData, body)
  let scheme = call_574265.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574265.url(scheme.get, call_574265.host, call_574265.base,
                         call_574265.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574265, url, valid)

proc call*(call_574266: Call_QueriesDelete_574257; queryId: string;
          resourceGroupName: string; apiVersion: string; queryPackName: string;
          subscriptionId: string): Recallable =
  ## queriesDelete
  ## Deletes a specific Query defined within an Log Analytics QueryPack.
  ##   queryId: string (required)
  ##          : The id of a specific query defined in the Log Analytics QueryPack
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   queryPackName: string (required)
  ##                : The name of the Log Analytics QueryPack resource.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_574267 = newJObject()
  var query_574268 = newJObject()
  add(path_574267, "queryId", newJString(queryId))
  add(path_574267, "resourceGroupName", newJString(resourceGroupName))
  add(query_574268, "api-version", newJString(apiVersion))
  add(path_574267, "queryPackName", newJString(queryPackName))
  add(path_574267, "subscriptionId", newJString(subscriptionId))
  result = call_574266.call(path_574267, query_574268, nil, nil, nil)

var queriesDelete* = Call_QueriesDelete_574257(name: "queriesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/microsoft.insights/queryPacks/{queryPackName}/queries/{queryId}",
    validator: validate_QueriesDelete_574258, base: "", url: url_QueriesDelete_574259,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
