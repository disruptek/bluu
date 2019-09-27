
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593425 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593425](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593425): Option[Scheme] {.used.} =
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
proc queryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] =
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
  macServiceName = "applicationinsights-favorites_API"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_FavoritesList_593647 = ref object of OpenApiRestCall_593425
proc url_FavoritesList_593649(protocol: Scheme; host: string; base: string;
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

proc validate_FavoritesList_593648(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of favorites defined within an Application Insights component.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: JString (required)
  ##               : The name of the Application Insights component resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593822 = path.getOrDefault("resourceGroupName")
  valid_593822 = validateParameter(valid_593822, JString, required = true,
                                 default = nil)
  if valid_593822 != nil:
    section.add "resourceGroupName", valid_593822
  var valid_593823 = path.getOrDefault("subscriptionId")
  valid_593823 = validateParameter(valid_593823, JString, required = true,
                                 default = nil)
  if valid_593823 != nil:
    section.add "subscriptionId", valid_593823
  var valid_593824 = path.getOrDefault("resourceName")
  valid_593824 = validateParameter(valid_593824, JString, required = true,
                                 default = nil)
  if valid_593824 != nil:
    section.add "resourceName", valid_593824
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   sourceType: JString
  ##             : Source type of favorite to return. When left out, the source type defaults to 'other' (not present in this enum).
  ##   tags: JArray
  ##       : Tags that must be present on each favorite returned.
  ##   canFetchContent: JBool
  ##                  : Flag indicating whether or not to return the full content for each applicable favorite. If false, only return summary content for favorites.
  ##   favoriteType: JString
  ##               : The type of favorite. Value can be either shared or user.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593825 = query.getOrDefault("api-version")
  valid_593825 = validateParameter(valid_593825, JString, required = true,
                                 default = nil)
  if valid_593825 != nil:
    section.add "api-version", valid_593825
  var valid_593839 = query.getOrDefault("sourceType")
  valid_593839 = validateParameter(valid_593839, JString, required = false,
                                 default = newJString("retention"))
  if valid_593839 != nil:
    section.add "sourceType", valid_593839
  var valid_593840 = query.getOrDefault("tags")
  valid_593840 = validateParameter(valid_593840, JArray, required = false,
                                 default = nil)
  if valid_593840 != nil:
    section.add "tags", valid_593840
  var valid_593841 = query.getOrDefault("canFetchContent")
  valid_593841 = validateParameter(valid_593841, JBool, required = false, default = nil)
  if valid_593841 != nil:
    section.add "canFetchContent", valid_593841
  var valid_593842 = query.getOrDefault("favoriteType")
  valid_593842 = validateParameter(valid_593842, JString, required = false,
                                 default = newJString("shared"))
  if valid_593842 != nil:
    section.add "favoriteType", valid_593842
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593865: Call_FavoritesList_593647; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of favorites defined within an Application Insights component.
  ## 
  let valid = call_593865.validator(path, query, header, formData, body)
  let scheme = call_593865.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593865.url(scheme.get, call_593865.host, call_593865.base,
                         call_593865.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593865, url, valid)

proc call*(call_593936: Call_FavoritesList_593647; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; resourceName: string;
          sourceType: string = "retention"; tags: JsonNode = nil;
          canFetchContent: bool = false; favoriteType: string = "shared"): Recallable =
  ## favoritesList
  ## Gets a list of favorites defined within an Application Insights component.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: string (required)
  ##               : The name of the Application Insights component resource.
  ##   sourceType: string
  ##             : Source type of favorite to return. When left out, the source type defaults to 'other' (not present in this enum).
  ##   tags: JArray
  ##       : Tags that must be present on each favorite returned.
  ##   canFetchContent: bool
  ##                  : Flag indicating whether or not to return the full content for each applicable favorite. If false, only return summary content for favorites.
  ##   favoriteType: string
  ##               : The type of favorite. Value can be either shared or user.
  var path_593937 = newJObject()
  var query_593939 = newJObject()
  add(path_593937, "resourceGroupName", newJString(resourceGroupName))
  add(query_593939, "api-version", newJString(apiVersion))
  add(path_593937, "subscriptionId", newJString(subscriptionId))
  add(path_593937, "resourceName", newJString(resourceName))
  add(query_593939, "sourceType", newJString(sourceType))
  if tags != nil:
    query_593939.add "tags", tags
  add(query_593939, "canFetchContent", newJBool(canFetchContent))
  add(query_593939, "favoriteType", newJString(favoriteType))
  result = call_593936.call(path_593937, query_593939, nil, nil, nil)

var favoritesList* = Call_FavoritesList_593647(name: "favoritesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Insights/components/{resourceName}/favorites",
    validator: validate_FavoritesList_593648, base: "", url: url_FavoritesList_593649,
    schemes: {Scheme.Https})
type
  Call_FavoritesAdd_593990 = ref object of OpenApiRestCall_593425
proc url_FavoritesAdd_593992(protocol: Scheme; host: string; base: string;
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

proc validate_FavoritesAdd_593991(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds a new favorites to an Application Insights component.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   favoriteId: JString (required)
  ##             : The Id of a specific favorite defined in the Application Insights component
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: JString (required)
  ##               : The name of the Application Insights component resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `favoriteId` field"
  var valid_594010 = path.getOrDefault("favoriteId")
  valid_594010 = validateParameter(valid_594010, JString, required = true,
                                 default = nil)
  if valid_594010 != nil:
    section.add "favoriteId", valid_594010
  var valid_594011 = path.getOrDefault("resourceGroupName")
  valid_594011 = validateParameter(valid_594011, JString, required = true,
                                 default = nil)
  if valid_594011 != nil:
    section.add "resourceGroupName", valid_594011
  var valid_594012 = path.getOrDefault("subscriptionId")
  valid_594012 = validateParameter(valid_594012, JString, required = true,
                                 default = nil)
  if valid_594012 != nil:
    section.add "subscriptionId", valid_594012
  var valid_594013 = path.getOrDefault("resourceName")
  valid_594013 = validateParameter(valid_594013, JString, required = true,
                                 default = nil)
  if valid_594013 != nil:
    section.add "resourceName", valid_594013
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594014 = query.getOrDefault("api-version")
  valid_594014 = validateParameter(valid_594014, JString, required = true,
                                 default = nil)
  if valid_594014 != nil:
    section.add "api-version", valid_594014
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

proc call*(call_594016: Call_FavoritesAdd_593990; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a new favorites to an Application Insights component.
  ## 
  let valid = call_594016.validator(path, query, header, formData, body)
  let scheme = call_594016.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594016.url(scheme.get, call_594016.host, call_594016.base,
                         call_594016.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594016, url, valid)

proc call*(call_594017: Call_FavoritesAdd_593990; favoriteId: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; favoriteProperties: JsonNode): Recallable =
  ## favoritesAdd
  ## Adds a new favorites to an Application Insights component.
  ##   favoriteId: string (required)
  ##             : The Id of a specific favorite defined in the Application Insights component
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: string (required)
  ##               : The name of the Application Insights component resource.
  ##   favoriteProperties: JObject (required)
  ##                     : Properties that need to be specified to create a new favorite and add it to an Application Insights component.
  var path_594018 = newJObject()
  var query_594019 = newJObject()
  var body_594020 = newJObject()
  add(path_594018, "favoriteId", newJString(favoriteId))
  add(path_594018, "resourceGroupName", newJString(resourceGroupName))
  add(query_594019, "api-version", newJString(apiVersion))
  add(path_594018, "subscriptionId", newJString(subscriptionId))
  add(path_594018, "resourceName", newJString(resourceName))
  if favoriteProperties != nil:
    body_594020 = favoriteProperties
  result = call_594017.call(path_594018, query_594019, nil, nil, body_594020)

var favoritesAdd* = Call_FavoritesAdd_593990(name: "favoritesAdd",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Insights/components/{resourceName}/favorites/{favoriteId}",
    validator: validate_FavoritesAdd_593991, base: "", url: url_FavoritesAdd_593992,
    schemes: {Scheme.Https})
type
  Call_FavoritesGet_593978 = ref object of OpenApiRestCall_593425
proc url_FavoritesGet_593980(protocol: Scheme; host: string; base: string;
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

proc validate_FavoritesGet_593979(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a single favorite by its FavoriteId, defined within an Application Insights component.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   favoriteId: JString (required)
  ##             : The Id of a specific favorite defined in the Application Insights component
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: JString (required)
  ##               : The name of the Application Insights component resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `favoriteId` field"
  var valid_593981 = path.getOrDefault("favoriteId")
  valid_593981 = validateParameter(valid_593981, JString, required = true,
                                 default = nil)
  if valid_593981 != nil:
    section.add "favoriteId", valid_593981
  var valid_593982 = path.getOrDefault("resourceGroupName")
  valid_593982 = validateParameter(valid_593982, JString, required = true,
                                 default = nil)
  if valid_593982 != nil:
    section.add "resourceGroupName", valid_593982
  var valid_593983 = path.getOrDefault("subscriptionId")
  valid_593983 = validateParameter(valid_593983, JString, required = true,
                                 default = nil)
  if valid_593983 != nil:
    section.add "subscriptionId", valid_593983
  var valid_593984 = path.getOrDefault("resourceName")
  valid_593984 = validateParameter(valid_593984, JString, required = true,
                                 default = nil)
  if valid_593984 != nil:
    section.add "resourceName", valid_593984
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593985 = query.getOrDefault("api-version")
  valid_593985 = validateParameter(valid_593985, JString, required = true,
                                 default = nil)
  if valid_593985 != nil:
    section.add "api-version", valid_593985
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593986: Call_FavoritesGet_593978; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a single favorite by its FavoriteId, defined within an Application Insights component.
  ## 
  let valid = call_593986.validator(path, query, header, formData, body)
  let scheme = call_593986.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593986.url(scheme.get, call_593986.host, call_593986.base,
                         call_593986.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593986, url, valid)

proc call*(call_593987: Call_FavoritesGet_593978; favoriteId: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string): Recallable =
  ## favoritesGet
  ## Get a single favorite by its FavoriteId, defined within an Application Insights component.
  ##   favoriteId: string (required)
  ##             : The Id of a specific favorite defined in the Application Insights component
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: string (required)
  ##               : The name of the Application Insights component resource.
  var path_593988 = newJObject()
  var query_593989 = newJObject()
  add(path_593988, "favoriteId", newJString(favoriteId))
  add(path_593988, "resourceGroupName", newJString(resourceGroupName))
  add(query_593989, "api-version", newJString(apiVersion))
  add(path_593988, "subscriptionId", newJString(subscriptionId))
  add(path_593988, "resourceName", newJString(resourceName))
  result = call_593987.call(path_593988, query_593989, nil, nil, nil)

var favoritesGet* = Call_FavoritesGet_593978(name: "favoritesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Insights/components/{resourceName}/favorites/{favoriteId}",
    validator: validate_FavoritesGet_593979, base: "", url: url_FavoritesGet_593980,
    schemes: {Scheme.Https})
type
  Call_FavoritesUpdate_594033 = ref object of OpenApiRestCall_593425
proc url_FavoritesUpdate_594035(protocol: Scheme; host: string; base: string;
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

proc validate_FavoritesUpdate_594034(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Updates a favorite that has already been added to an Application Insights component.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   favoriteId: JString (required)
  ##             : The Id of a specific favorite defined in the Application Insights component
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: JString (required)
  ##               : The name of the Application Insights component resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `favoriteId` field"
  var valid_594036 = path.getOrDefault("favoriteId")
  valid_594036 = validateParameter(valid_594036, JString, required = true,
                                 default = nil)
  if valid_594036 != nil:
    section.add "favoriteId", valid_594036
  var valid_594037 = path.getOrDefault("resourceGroupName")
  valid_594037 = validateParameter(valid_594037, JString, required = true,
                                 default = nil)
  if valid_594037 != nil:
    section.add "resourceGroupName", valid_594037
  var valid_594038 = path.getOrDefault("subscriptionId")
  valid_594038 = validateParameter(valid_594038, JString, required = true,
                                 default = nil)
  if valid_594038 != nil:
    section.add "subscriptionId", valid_594038
  var valid_594039 = path.getOrDefault("resourceName")
  valid_594039 = validateParameter(valid_594039, JString, required = true,
                                 default = nil)
  if valid_594039 != nil:
    section.add "resourceName", valid_594039
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594040 = query.getOrDefault("api-version")
  valid_594040 = validateParameter(valid_594040, JString, required = true,
                                 default = nil)
  if valid_594040 != nil:
    section.add "api-version", valid_594040
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

proc call*(call_594042: Call_FavoritesUpdate_594033; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a favorite that has already been added to an Application Insights component.
  ## 
  let valid = call_594042.validator(path, query, header, formData, body)
  let scheme = call_594042.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594042.url(scheme.get, call_594042.host, call_594042.base,
                         call_594042.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594042, url, valid)

proc call*(call_594043: Call_FavoritesUpdate_594033; favoriteId: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; favoriteProperties: JsonNode): Recallable =
  ## favoritesUpdate
  ## Updates a favorite that has already been added to an Application Insights component.
  ##   favoriteId: string (required)
  ##             : The Id of a specific favorite defined in the Application Insights component
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: string (required)
  ##               : The name of the Application Insights component resource.
  ##   favoriteProperties: JObject (required)
  ##                     : Properties that need to be specified to update the existing favorite.
  var path_594044 = newJObject()
  var query_594045 = newJObject()
  var body_594046 = newJObject()
  add(path_594044, "favoriteId", newJString(favoriteId))
  add(path_594044, "resourceGroupName", newJString(resourceGroupName))
  add(query_594045, "api-version", newJString(apiVersion))
  add(path_594044, "subscriptionId", newJString(subscriptionId))
  add(path_594044, "resourceName", newJString(resourceName))
  if favoriteProperties != nil:
    body_594046 = favoriteProperties
  result = call_594043.call(path_594044, query_594045, nil, nil, body_594046)

var favoritesUpdate* = Call_FavoritesUpdate_594033(name: "favoritesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Insights/components/{resourceName}/favorites/{favoriteId}",
    validator: validate_FavoritesUpdate_594034, base: "", url: url_FavoritesUpdate_594035,
    schemes: {Scheme.Https})
type
  Call_FavoritesDelete_594021 = ref object of OpenApiRestCall_593425
proc url_FavoritesDelete_594023(protocol: Scheme; host: string; base: string;
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

proc validate_FavoritesDelete_594022(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Remove a favorite that is associated to an Application Insights component.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   favoriteId: JString (required)
  ##             : The Id of a specific favorite defined in the Application Insights component
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: JString (required)
  ##               : The name of the Application Insights component resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `favoriteId` field"
  var valid_594024 = path.getOrDefault("favoriteId")
  valid_594024 = validateParameter(valid_594024, JString, required = true,
                                 default = nil)
  if valid_594024 != nil:
    section.add "favoriteId", valid_594024
  var valid_594025 = path.getOrDefault("resourceGroupName")
  valid_594025 = validateParameter(valid_594025, JString, required = true,
                                 default = nil)
  if valid_594025 != nil:
    section.add "resourceGroupName", valid_594025
  var valid_594026 = path.getOrDefault("subscriptionId")
  valid_594026 = validateParameter(valid_594026, JString, required = true,
                                 default = nil)
  if valid_594026 != nil:
    section.add "subscriptionId", valid_594026
  var valid_594027 = path.getOrDefault("resourceName")
  valid_594027 = validateParameter(valid_594027, JString, required = true,
                                 default = nil)
  if valid_594027 != nil:
    section.add "resourceName", valid_594027
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594028 = query.getOrDefault("api-version")
  valid_594028 = validateParameter(valid_594028, JString, required = true,
                                 default = nil)
  if valid_594028 != nil:
    section.add "api-version", valid_594028
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594029: Call_FavoritesDelete_594021; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Remove a favorite that is associated to an Application Insights component.
  ## 
  let valid = call_594029.validator(path, query, header, formData, body)
  let scheme = call_594029.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594029.url(scheme.get, call_594029.host, call_594029.base,
                         call_594029.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594029, url, valid)

proc call*(call_594030: Call_FavoritesDelete_594021; favoriteId: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string): Recallable =
  ## favoritesDelete
  ## Remove a favorite that is associated to an Application Insights component.
  ##   favoriteId: string (required)
  ##             : The Id of a specific favorite defined in the Application Insights component
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: string (required)
  ##               : The name of the Application Insights component resource.
  var path_594031 = newJObject()
  var query_594032 = newJObject()
  add(path_594031, "favoriteId", newJString(favoriteId))
  add(path_594031, "resourceGroupName", newJString(resourceGroupName))
  add(query_594032, "api-version", newJString(apiVersion))
  add(path_594031, "subscriptionId", newJString(subscriptionId))
  add(path_594031, "resourceName", newJString(resourceName))
  result = call_594030.call(path_594031, query_594032, nil, nil, nil)

var favoritesDelete* = Call_FavoritesDelete_594021(name: "favoritesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Insights/components/{resourceName}/favorites/{favoriteId}",
    validator: validate_FavoritesDelete_594022, base: "", url: url_FavoritesDelete_594023,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
