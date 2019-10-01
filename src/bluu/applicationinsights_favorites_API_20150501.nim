
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_596458 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_596458](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_596458): Option[Scheme] {.used.} =
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
  macServiceName = "applicationinsights-favorites_API"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_FavoritesList_596680 = ref object of OpenApiRestCall_596458
proc url_FavoritesList_596682(protocol: Scheme; host: string; base: string;
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

proc validate_FavoritesList_596681(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_596855 = path.getOrDefault("resourceGroupName")
  valid_596855 = validateParameter(valid_596855, JString, required = true,
                                 default = nil)
  if valid_596855 != nil:
    section.add "resourceGroupName", valid_596855
  var valid_596856 = path.getOrDefault("subscriptionId")
  valid_596856 = validateParameter(valid_596856, JString, required = true,
                                 default = nil)
  if valid_596856 != nil:
    section.add "subscriptionId", valid_596856
  var valid_596857 = path.getOrDefault("resourceName")
  valid_596857 = validateParameter(valid_596857, JString, required = true,
                                 default = nil)
  if valid_596857 != nil:
    section.add "resourceName", valid_596857
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
  var valid_596858 = query.getOrDefault("api-version")
  valid_596858 = validateParameter(valid_596858, JString, required = true,
                                 default = nil)
  if valid_596858 != nil:
    section.add "api-version", valid_596858
  var valid_596872 = query.getOrDefault("sourceType")
  valid_596872 = validateParameter(valid_596872, JString, required = false,
                                 default = newJString("retention"))
  if valid_596872 != nil:
    section.add "sourceType", valid_596872
  var valid_596873 = query.getOrDefault("tags")
  valid_596873 = validateParameter(valid_596873, JArray, required = false,
                                 default = nil)
  if valid_596873 != nil:
    section.add "tags", valid_596873
  var valid_596874 = query.getOrDefault("canFetchContent")
  valid_596874 = validateParameter(valid_596874, JBool, required = false, default = nil)
  if valid_596874 != nil:
    section.add "canFetchContent", valid_596874
  var valid_596875 = query.getOrDefault("favoriteType")
  valid_596875 = validateParameter(valid_596875, JString, required = false,
                                 default = newJString("shared"))
  if valid_596875 != nil:
    section.add "favoriteType", valid_596875
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_596898: Call_FavoritesList_596680; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of favorites defined within an Application Insights component.
  ## 
  let valid = call_596898.validator(path, query, header, formData, body)
  let scheme = call_596898.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596898.url(scheme.get, call_596898.host, call_596898.base,
                         call_596898.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596898, url, valid)

proc call*(call_596969: Call_FavoritesList_596680; resourceGroupName: string;
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
  var path_596970 = newJObject()
  var query_596972 = newJObject()
  add(path_596970, "resourceGroupName", newJString(resourceGroupName))
  add(query_596972, "api-version", newJString(apiVersion))
  add(path_596970, "subscriptionId", newJString(subscriptionId))
  add(path_596970, "resourceName", newJString(resourceName))
  add(query_596972, "sourceType", newJString(sourceType))
  if tags != nil:
    query_596972.add "tags", tags
  add(query_596972, "canFetchContent", newJBool(canFetchContent))
  add(query_596972, "favoriteType", newJString(favoriteType))
  result = call_596969.call(path_596970, query_596972, nil, nil, nil)

var favoritesList* = Call_FavoritesList_596680(name: "favoritesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Insights/components/{resourceName}/favorites",
    validator: validate_FavoritesList_596681, base: "", url: url_FavoritesList_596682,
    schemes: {Scheme.Https})
type
  Call_FavoritesAdd_597023 = ref object of OpenApiRestCall_596458
proc url_FavoritesAdd_597025(protocol: Scheme; host: string; base: string;
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

proc validate_FavoritesAdd_597024(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_597043 = path.getOrDefault("favoriteId")
  valid_597043 = validateParameter(valid_597043, JString, required = true,
                                 default = nil)
  if valid_597043 != nil:
    section.add "favoriteId", valid_597043
  var valid_597044 = path.getOrDefault("resourceGroupName")
  valid_597044 = validateParameter(valid_597044, JString, required = true,
                                 default = nil)
  if valid_597044 != nil:
    section.add "resourceGroupName", valid_597044
  var valid_597045 = path.getOrDefault("subscriptionId")
  valid_597045 = validateParameter(valid_597045, JString, required = true,
                                 default = nil)
  if valid_597045 != nil:
    section.add "subscriptionId", valid_597045
  var valid_597046 = path.getOrDefault("resourceName")
  valid_597046 = validateParameter(valid_597046, JString, required = true,
                                 default = nil)
  if valid_597046 != nil:
    section.add "resourceName", valid_597046
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597047 = query.getOrDefault("api-version")
  valid_597047 = validateParameter(valid_597047, JString, required = true,
                                 default = nil)
  if valid_597047 != nil:
    section.add "api-version", valid_597047
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

proc call*(call_597049: Call_FavoritesAdd_597023; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a new favorites to an Application Insights component.
  ## 
  let valid = call_597049.validator(path, query, header, formData, body)
  let scheme = call_597049.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597049.url(scheme.get, call_597049.host, call_597049.base,
                         call_597049.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597049, url, valid)

proc call*(call_597050: Call_FavoritesAdd_597023; favoriteId: string;
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
  var path_597051 = newJObject()
  var query_597052 = newJObject()
  var body_597053 = newJObject()
  add(path_597051, "favoriteId", newJString(favoriteId))
  add(path_597051, "resourceGroupName", newJString(resourceGroupName))
  add(query_597052, "api-version", newJString(apiVersion))
  add(path_597051, "subscriptionId", newJString(subscriptionId))
  add(path_597051, "resourceName", newJString(resourceName))
  if favoriteProperties != nil:
    body_597053 = favoriteProperties
  result = call_597050.call(path_597051, query_597052, nil, nil, body_597053)

var favoritesAdd* = Call_FavoritesAdd_597023(name: "favoritesAdd",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Insights/components/{resourceName}/favorites/{favoriteId}",
    validator: validate_FavoritesAdd_597024, base: "", url: url_FavoritesAdd_597025,
    schemes: {Scheme.Https})
type
  Call_FavoritesGet_597011 = ref object of OpenApiRestCall_596458
proc url_FavoritesGet_597013(protocol: Scheme; host: string; base: string;
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

proc validate_FavoritesGet_597012(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_597014 = path.getOrDefault("favoriteId")
  valid_597014 = validateParameter(valid_597014, JString, required = true,
                                 default = nil)
  if valid_597014 != nil:
    section.add "favoriteId", valid_597014
  var valid_597015 = path.getOrDefault("resourceGroupName")
  valid_597015 = validateParameter(valid_597015, JString, required = true,
                                 default = nil)
  if valid_597015 != nil:
    section.add "resourceGroupName", valid_597015
  var valid_597016 = path.getOrDefault("subscriptionId")
  valid_597016 = validateParameter(valid_597016, JString, required = true,
                                 default = nil)
  if valid_597016 != nil:
    section.add "subscriptionId", valid_597016
  var valid_597017 = path.getOrDefault("resourceName")
  valid_597017 = validateParameter(valid_597017, JString, required = true,
                                 default = nil)
  if valid_597017 != nil:
    section.add "resourceName", valid_597017
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597018 = query.getOrDefault("api-version")
  valid_597018 = validateParameter(valid_597018, JString, required = true,
                                 default = nil)
  if valid_597018 != nil:
    section.add "api-version", valid_597018
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597019: Call_FavoritesGet_597011; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a single favorite by its FavoriteId, defined within an Application Insights component.
  ## 
  let valid = call_597019.validator(path, query, header, formData, body)
  let scheme = call_597019.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597019.url(scheme.get, call_597019.host, call_597019.base,
                         call_597019.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597019, url, valid)

proc call*(call_597020: Call_FavoritesGet_597011; favoriteId: string;
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
  var path_597021 = newJObject()
  var query_597022 = newJObject()
  add(path_597021, "favoriteId", newJString(favoriteId))
  add(path_597021, "resourceGroupName", newJString(resourceGroupName))
  add(query_597022, "api-version", newJString(apiVersion))
  add(path_597021, "subscriptionId", newJString(subscriptionId))
  add(path_597021, "resourceName", newJString(resourceName))
  result = call_597020.call(path_597021, query_597022, nil, nil, nil)

var favoritesGet* = Call_FavoritesGet_597011(name: "favoritesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Insights/components/{resourceName}/favorites/{favoriteId}",
    validator: validate_FavoritesGet_597012, base: "", url: url_FavoritesGet_597013,
    schemes: {Scheme.Https})
type
  Call_FavoritesUpdate_597066 = ref object of OpenApiRestCall_596458
proc url_FavoritesUpdate_597068(protocol: Scheme; host: string; base: string;
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

proc validate_FavoritesUpdate_597067(path: JsonNode; query: JsonNode;
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
  var valid_597069 = path.getOrDefault("favoriteId")
  valid_597069 = validateParameter(valid_597069, JString, required = true,
                                 default = nil)
  if valid_597069 != nil:
    section.add "favoriteId", valid_597069
  var valid_597070 = path.getOrDefault("resourceGroupName")
  valid_597070 = validateParameter(valid_597070, JString, required = true,
                                 default = nil)
  if valid_597070 != nil:
    section.add "resourceGroupName", valid_597070
  var valid_597071 = path.getOrDefault("subscriptionId")
  valid_597071 = validateParameter(valid_597071, JString, required = true,
                                 default = nil)
  if valid_597071 != nil:
    section.add "subscriptionId", valid_597071
  var valid_597072 = path.getOrDefault("resourceName")
  valid_597072 = validateParameter(valid_597072, JString, required = true,
                                 default = nil)
  if valid_597072 != nil:
    section.add "resourceName", valid_597072
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597073 = query.getOrDefault("api-version")
  valid_597073 = validateParameter(valid_597073, JString, required = true,
                                 default = nil)
  if valid_597073 != nil:
    section.add "api-version", valid_597073
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

proc call*(call_597075: Call_FavoritesUpdate_597066; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a favorite that has already been added to an Application Insights component.
  ## 
  let valid = call_597075.validator(path, query, header, formData, body)
  let scheme = call_597075.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597075.url(scheme.get, call_597075.host, call_597075.base,
                         call_597075.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597075, url, valid)

proc call*(call_597076: Call_FavoritesUpdate_597066; favoriteId: string;
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
  var path_597077 = newJObject()
  var query_597078 = newJObject()
  var body_597079 = newJObject()
  add(path_597077, "favoriteId", newJString(favoriteId))
  add(path_597077, "resourceGroupName", newJString(resourceGroupName))
  add(query_597078, "api-version", newJString(apiVersion))
  add(path_597077, "subscriptionId", newJString(subscriptionId))
  add(path_597077, "resourceName", newJString(resourceName))
  if favoriteProperties != nil:
    body_597079 = favoriteProperties
  result = call_597076.call(path_597077, query_597078, nil, nil, body_597079)

var favoritesUpdate* = Call_FavoritesUpdate_597066(name: "favoritesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Insights/components/{resourceName}/favorites/{favoriteId}",
    validator: validate_FavoritesUpdate_597067, base: "", url: url_FavoritesUpdate_597068,
    schemes: {Scheme.Https})
type
  Call_FavoritesDelete_597054 = ref object of OpenApiRestCall_596458
proc url_FavoritesDelete_597056(protocol: Scheme; host: string; base: string;
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

proc validate_FavoritesDelete_597055(path: JsonNode; query: JsonNode;
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
  var valid_597057 = path.getOrDefault("favoriteId")
  valid_597057 = validateParameter(valid_597057, JString, required = true,
                                 default = nil)
  if valid_597057 != nil:
    section.add "favoriteId", valid_597057
  var valid_597058 = path.getOrDefault("resourceGroupName")
  valid_597058 = validateParameter(valid_597058, JString, required = true,
                                 default = nil)
  if valid_597058 != nil:
    section.add "resourceGroupName", valid_597058
  var valid_597059 = path.getOrDefault("subscriptionId")
  valid_597059 = validateParameter(valid_597059, JString, required = true,
                                 default = nil)
  if valid_597059 != nil:
    section.add "subscriptionId", valid_597059
  var valid_597060 = path.getOrDefault("resourceName")
  valid_597060 = validateParameter(valid_597060, JString, required = true,
                                 default = nil)
  if valid_597060 != nil:
    section.add "resourceName", valid_597060
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597061 = query.getOrDefault("api-version")
  valid_597061 = validateParameter(valid_597061, JString, required = true,
                                 default = nil)
  if valid_597061 != nil:
    section.add "api-version", valid_597061
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597062: Call_FavoritesDelete_597054; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Remove a favorite that is associated to an Application Insights component.
  ## 
  let valid = call_597062.validator(path, query, header, formData, body)
  let scheme = call_597062.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597062.url(scheme.get, call_597062.host, call_597062.base,
                         call_597062.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597062, url, valid)

proc call*(call_597063: Call_FavoritesDelete_597054; favoriteId: string;
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
  var path_597064 = newJObject()
  var query_597065 = newJObject()
  add(path_597064, "favoriteId", newJString(favoriteId))
  add(path_597064, "resourceGroupName", newJString(resourceGroupName))
  add(query_597065, "api-version", newJString(apiVersion))
  add(path_597064, "subscriptionId", newJString(subscriptionId))
  add(path_597064, "resourceName", newJString(resourceName))
  result = call_597063.call(path_597064, query_597065, nil, nil, nil)

var favoritesDelete* = Call_FavoritesDelete_597054(name: "favoritesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Insights/components/{resourceName}/favorites/{favoriteId}",
    validator: validate_FavoritesDelete_597055, base: "", url: url_FavoritesDelete_597056,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
