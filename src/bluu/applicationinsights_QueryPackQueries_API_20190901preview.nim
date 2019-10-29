
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
  macServiceName = "applicationinsights-QueryPackQueries_API"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_QueriesList_563778 = ref object of OpenApiRestCall_563556
proc url_QueriesList_563780(protocol: Scheme; host: string; base: string;
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

proc validate_QueriesList_563779(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of Queries defined within a Log Analytics QueryPack.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   queryPackName: JString (required)
  ##                : The name of the Log Analytics QueryPack resource.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `queryPackName` field"
  var valid_563956 = path.getOrDefault("queryPackName")
  valid_563956 = validateParameter(valid_563956, JString, required = true,
                                 default = nil)
  if valid_563956 != nil:
    section.add "queryPackName", valid_563956
  var valid_563957 = path.getOrDefault("subscriptionId")
  valid_563957 = validateParameter(valid_563957, JString, required = true,
                                 default = nil)
  if valid_563957 != nil:
    section.add "subscriptionId", valid_563957
  var valid_563958 = path.getOrDefault("resourceGroupName")
  valid_563958 = validateParameter(valid_563958, JString, required = true,
                                 default = nil)
  if valid_563958 != nil:
    section.add "resourceGroupName", valid_563958
  result.add "path", section
  ## parameters in `query` object:
  ##   $skipToken: JString
  ##             : Base64 encoded token used to fetch the next page of items. Default is null.
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $top: JInt
  ##       : Maximum items returned in page.
  ##   includeBody: JBool
  ##              : Flag indicating whether or not to return the body of each applicable query. If false, only return the query information.
  section = newJObject()
  var valid_563959 = query.getOrDefault("$skipToken")
  valid_563959 = validateParameter(valid_563959, JString, required = false,
                                 default = nil)
  if valid_563959 != nil:
    section.add "$skipToken", valid_563959
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563960 = query.getOrDefault("api-version")
  valid_563960 = validateParameter(valid_563960, JString, required = true,
                                 default = nil)
  if valid_563960 != nil:
    section.add "api-version", valid_563960
  var valid_563961 = query.getOrDefault("$top")
  valid_563961 = validateParameter(valid_563961, JInt, required = false, default = nil)
  if valid_563961 != nil:
    section.add "$top", valid_563961
  var valid_563962 = query.getOrDefault("includeBody")
  valid_563962 = validateParameter(valid_563962, JBool, required = false, default = nil)
  if valid_563962 != nil:
    section.add "includeBody", valid_563962
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563985: Call_QueriesList_563778; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of Queries defined within a Log Analytics QueryPack.
  ## 
  let valid = call_563985.validator(path, query, header, formData, body)
  let scheme = call_563985.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563985.url(scheme.get, call_563985.host, call_563985.base,
                         call_563985.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563985, url, valid)

proc call*(call_564056: Call_QueriesList_563778; queryPackName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          SkipToken: string = ""; Top: int = 0; includeBody: bool = false): Recallable =
  ## queriesList
  ## Gets a list of Queries defined within a Log Analytics QueryPack.
  ##   SkipToken: string
  ##            : Base64 encoded token used to fetch the next page of items. Default is null.
  ##   queryPackName: string (required)
  ##                : The name of the Log Analytics QueryPack resource.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   Top: int
  ##      : Maximum items returned in page.
  ##   includeBody: bool
  ##              : Flag indicating whether or not to return the body of each applicable query. If false, only return the query information.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  var path_564057 = newJObject()
  var query_564059 = newJObject()
  add(query_564059, "$skipToken", newJString(SkipToken))
  add(path_564057, "queryPackName", newJString(queryPackName))
  add(query_564059, "api-version", newJString(apiVersion))
  add(query_564059, "$top", newJInt(Top))
  add(query_564059, "includeBody", newJBool(includeBody))
  add(path_564057, "subscriptionId", newJString(subscriptionId))
  add(path_564057, "resourceGroupName", newJString(resourceGroupName))
  result = call_564056.call(path_564057, query_564059, nil, nil, nil)

var queriesList* = Call_QueriesList_563778(name: "queriesList",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/microsoft.insights/queryPacks/{queryPackName}/queries",
                                        validator: validate_QueriesList_563779,
                                        base: "", url: url_QueriesList_563780,
                                        schemes: {Scheme.Https})
type
  Call_QueriesSearch_564098 = ref object of OpenApiRestCall_563556
proc url_QueriesSearch_564100(protocol: Scheme; host: string; base: string;
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

proc validate_QueriesSearch_564099(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Search a list of Queries defined within a Log Analytics QueryPack according to given search properties.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   queryPackName: JString (required)
  ##                : The name of the Log Analytics QueryPack resource.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `queryPackName` field"
  var valid_564118 = path.getOrDefault("queryPackName")
  valid_564118 = validateParameter(valid_564118, JString, required = true,
                                 default = nil)
  if valid_564118 != nil:
    section.add "queryPackName", valid_564118
  var valid_564119 = path.getOrDefault("subscriptionId")
  valid_564119 = validateParameter(valid_564119, JString, required = true,
                                 default = nil)
  if valid_564119 != nil:
    section.add "subscriptionId", valid_564119
  var valid_564120 = path.getOrDefault("resourceGroupName")
  valid_564120 = validateParameter(valid_564120, JString, required = true,
                                 default = nil)
  if valid_564120 != nil:
    section.add "resourceGroupName", valid_564120
  result.add "path", section
  ## parameters in `query` object:
  ##   $skipToken: JString
  ##             : Base64 encoded token used to fetch the next page of items. Default is null.
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $top: JInt
  ##       : Maximum items returned in page.
  ##   includeBody: JBool
  ##              : Flag indicating whether or not to return the body of each applicable query. If false, only return the query information.
  section = newJObject()
  var valid_564121 = query.getOrDefault("$skipToken")
  valid_564121 = validateParameter(valid_564121, JString, required = false,
                                 default = nil)
  if valid_564121 != nil:
    section.add "$skipToken", valid_564121
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564122 = query.getOrDefault("api-version")
  valid_564122 = validateParameter(valid_564122, JString, required = true,
                                 default = nil)
  if valid_564122 != nil:
    section.add "api-version", valid_564122
  var valid_564123 = query.getOrDefault("$top")
  valid_564123 = validateParameter(valid_564123, JInt, required = false, default = nil)
  if valid_564123 != nil:
    section.add "$top", valid_564123
  var valid_564124 = query.getOrDefault("includeBody")
  valid_564124 = validateParameter(valid_564124, JBool, required = false, default = nil)
  if valid_564124 != nil:
    section.add "includeBody", valid_564124
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

proc call*(call_564126: Call_QueriesSearch_564098; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Search a list of Queries defined within a Log Analytics QueryPack according to given search properties.
  ## 
  let valid = call_564126.validator(path, query, header, formData, body)
  let scheme = call_564126.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564126.url(scheme.get, call_564126.host, call_564126.base,
                         call_564126.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564126, url, valid)

proc call*(call_564127: Call_QueriesSearch_564098; queryPackName: string;
          apiVersion: string; QuerySearchProperties: JsonNode;
          subscriptionId: string; resourceGroupName: string; SkipToken: string = "";
          Top: int = 0; includeBody: bool = false): Recallable =
  ## queriesSearch
  ## Search a list of Queries defined within a Log Analytics QueryPack according to given search properties.
  ##   SkipToken: string
  ##            : Base64 encoded token used to fetch the next page of items. Default is null.
  ##   queryPackName: string (required)
  ##                : The name of the Log Analytics QueryPack resource.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   Top: int
  ##      : Maximum items returned in page.
  ##   QuerySearchProperties: JObject (required)
  ##                        : Properties by which to search queries in the given Log Analytics QueryPack.
  ##   includeBody: bool
  ##              : Flag indicating whether or not to return the body of each applicable query. If false, only return the query information.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  var path_564128 = newJObject()
  var query_564129 = newJObject()
  var body_564130 = newJObject()
  add(query_564129, "$skipToken", newJString(SkipToken))
  add(path_564128, "queryPackName", newJString(queryPackName))
  add(query_564129, "api-version", newJString(apiVersion))
  add(query_564129, "$top", newJInt(Top))
  if QuerySearchProperties != nil:
    body_564130 = QuerySearchProperties
  add(query_564129, "includeBody", newJBool(includeBody))
  add(path_564128, "subscriptionId", newJString(subscriptionId))
  add(path_564128, "resourceGroupName", newJString(resourceGroupName))
  result = call_564127.call(path_564128, query_564129, nil, nil, body_564130)

var queriesSearch* = Call_QueriesSearch_564098(name: "queriesSearch",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/microsoft.insights/queryPacks/{queryPackName}/queries/search",
    validator: validate_QueriesSearch_564099, base: "", url: url_QueriesSearch_564100,
    schemes: {Scheme.Https})
type
  Call_QueriesPut_564143 = ref object of OpenApiRestCall_563556
proc url_QueriesPut_564145(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_QueriesPut_564144(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds or Updates a specific Query within a Log Analytics QueryPack.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   queryPackName: JString (required)
  ##                : The name of the Log Analytics QueryPack resource.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   queryId: JString (required)
  ##          : The id of a specific query defined in the Log Analytics QueryPack
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `queryPackName` field"
  var valid_564146 = path.getOrDefault("queryPackName")
  valid_564146 = validateParameter(valid_564146, JString, required = true,
                                 default = nil)
  if valid_564146 != nil:
    section.add "queryPackName", valid_564146
  var valid_564147 = path.getOrDefault("subscriptionId")
  valid_564147 = validateParameter(valid_564147, JString, required = true,
                                 default = nil)
  if valid_564147 != nil:
    section.add "subscriptionId", valid_564147
  var valid_564148 = path.getOrDefault("queryId")
  valid_564148 = validateParameter(valid_564148, JString, required = true,
                                 default = nil)
  if valid_564148 != nil:
    section.add "queryId", valid_564148
  var valid_564149 = path.getOrDefault("resourceGroupName")
  valid_564149 = validateParameter(valid_564149, JString, required = true,
                                 default = nil)
  if valid_564149 != nil:
    section.add "resourceGroupName", valid_564149
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564150 = query.getOrDefault("api-version")
  valid_564150 = validateParameter(valid_564150, JString, required = true,
                                 default = nil)
  if valid_564150 != nil:
    section.add "api-version", valid_564150
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

proc call*(call_564152: Call_QueriesPut_564143; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds or Updates a specific Query within a Log Analytics QueryPack.
  ## 
  let valid = call_564152.validator(path, query, header, formData, body)
  let scheme = call_564152.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564152.url(scheme.get, call_564152.host, call_564152.base,
                         call_564152.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564152, url, valid)

proc call*(call_564153: Call_QueriesPut_564143; queryPackName: string;
          apiVersion: string; QueryPayload: JsonNode; subscriptionId: string;
          queryId: string; resourceGroupName: string): Recallable =
  ## queriesPut
  ## Adds or Updates a specific Query within a Log Analytics QueryPack.
  ##   queryPackName: string (required)
  ##                : The name of the Log Analytics QueryPack resource.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   QueryPayload: JObject (required)
  ##               : Properties that need to be specified to create a new query and add it to a Log Analytics QueryPack.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   queryId: string (required)
  ##          : The id of a specific query defined in the Log Analytics QueryPack
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  var path_564154 = newJObject()
  var query_564155 = newJObject()
  var body_564156 = newJObject()
  add(path_564154, "queryPackName", newJString(queryPackName))
  add(query_564155, "api-version", newJString(apiVersion))
  if QueryPayload != nil:
    body_564156 = QueryPayload
  add(path_564154, "subscriptionId", newJString(subscriptionId))
  add(path_564154, "queryId", newJString(queryId))
  add(path_564154, "resourceGroupName", newJString(resourceGroupName))
  result = call_564153.call(path_564154, query_564155, nil, nil, body_564156)

var queriesPut* = Call_QueriesPut_564143(name: "queriesPut",
                                      meth: HttpMethod.HttpPut,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/microsoft.insights/queryPacks/{queryPackName}/queries/{queryId}",
                                      validator: validate_QueriesPut_564144,
                                      base: "", url: url_QueriesPut_564145,
                                      schemes: {Scheme.Https})
type
  Call_QueriesGet_564131 = ref object of OpenApiRestCall_563556
proc url_QueriesGet_564133(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_QueriesGet_564132(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a specific Log Analytics Query defined within a Log Analytics QueryPack.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   queryPackName: JString (required)
  ##                : The name of the Log Analytics QueryPack resource.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   queryId: JString (required)
  ##          : The id of a specific query defined in the Log Analytics QueryPack
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `queryPackName` field"
  var valid_564134 = path.getOrDefault("queryPackName")
  valid_564134 = validateParameter(valid_564134, JString, required = true,
                                 default = nil)
  if valid_564134 != nil:
    section.add "queryPackName", valid_564134
  var valid_564135 = path.getOrDefault("subscriptionId")
  valid_564135 = validateParameter(valid_564135, JString, required = true,
                                 default = nil)
  if valid_564135 != nil:
    section.add "subscriptionId", valid_564135
  var valid_564136 = path.getOrDefault("queryId")
  valid_564136 = validateParameter(valid_564136, JString, required = true,
                                 default = nil)
  if valid_564136 != nil:
    section.add "queryId", valid_564136
  var valid_564137 = path.getOrDefault("resourceGroupName")
  valid_564137 = validateParameter(valid_564137, JString, required = true,
                                 default = nil)
  if valid_564137 != nil:
    section.add "resourceGroupName", valid_564137
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564138 = query.getOrDefault("api-version")
  valid_564138 = validateParameter(valid_564138, JString, required = true,
                                 default = nil)
  if valid_564138 != nil:
    section.add "api-version", valid_564138
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564139: Call_QueriesGet_564131; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a specific Log Analytics Query defined within a Log Analytics QueryPack.
  ## 
  let valid = call_564139.validator(path, query, header, formData, body)
  let scheme = call_564139.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564139.url(scheme.get, call_564139.host, call_564139.base,
                         call_564139.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564139, url, valid)

proc call*(call_564140: Call_QueriesGet_564131; queryPackName: string;
          apiVersion: string; subscriptionId: string; queryId: string;
          resourceGroupName: string): Recallable =
  ## queriesGet
  ## Gets a specific Log Analytics Query defined within a Log Analytics QueryPack.
  ##   queryPackName: string (required)
  ##                : The name of the Log Analytics QueryPack resource.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   queryId: string (required)
  ##          : The id of a specific query defined in the Log Analytics QueryPack
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  var path_564141 = newJObject()
  var query_564142 = newJObject()
  add(path_564141, "queryPackName", newJString(queryPackName))
  add(query_564142, "api-version", newJString(apiVersion))
  add(path_564141, "subscriptionId", newJString(subscriptionId))
  add(path_564141, "queryId", newJString(queryId))
  add(path_564141, "resourceGroupName", newJString(resourceGroupName))
  result = call_564140.call(path_564141, query_564142, nil, nil, nil)

var queriesGet* = Call_QueriesGet_564131(name: "queriesGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/microsoft.insights/queryPacks/{queryPackName}/queries/{queryId}",
                                      validator: validate_QueriesGet_564132,
                                      base: "", url: url_QueriesGet_564133,
                                      schemes: {Scheme.Https})
type
  Call_QueriesDelete_564157 = ref object of OpenApiRestCall_563556
proc url_QueriesDelete_564159(protocol: Scheme; host: string; base: string;
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

proc validate_QueriesDelete_564158(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a specific Query defined within an Log Analytics QueryPack.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   queryPackName: JString (required)
  ##                : The name of the Log Analytics QueryPack resource.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   queryId: JString (required)
  ##          : The id of a specific query defined in the Log Analytics QueryPack
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `queryPackName` field"
  var valid_564160 = path.getOrDefault("queryPackName")
  valid_564160 = validateParameter(valid_564160, JString, required = true,
                                 default = nil)
  if valid_564160 != nil:
    section.add "queryPackName", valid_564160
  var valid_564161 = path.getOrDefault("subscriptionId")
  valid_564161 = validateParameter(valid_564161, JString, required = true,
                                 default = nil)
  if valid_564161 != nil:
    section.add "subscriptionId", valid_564161
  var valid_564162 = path.getOrDefault("queryId")
  valid_564162 = validateParameter(valid_564162, JString, required = true,
                                 default = nil)
  if valid_564162 != nil:
    section.add "queryId", valid_564162
  var valid_564163 = path.getOrDefault("resourceGroupName")
  valid_564163 = validateParameter(valid_564163, JString, required = true,
                                 default = nil)
  if valid_564163 != nil:
    section.add "resourceGroupName", valid_564163
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564164 = query.getOrDefault("api-version")
  valid_564164 = validateParameter(valid_564164, JString, required = true,
                                 default = nil)
  if valid_564164 != nil:
    section.add "api-version", valid_564164
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564165: Call_QueriesDelete_564157; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a specific Query defined within an Log Analytics QueryPack.
  ## 
  let valid = call_564165.validator(path, query, header, formData, body)
  let scheme = call_564165.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564165.url(scheme.get, call_564165.host, call_564165.base,
                         call_564165.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564165, url, valid)

proc call*(call_564166: Call_QueriesDelete_564157; queryPackName: string;
          apiVersion: string; subscriptionId: string; queryId: string;
          resourceGroupName: string): Recallable =
  ## queriesDelete
  ## Deletes a specific Query defined within an Log Analytics QueryPack.
  ##   queryPackName: string (required)
  ##                : The name of the Log Analytics QueryPack resource.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   queryId: string (required)
  ##          : The id of a specific query defined in the Log Analytics QueryPack
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  var path_564167 = newJObject()
  var query_564168 = newJObject()
  add(path_564167, "queryPackName", newJString(queryPackName))
  add(query_564168, "api-version", newJString(apiVersion))
  add(path_564167, "subscriptionId", newJString(subscriptionId))
  add(path_564167, "queryId", newJString(queryId))
  add(path_564167, "resourceGroupName", newJString(resourceGroupName))
  result = call_564166.call(path_564167, query_564168, nil, nil, nil)

var queriesDelete* = Call_QueriesDelete_564157(name: "queriesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/microsoft.insights/queryPacks/{queryPackName}/queries/{queryId}",
    validator: validate_QueriesDelete_564158, base: "", url: url_QueriesDelete_564159,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
