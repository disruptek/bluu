
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: ApplicationInsightsManagementClient
## version: 2015-05-01
## termsOfService: (not provided)
## license: (not provided)
## 
## Azure Application Insights client for saved items.
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
  macServiceName = "applicationinsights-analyticsItems_API"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AnalyticsItemsList_563778 = ref object of OpenApiRestCall_563556
proc url_AnalyticsItemsList_563780(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "scopePath" in path, "`scopePath` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/microsoft.insights/components/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scopePath")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsItemsList_563779(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets a list of Analytics Items defined within an Application Insights component.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   scopePath: JString (required)
  ##            : Enum indicating if this item definition is owned by a specific user or is shared between all users with access to the Application Insights component.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   resourceName: JString (required)
  ##               : The name of the Application Insights component resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_563955 = path.getOrDefault("subscriptionId")
  valid_563955 = validateParameter(valid_563955, JString, required = true,
                                 default = nil)
  if valid_563955 != nil:
    section.add "subscriptionId", valid_563955
  var valid_563969 = path.getOrDefault("scopePath")
  valid_563969 = validateParameter(valid_563969, JString, required = true,
                                 default = newJString("analyticsItems"))
  if valid_563969 != nil:
    section.add "scopePath", valid_563969
  var valid_563970 = path.getOrDefault("resourceGroupName")
  valid_563970 = validateParameter(valid_563970, JString, required = true,
                                 default = nil)
  if valid_563970 != nil:
    section.add "resourceGroupName", valid_563970
  var valid_563971 = path.getOrDefault("resourceName")
  valid_563971 = validateParameter(valid_563971, JString, required = true,
                                 default = nil)
  if valid_563971 != nil:
    section.add "resourceName", valid_563971
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   scope: JString
  ##        : Enum indicating if this item definition is owned by a specific user or is shared between all users with access to the Application Insights component.
  ##   includeContent: JBool
  ##                 : Flag indicating whether or not to return the content of each applicable item. If false, only return the item information.
  ##   type: JString
  ##       : Enum indicating the type of the Analytics item.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563972 = query.getOrDefault("api-version")
  valid_563972 = validateParameter(valid_563972, JString, required = true,
                                 default = nil)
  if valid_563972 != nil:
    section.add "api-version", valid_563972
  var valid_563973 = query.getOrDefault("scope")
  valid_563973 = validateParameter(valid_563973, JString, required = false,
                                 default = newJString("shared"))
  if valid_563973 != nil:
    section.add "scope", valid_563973
  var valid_563974 = query.getOrDefault("includeContent")
  valid_563974 = validateParameter(valid_563974, JBool, required = false, default = nil)
  if valid_563974 != nil:
    section.add "includeContent", valid_563974
  var valid_563975 = query.getOrDefault("type")
  valid_563975 = validateParameter(valid_563975, JString, required = false,
                                 default = newJString("none"))
  if valid_563975 != nil:
    section.add "type", valid_563975
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563998: Call_AnalyticsItemsList_563778; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of Analytics Items defined within an Application Insights component.
  ## 
  let valid = call_563998.validator(path, query, header, formData, body)
  let scheme = call_563998.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563998.url(scheme.get, call_563998.host, call_563998.base,
                         call_563998.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563998, url, valid)

proc call*(call_564069: Call_AnalyticsItemsList_563778; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; resourceName: string;
          scope: string = "shared"; includeContent: bool = false;
          `type`: string = "none"; scopePath: string = "analyticsItems"): Recallable =
  ## analyticsItemsList
  ## Gets a list of Analytics Items defined within an Application Insights component.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   scope: string
  ##        : Enum indicating if this item definition is owned by a specific user or is shared between all users with access to the Application Insights component.
  ##   includeContent: bool
  ##                 : Flag indicating whether or not to return the content of each applicable item. If false, only return the item information.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   type: string
  ##       : Enum indicating the type of the Analytics item.
  ##   scopePath: string (required)
  ##            : Enum indicating if this item definition is owned by a specific user or is shared between all users with access to the Application Insights component.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   resourceName: string (required)
  ##               : The name of the Application Insights component resource.
  var path_564070 = newJObject()
  var query_564072 = newJObject()
  add(query_564072, "api-version", newJString(apiVersion))
  add(query_564072, "scope", newJString(scope))
  add(query_564072, "includeContent", newJBool(includeContent))
  add(path_564070, "subscriptionId", newJString(subscriptionId))
  add(query_564072, "type", newJString(`type`))
  add(path_564070, "scopePath", newJString(scopePath))
  add(path_564070, "resourceGroupName", newJString(resourceGroupName))
  add(path_564070, "resourceName", newJString(resourceName))
  result = call_564069.call(path_564070, query_564072, nil, nil, nil)

var analyticsItemsList* = Call_AnalyticsItemsList_563778(
    name: "analyticsItemsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/microsoft.insights/components/{resourceName}/{scopePath}",
    validator: validate_AnalyticsItemsList_563779, base: "",
    url: url_AnalyticsItemsList_563780, schemes: {Scheme.Https})
type
  Call_AnalyticsItemsPut_564125 = ref object of OpenApiRestCall_563556
proc url_AnalyticsItemsPut_564127(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "scopePath" in path, "`scopePath` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/microsoft.insights/components/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scopePath"),
               (kind: ConstantSegment, value: "/item")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsItemsPut_564126(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Adds or Updates a specific Analytics Item within an Application Insights component.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   scopePath: JString (required)
  ##            : Enum indicating if this item definition is owned by a specific user or is shared between all users with access to the Application Insights component.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   resourceName: JString (required)
  ##               : The name of the Application Insights component resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564128 = path.getOrDefault("subscriptionId")
  valid_564128 = validateParameter(valid_564128, JString, required = true,
                                 default = nil)
  if valid_564128 != nil:
    section.add "subscriptionId", valid_564128
  var valid_564129 = path.getOrDefault("scopePath")
  valid_564129 = validateParameter(valid_564129, JString, required = true,
                                 default = newJString("analyticsItems"))
  if valid_564129 != nil:
    section.add "scopePath", valid_564129
  var valid_564130 = path.getOrDefault("resourceGroupName")
  valid_564130 = validateParameter(valid_564130, JString, required = true,
                                 default = nil)
  if valid_564130 != nil:
    section.add "resourceGroupName", valid_564130
  var valid_564131 = path.getOrDefault("resourceName")
  valid_564131 = validateParameter(valid_564131, JString, required = true,
                                 default = nil)
  if valid_564131 != nil:
    section.add "resourceName", valid_564131
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   overrideItem: JBool
  ##               : Flag indicating whether or not to force save an item. This allows overriding an item if it already exists.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564132 = query.getOrDefault("api-version")
  valid_564132 = validateParameter(valid_564132, JString, required = true,
                                 default = nil)
  if valid_564132 != nil:
    section.add "api-version", valid_564132
  var valid_564133 = query.getOrDefault("overrideItem")
  valid_564133 = validateParameter(valid_564133, JBool, required = false, default = nil)
  if valid_564133 != nil:
    section.add "overrideItem", valid_564133
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   itemProperties: JObject (required)
  ##                 : Properties that need to be specified to create a new item and add it to an Application Insights component.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564135: Call_AnalyticsItemsPut_564125; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds or Updates a specific Analytics Item within an Application Insights component.
  ## 
  let valid = call_564135.validator(path, query, header, formData, body)
  let scheme = call_564135.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564135.url(scheme.get, call_564135.host, call_564135.base,
                         call_564135.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564135, url, valid)

proc call*(call_564136: Call_AnalyticsItemsPut_564125; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; resourceName: string;
          itemProperties: JsonNode; scopePath: string = "analyticsItems";
          overrideItem: bool = false): Recallable =
  ## analyticsItemsPut
  ## Adds or Updates a specific Analytics Item within an Application Insights component.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   scopePath: string (required)
  ##            : Enum indicating if this item definition is owned by a specific user or is shared between all users with access to the Application Insights component.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   overrideItem: bool
  ##               : Flag indicating whether or not to force save an item. This allows overriding an item if it already exists.
  ##   resourceName: string (required)
  ##               : The name of the Application Insights component resource.
  ##   itemProperties: JObject (required)
  ##                 : Properties that need to be specified to create a new item and add it to an Application Insights component.
  var path_564137 = newJObject()
  var query_564138 = newJObject()
  var body_564139 = newJObject()
  add(query_564138, "api-version", newJString(apiVersion))
  add(path_564137, "subscriptionId", newJString(subscriptionId))
  add(path_564137, "scopePath", newJString(scopePath))
  add(path_564137, "resourceGroupName", newJString(resourceGroupName))
  add(query_564138, "overrideItem", newJBool(overrideItem))
  add(path_564137, "resourceName", newJString(resourceName))
  if itemProperties != nil:
    body_564139 = itemProperties
  result = call_564136.call(path_564137, query_564138, nil, nil, body_564139)

var analyticsItemsPut* = Call_AnalyticsItemsPut_564125(name: "analyticsItemsPut",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/microsoft.insights/components/{resourceName}/{scopePath}/item",
    validator: validate_AnalyticsItemsPut_564126, base: "",
    url: url_AnalyticsItemsPut_564127, schemes: {Scheme.Https})
type
  Call_AnalyticsItemsGet_564111 = ref object of OpenApiRestCall_563556
proc url_AnalyticsItemsGet_564113(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "scopePath" in path, "`scopePath` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/microsoft.insights/components/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scopePath"),
               (kind: ConstantSegment, value: "/item")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsItemsGet_564112(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets a specific Analytics Items defined within an Application Insights component.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   scopePath: JString (required)
  ##            : Enum indicating if this item definition is owned by a specific user or is shared between all users with access to the Application Insights component.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   resourceName: JString (required)
  ##               : The name of the Application Insights component resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564114 = path.getOrDefault("subscriptionId")
  valid_564114 = validateParameter(valid_564114, JString, required = true,
                                 default = nil)
  if valid_564114 != nil:
    section.add "subscriptionId", valid_564114
  var valid_564115 = path.getOrDefault("scopePath")
  valid_564115 = validateParameter(valid_564115, JString, required = true,
                                 default = newJString("analyticsItems"))
  if valid_564115 != nil:
    section.add "scopePath", valid_564115
  var valid_564116 = path.getOrDefault("resourceGroupName")
  valid_564116 = validateParameter(valid_564116, JString, required = true,
                                 default = nil)
  if valid_564116 != nil:
    section.add "resourceGroupName", valid_564116
  var valid_564117 = path.getOrDefault("resourceName")
  valid_564117 = validateParameter(valid_564117, JString, required = true,
                                 default = nil)
  if valid_564117 != nil:
    section.add "resourceName", valid_564117
  result.add "path", section
  ## parameters in `query` object:
  ##   name: JString
  ##       : The name of a specific item defined in the Application Insights component
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   id: JString
  ##     : The Id of a specific item defined in the Application Insights component
  section = newJObject()
  var valid_564118 = query.getOrDefault("name")
  valid_564118 = validateParameter(valid_564118, JString, required = false,
                                 default = nil)
  if valid_564118 != nil:
    section.add "name", valid_564118
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564119 = query.getOrDefault("api-version")
  valid_564119 = validateParameter(valid_564119, JString, required = true,
                                 default = nil)
  if valid_564119 != nil:
    section.add "api-version", valid_564119
  var valid_564120 = query.getOrDefault("id")
  valid_564120 = validateParameter(valid_564120, JString, required = false,
                                 default = nil)
  if valid_564120 != nil:
    section.add "id", valid_564120
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564121: Call_AnalyticsItemsGet_564111; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a specific Analytics Items defined within an Application Insights component.
  ## 
  let valid = call_564121.validator(path, query, header, formData, body)
  let scheme = call_564121.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564121.url(scheme.get, call_564121.host, call_564121.base,
                         call_564121.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564121, url, valid)

proc call*(call_564122: Call_AnalyticsItemsGet_564111; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; resourceName: string;
          name: string = ""; id: string = ""; scopePath: string = "analyticsItems"): Recallable =
  ## analyticsItemsGet
  ## Gets a specific Analytics Items defined within an Application Insights component.
  ##   name: string
  ##       : The name of a specific item defined in the Application Insights component
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   id: string
  ##     : The Id of a specific item defined in the Application Insights component
  ##   scopePath: string (required)
  ##            : Enum indicating if this item definition is owned by a specific user or is shared between all users with access to the Application Insights component.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   resourceName: string (required)
  ##               : The name of the Application Insights component resource.
  var path_564123 = newJObject()
  var query_564124 = newJObject()
  add(query_564124, "name", newJString(name))
  add(query_564124, "api-version", newJString(apiVersion))
  add(path_564123, "subscriptionId", newJString(subscriptionId))
  add(query_564124, "id", newJString(id))
  add(path_564123, "scopePath", newJString(scopePath))
  add(path_564123, "resourceGroupName", newJString(resourceGroupName))
  add(path_564123, "resourceName", newJString(resourceName))
  result = call_564122.call(path_564123, query_564124, nil, nil, nil)

var analyticsItemsGet* = Call_AnalyticsItemsGet_564111(name: "analyticsItemsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/microsoft.insights/components/{resourceName}/{scopePath}/item",
    validator: validate_AnalyticsItemsGet_564112, base: "",
    url: url_AnalyticsItemsGet_564113, schemes: {Scheme.Https})
type
  Call_AnalyticsItemsDelete_564140 = ref object of OpenApiRestCall_563556
proc url_AnalyticsItemsDelete_564142(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "scopePath" in path, "`scopePath` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/microsoft.insights/components/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scopePath"),
               (kind: ConstantSegment, value: "/item")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsItemsDelete_564141(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a specific Analytics Items defined within an Application Insights component.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   scopePath: JString (required)
  ##            : Enum indicating if this item definition is owned by a specific user or is shared between all users with access to the Application Insights component.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   resourceName: JString (required)
  ##               : The name of the Application Insights component resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564143 = path.getOrDefault("subscriptionId")
  valid_564143 = validateParameter(valid_564143, JString, required = true,
                                 default = nil)
  if valid_564143 != nil:
    section.add "subscriptionId", valid_564143
  var valid_564144 = path.getOrDefault("scopePath")
  valid_564144 = validateParameter(valid_564144, JString, required = true,
                                 default = newJString("analyticsItems"))
  if valid_564144 != nil:
    section.add "scopePath", valid_564144
  var valid_564145 = path.getOrDefault("resourceGroupName")
  valid_564145 = validateParameter(valid_564145, JString, required = true,
                                 default = nil)
  if valid_564145 != nil:
    section.add "resourceGroupName", valid_564145
  var valid_564146 = path.getOrDefault("resourceName")
  valid_564146 = validateParameter(valid_564146, JString, required = true,
                                 default = nil)
  if valid_564146 != nil:
    section.add "resourceName", valid_564146
  result.add "path", section
  ## parameters in `query` object:
  ##   name: JString
  ##       : The name of a specific item defined in the Application Insights component
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   id: JString
  ##     : The Id of a specific item defined in the Application Insights component
  section = newJObject()
  var valid_564147 = query.getOrDefault("name")
  valid_564147 = validateParameter(valid_564147, JString, required = false,
                                 default = nil)
  if valid_564147 != nil:
    section.add "name", valid_564147
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564148 = query.getOrDefault("api-version")
  valid_564148 = validateParameter(valid_564148, JString, required = true,
                                 default = nil)
  if valid_564148 != nil:
    section.add "api-version", valid_564148
  var valid_564149 = query.getOrDefault("id")
  valid_564149 = validateParameter(valid_564149, JString, required = false,
                                 default = nil)
  if valid_564149 != nil:
    section.add "id", valid_564149
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564150: Call_AnalyticsItemsDelete_564140; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a specific Analytics Items defined within an Application Insights component.
  ## 
  let valid = call_564150.validator(path, query, header, formData, body)
  let scheme = call_564150.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564150.url(scheme.get, call_564150.host, call_564150.base,
                         call_564150.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564150, url, valid)

proc call*(call_564151: Call_AnalyticsItemsDelete_564140; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; resourceName: string;
          name: string = ""; id: string = ""; scopePath: string = "analyticsItems"): Recallable =
  ## analyticsItemsDelete
  ## Deletes a specific Analytics Items defined within an Application Insights component.
  ##   name: string
  ##       : The name of a specific item defined in the Application Insights component
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   id: string
  ##     : The Id of a specific item defined in the Application Insights component
  ##   scopePath: string (required)
  ##            : Enum indicating if this item definition is owned by a specific user or is shared between all users with access to the Application Insights component.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   resourceName: string (required)
  ##               : The name of the Application Insights component resource.
  var path_564152 = newJObject()
  var query_564153 = newJObject()
  add(query_564153, "name", newJString(name))
  add(query_564153, "api-version", newJString(apiVersion))
  add(path_564152, "subscriptionId", newJString(subscriptionId))
  add(query_564153, "id", newJString(id))
  add(path_564152, "scopePath", newJString(scopePath))
  add(path_564152, "resourceGroupName", newJString(resourceGroupName))
  add(path_564152, "resourceName", newJString(resourceName))
  result = call_564151.call(path_564152, query_564153, nil, nil, nil)

var analyticsItemsDelete* = Call_AnalyticsItemsDelete_564140(
    name: "analyticsItemsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/microsoft.insights/components/{resourceName}/{scopePath}/item",
    validator: validate_AnalyticsItemsDelete_564141, base: "",
    url: url_AnalyticsItemsDelete_564142, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
