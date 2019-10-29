
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: ApplicationInsightsManagementClient
## version: 2015-05-01
## termsOfService: (not provided)
## license: (not provided)
## 
## Azure Application Insights client for favorites.
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
  macServiceName = "applicationinsights-favorites_API"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_FavoritesList_563778 = ref object of OpenApiRestCall_563556
proc url_FavoritesList_563780(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Insights/components/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/favorites")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FavoritesList_563779(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of favorites defined within an Application Insights component.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
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
  var valid_563956 = path.getOrDefault("resourceGroupName")
  valid_563956 = validateParameter(valid_563956, JString, required = true,
                                 default = nil)
  if valid_563956 != nil:
    section.add "resourceGroupName", valid_563956
  var valid_563957 = path.getOrDefault("resourceName")
  valid_563957 = validateParameter(valid_563957, JString, required = true,
                                 default = nil)
  if valid_563957 != nil:
    section.add "resourceName", valid_563957
  result.add "path", section
  ## parameters in `query` object:
  ##   canFetchContent: JBool
  ##                  : Flag indicating whether or not to return the full content for each applicable favorite. If false, only return summary content for favorites.
  ##   favoriteType: JString
  ##               : The type of favorite. Value can be either shared or user.
  ##   tags: JArray
  ##       : Tags that must be present on each favorite returned.
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   sourceType: JString
  ##             : Source type of favorite to return. When left out, the source type defaults to 'other' (not present in this enum).
  section = newJObject()
  var valid_563958 = query.getOrDefault("canFetchContent")
  valid_563958 = validateParameter(valid_563958, JBool, required = false, default = nil)
  if valid_563958 != nil:
    section.add "canFetchContent", valid_563958
  var valid_563972 = query.getOrDefault("favoriteType")
  valid_563972 = validateParameter(valid_563972, JString, required = false,
                                 default = newJString("shared"))
  if valid_563972 != nil:
    section.add "favoriteType", valid_563972
  var valid_563973 = query.getOrDefault("tags")
  valid_563973 = validateParameter(valid_563973, JArray, required = false,
                                 default = nil)
  if valid_563973 != nil:
    section.add "tags", valid_563973
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563974 = query.getOrDefault("api-version")
  valid_563974 = validateParameter(valid_563974, JString, required = true,
                                 default = nil)
  if valid_563974 != nil:
    section.add "api-version", valid_563974
  var valid_563975 = query.getOrDefault("sourceType")
  valid_563975 = validateParameter(valid_563975, JString, required = false,
                                 default = newJString("retention"))
  if valid_563975 != nil:
    section.add "sourceType", valid_563975
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563998: Call_FavoritesList_563778; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of favorites defined within an Application Insights component.
  ## 
  let valid = call_563998.validator(path, query, header, formData, body)
  let scheme = call_563998.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563998.url(scheme.get, call_563998.host, call_563998.base,
                         call_563998.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563998, url, valid)

proc call*(call_564069: Call_FavoritesList_563778; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; resourceName: string;
          canFetchContent: bool = false; favoriteType: string = "shared";
          tags: JsonNode = nil; sourceType: string = "retention"): Recallable =
  ## favoritesList
  ## Gets a list of favorites defined within an Application Insights component.
  ##   canFetchContent: bool
  ##                  : Flag indicating whether or not to return the full content for each applicable favorite. If false, only return summary content for favorites.
  ##   favoriteType: string
  ##               : The type of favorite. Value can be either shared or user.
  ##   tags: JArray
  ##       : Tags that must be present on each favorite returned.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   sourceType: string
  ##             : Source type of favorite to return. When left out, the source type defaults to 'other' (not present in this enum).
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   resourceName: string (required)
  ##               : The name of the Application Insights component resource.
  var path_564070 = newJObject()
  var query_564072 = newJObject()
  add(query_564072, "canFetchContent", newJBool(canFetchContent))
  add(query_564072, "favoriteType", newJString(favoriteType))
  if tags != nil:
    query_564072.add "tags", tags
  add(query_564072, "api-version", newJString(apiVersion))
  add(query_564072, "sourceType", newJString(sourceType))
  add(path_564070, "subscriptionId", newJString(subscriptionId))
  add(path_564070, "resourceGroupName", newJString(resourceGroupName))
  add(path_564070, "resourceName", newJString(resourceName))
  result = call_564069.call(path_564070, query_564072, nil, nil, nil)

var favoritesList* = Call_FavoritesList_563778(name: "favoritesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Insights/components/{resourceName}/favorites",
    validator: validate_FavoritesList_563779, base: "", url: url_FavoritesList_563780,
    schemes: {Scheme.Https})
type
  Call_FavoritesAdd_564123 = ref object of OpenApiRestCall_563556
proc url_FavoritesAdd_564125(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "favoriteId" in path, "`favoriteId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Insights/components/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/favorites/"),
               (kind: VariableSegment, value: "favoriteId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FavoritesAdd_564124(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds a new favorites to an Application Insights component.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   favoriteId: JString (required)
  ##             : The Id of a specific favorite defined in the Application Insights component
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   resourceName: JString (required)
  ##               : The name of the Application Insights component resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `favoriteId` field"
  var valid_564143 = path.getOrDefault("favoriteId")
  valid_564143 = validateParameter(valid_564143, JString, required = true,
                                 default = nil)
  if valid_564143 != nil:
    section.add "favoriteId", valid_564143
  var valid_564144 = path.getOrDefault("subscriptionId")
  valid_564144 = validateParameter(valid_564144, JString, required = true,
                                 default = nil)
  if valid_564144 != nil:
    section.add "subscriptionId", valid_564144
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
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564147 = query.getOrDefault("api-version")
  valid_564147 = validateParameter(valid_564147, JString, required = true,
                                 default = nil)
  if valid_564147 != nil:
    section.add "api-version", valid_564147
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   favoriteProperties: JObject (required)
  ##                     : Properties that need to be specified to create a new favorite and add it to an Application Insights component.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564149: Call_FavoritesAdd_564123; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a new favorites to an Application Insights component.
  ## 
  let valid = call_564149.validator(path, query, header, formData, body)
  let scheme = call_564149.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564149.url(scheme.get, call_564149.host, call_564149.base,
                         call_564149.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564149, url, valid)

proc call*(call_564150: Call_FavoritesAdd_564123; favoriteId: string;
          apiVersion: string; favoriteProperties: JsonNode; subscriptionId: string;
          resourceGroupName: string; resourceName: string): Recallable =
  ## favoritesAdd
  ## Adds a new favorites to an Application Insights component.
  ##   favoriteId: string (required)
  ##             : The Id of a specific favorite defined in the Application Insights component
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   favoriteProperties: JObject (required)
  ##                     : Properties that need to be specified to create a new favorite and add it to an Application Insights component.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   resourceName: string (required)
  ##               : The name of the Application Insights component resource.
  var path_564151 = newJObject()
  var query_564152 = newJObject()
  var body_564153 = newJObject()
  add(path_564151, "favoriteId", newJString(favoriteId))
  add(query_564152, "api-version", newJString(apiVersion))
  if favoriteProperties != nil:
    body_564153 = favoriteProperties
  add(path_564151, "subscriptionId", newJString(subscriptionId))
  add(path_564151, "resourceGroupName", newJString(resourceGroupName))
  add(path_564151, "resourceName", newJString(resourceName))
  result = call_564150.call(path_564151, query_564152, nil, nil, body_564153)

var favoritesAdd* = Call_FavoritesAdd_564123(name: "favoritesAdd",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Insights/components/{resourceName}/favorites/{favoriteId}",
    validator: validate_FavoritesAdd_564124, base: "", url: url_FavoritesAdd_564125,
    schemes: {Scheme.Https})
type
  Call_FavoritesGet_564111 = ref object of OpenApiRestCall_563556
proc url_FavoritesGet_564113(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "favoriteId" in path, "`favoriteId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Insights/components/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/favorites/"),
               (kind: VariableSegment, value: "favoriteId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FavoritesGet_564112(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a single favorite by its FavoriteId, defined within an Application Insights component.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   favoriteId: JString (required)
  ##             : The Id of a specific favorite defined in the Application Insights component
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   resourceName: JString (required)
  ##               : The name of the Application Insights component resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `favoriteId` field"
  var valid_564114 = path.getOrDefault("favoriteId")
  valid_564114 = validateParameter(valid_564114, JString, required = true,
                                 default = nil)
  if valid_564114 != nil:
    section.add "favoriteId", valid_564114
  var valid_564115 = path.getOrDefault("subscriptionId")
  valid_564115 = validateParameter(valid_564115, JString, required = true,
                                 default = nil)
  if valid_564115 != nil:
    section.add "subscriptionId", valid_564115
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
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564118 = query.getOrDefault("api-version")
  valid_564118 = validateParameter(valid_564118, JString, required = true,
                                 default = nil)
  if valid_564118 != nil:
    section.add "api-version", valid_564118
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564119: Call_FavoritesGet_564111; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a single favorite by its FavoriteId, defined within an Application Insights component.
  ## 
  let valid = call_564119.validator(path, query, header, formData, body)
  let scheme = call_564119.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564119.url(scheme.get, call_564119.host, call_564119.base,
                         call_564119.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564119, url, valid)

proc call*(call_564120: Call_FavoritesGet_564111; favoriteId: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          resourceName: string): Recallable =
  ## favoritesGet
  ## Get a single favorite by its FavoriteId, defined within an Application Insights component.
  ##   favoriteId: string (required)
  ##             : The Id of a specific favorite defined in the Application Insights component
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   resourceName: string (required)
  ##               : The name of the Application Insights component resource.
  var path_564121 = newJObject()
  var query_564122 = newJObject()
  add(path_564121, "favoriteId", newJString(favoriteId))
  add(query_564122, "api-version", newJString(apiVersion))
  add(path_564121, "subscriptionId", newJString(subscriptionId))
  add(path_564121, "resourceGroupName", newJString(resourceGroupName))
  add(path_564121, "resourceName", newJString(resourceName))
  result = call_564120.call(path_564121, query_564122, nil, nil, nil)

var favoritesGet* = Call_FavoritesGet_564111(name: "favoritesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Insights/components/{resourceName}/favorites/{favoriteId}",
    validator: validate_FavoritesGet_564112, base: "", url: url_FavoritesGet_564113,
    schemes: {Scheme.Https})
type
  Call_FavoritesUpdate_564166 = ref object of OpenApiRestCall_563556
proc url_FavoritesUpdate_564168(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "favoriteId" in path, "`favoriteId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Insights/components/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/favorites/"),
               (kind: VariableSegment, value: "favoriteId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FavoritesUpdate_564167(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Updates a favorite that has already been added to an Application Insights component.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   favoriteId: JString (required)
  ##             : The Id of a specific favorite defined in the Application Insights component
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   resourceName: JString (required)
  ##               : The name of the Application Insights component resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `favoriteId` field"
  var valid_564169 = path.getOrDefault("favoriteId")
  valid_564169 = validateParameter(valid_564169, JString, required = true,
                                 default = nil)
  if valid_564169 != nil:
    section.add "favoriteId", valid_564169
  var valid_564170 = path.getOrDefault("subscriptionId")
  valid_564170 = validateParameter(valid_564170, JString, required = true,
                                 default = nil)
  if valid_564170 != nil:
    section.add "subscriptionId", valid_564170
  var valid_564171 = path.getOrDefault("resourceGroupName")
  valid_564171 = validateParameter(valid_564171, JString, required = true,
                                 default = nil)
  if valid_564171 != nil:
    section.add "resourceGroupName", valid_564171
  var valid_564172 = path.getOrDefault("resourceName")
  valid_564172 = validateParameter(valid_564172, JString, required = true,
                                 default = nil)
  if valid_564172 != nil:
    section.add "resourceName", valid_564172
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564173 = query.getOrDefault("api-version")
  valid_564173 = validateParameter(valid_564173, JString, required = true,
                                 default = nil)
  if valid_564173 != nil:
    section.add "api-version", valid_564173
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   favoriteProperties: JObject (required)
  ##                     : Properties that need to be specified to update the existing favorite.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564175: Call_FavoritesUpdate_564166; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a favorite that has already been added to an Application Insights component.
  ## 
  let valid = call_564175.validator(path, query, header, formData, body)
  let scheme = call_564175.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564175.url(scheme.get, call_564175.host, call_564175.base,
                         call_564175.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564175, url, valid)

proc call*(call_564176: Call_FavoritesUpdate_564166; favoriteId: string;
          apiVersion: string; favoriteProperties: JsonNode; subscriptionId: string;
          resourceGroupName: string; resourceName: string): Recallable =
  ## favoritesUpdate
  ## Updates a favorite that has already been added to an Application Insights component.
  ##   favoriteId: string (required)
  ##             : The Id of a specific favorite defined in the Application Insights component
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   favoriteProperties: JObject (required)
  ##                     : Properties that need to be specified to update the existing favorite.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   resourceName: string (required)
  ##               : The name of the Application Insights component resource.
  var path_564177 = newJObject()
  var query_564178 = newJObject()
  var body_564179 = newJObject()
  add(path_564177, "favoriteId", newJString(favoriteId))
  add(query_564178, "api-version", newJString(apiVersion))
  if favoriteProperties != nil:
    body_564179 = favoriteProperties
  add(path_564177, "subscriptionId", newJString(subscriptionId))
  add(path_564177, "resourceGroupName", newJString(resourceGroupName))
  add(path_564177, "resourceName", newJString(resourceName))
  result = call_564176.call(path_564177, query_564178, nil, nil, body_564179)

var favoritesUpdate* = Call_FavoritesUpdate_564166(name: "favoritesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Insights/components/{resourceName}/favorites/{favoriteId}",
    validator: validate_FavoritesUpdate_564167, base: "", url: url_FavoritesUpdate_564168,
    schemes: {Scheme.Https})
type
  Call_FavoritesDelete_564154 = ref object of OpenApiRestCall_563556
proc url_FavoritesDelete_564156(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "favoriteId" in path, "`favoriteId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Insights/components/"),
               (kind: VariableSegment, value: "resourceName"),
               (kind: ConstantSegment, value: "/favorites/"),
               (kind: VariableSegment, value: "favoriteId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FavoritesDelete_564155(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Remove a favorite that is associated to an Application Insights component.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   favoriteId: JString (required)
  ##             : The Id of a specific favorite defined in the Application Insights component
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   resourceName: JString (required)
  ##               : The name of the Application Insights component resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `favoriteId` field"
  var valid_564157 = path.getOrDefault("favoriteId")
  valid_564157 = validateParameter(valid_564157, JString, required = true,
                                 default = nil)
  if valid_564157 != nil:
    section.add "favoriteId", valid_564157
  var valid_564158 = path.getOrDefault("subscriptionId")
  valid_564158 = validateParameter(valid_564158, JString, required = true,
                                 default = nil)
  if valid_564158 != nil:
    section.add "subscriptionId", valid_564158
  var valid_564159 = path.getOrDefault("resourceGroupName")
  valid_564159 = validateParameter(valid_564159, JString, required = true,
                                 default = nil)
  if valid_564159 != nil:
    section.add "resourceGroupName", valid_564159
  var valid_564160 = path.getOrDefault("resourceName")
  valid_564160 = validateParameter(valid_564160, JString, required = true,
                                 default = nil)
  if valid_564160 != nil:
    section.add "resourceName", valid_564160
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564161 = query.getOrDefault("api-version")
  valid_564161 = validateParameter(valid_564161, JString, required = true,
                                 default = nil)
  if valid_564161 != nil:
    section.add "api-version", valid_564161
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564162: Call_FavoritesDelete_564154; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Remove a favorite that is associated to an Application Insights component.
  ## 
  let valid = call_564162.validator(path, query, header, formData, body)
  let scheme = call_564162.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564162.url(scheme.get, call_564162.host, call_564162.base,
                         call_564162.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564162, url, valid)

proc call*(call_564163: Call_FavoritesDelete_564154; favoriteId: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          resourceName: string): Recallable =
  ## favoritesDelete
  ## Remove a favorite that is associated to an Application Insights component.
  ##   favoriteId: string (required)
  ##             : The Id of a specific favorite defined in the Application Insights component
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   resourceName: string (required)
  ##               : The name of the Application Insights component resource.
  var path_564164 = newJObject()
  var query_564165 = newJObject()
  add(path_564164, "favoriteId", newJString(favoriteId))
  add(query_564165, "api-version", newJString(apiVersion))
  add(path_564164, "subscriptionId", newJString(subscriptionId))
  add(path_564164, "resourceGroupName", newJString(resourceGroupName))
  add(path_564164, "resourceName", newJString(resourceName))
  result = call_564163.call(path_564164, query_564165, nil, nil, nil)

var favoritesDelete* = Call_FavoritesDelete_564154(name: "favoritesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Insights/components/{resourceName}/favorites/{favoriteId}",
    validator: validate_FavoritesDelete_564155, base: "", url: url_FavoritesDelete_564156,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
