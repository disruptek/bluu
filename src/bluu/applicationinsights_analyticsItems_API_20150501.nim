
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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
  macServiceName = "applicationinsights-analyticsItems_API"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AnalyticsItemsList_593647 = ref object of OpenApiRestCall_593425
proc url_AnalyticsItemsList_593649(protocol: Scheme; host: string; base: string;
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

proc validate_AnalyticsItemsList_593648(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets a list of Analytics Items defined within an Application Insights component.
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
  ##   scopePath: JString (required)
  ##            : Enum indicating if this item definition is owned by a specific user or is shared between all users with access to the Application Insights component.
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
  var valid_593838 = path.getOrDefault("scopePath")
  valid_593838 = validateParameter(valid_593838, JString, required = true,
                                 default = newJString("analyticsItems"))
  if valid_593838 != nil:
    section.add "scopePath", valid_593838
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   scope: JString
  ##        : Enum indicating if this item definition is owned by a specific user or is shared between all users with access to the Application Insights component.
  ##   type: JString
  ##       : Enum indicating the type of the Analytics item.
  ##   includeContent: JBool
  ##                 : Flag indicating whether or not to return the content of each applicable item. If false, only return the item information.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593839 = query.getOrDefault("api-version")
  valid_593839 = validateParameter(valid_593839, JString, required = true,
                                 default = nil)
  if valid_593839 != nil:
    section.add "api-version", valid_593839
  var valid_593840 = query.getOrDefault("scope")
  valid_593840 = validateParameter(valid_593840, JString, required = false,
                                 default = newJString("shared"))
  if valid_593840 != nil:
    section.add "scope", valid_593840
  var valid_593841 = query.getOrDefault("type")
  valid_593841 = validateParameter(valid_593841, JString, required = false,
                                 default = newJString("none"))
  if valid_593841 != nil:
    section.add "type", valid_593841
  var valid_593842 = query.getOrDefault("includeContent")
  valid_593842 = validateParameter(valid_593842, JBool, required = false, default = nil)
  if valid_593842 != nil:
    section.add "includeContent", valid_593842
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593865: Call_AnalyticsItemsList_593647; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of Analytics Items defined within an Application Insights component.
  ## 
  let valid = call_593865.validator(path, query, header, formData, body)
  let scheme = call_593865.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593865.url(scheme.get, call_593865.host, call_593865.base,
                         call_593865.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593865, url, valid)

proc call*(call_593936: Call_AnalyticsItemsList_593647; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; resourceName: string;
          scope: string = "shared"; `type`: string = "none";
          includeContent: bool = false; scopePath: string = "analyticsItems"): Recallable =
  ## analyticsItemsList
  ## Gets a list of Analytics Items defined within an Application Insights component.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   scope: string
  ##        : Enum indicating if this item definition is owned by a specific user or is shared between all users with access to the Application Insights component.
  ##   type: string
  ##       : Enum indicating the type of the Analytics item.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   includeContent: bool
  ##                 : Flag indicating whether or not to return the content of each applicable item. If false, only return the item information.
  ##   resourceName: string (required)
  ##               : The name of the Application Insights component resource.
  ##   scopePath: string (required)
  ##            : Enum indicating if this item definition is owned by a specific user or is shared between all users with access to the Application Insights component.
  var path_593937 = newJObject()
  var query_593939 = newJObject()
  add(path_593937, "resourceGroupName", newJString(resourceGroupName))
  add(query_593939, "api-version", newJString(apiVersion))
  add(query_593939, "scope", newJString(scope))
  add(query_593939, "type", newJString(`type`))
  add(path_593937, "subscriptionId", newJString(subscriptionId))
  add(query_593939, "includeContent", newJBool(includeContent))
  add(path_593937, "resourceName", newJString(resourceName))
  add(path_593937, "scopePath", newJString(scopePath))
  result = call_593936.call(path_593937, query_593939, nil, nil, nil)

var analyticsItemsList* = Call_AnalyticsItemsList_593647(
    name: "analyticsItemsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/microsoft.insights/components/{resourceName}/{scopePath}",
    validator: validate_AnalyticsItemsList_593648, base: "",
    url: url_AnalyticsItemsList_593649, schemes: {Scheme.Https})
type
  Call_AnalyticsItemsPut_593992 = ref object of OpenApiRestCall_593425
proc url_AnalyticsItemsPut_593994(protocol: Scheme; host: string; base: string;
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

proc validate_AnalyticsItemsPut_593993(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Adds or Updates a specific Analytics Item within an Application Insights component.
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
  ##   scopePath: JString (required)
  ##            : Enum indicating if this item definition is owned by a specific user or is shared between all users with access to the Application Insights component.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593995 = path.getOrDefault("resourceGroupName")
  valid_593995 = validateParameter(valid_593995, JString, required = true,
                                 default = nil)
  if valid_593995 != nil:
    section.add "resourceGroupName", valid_593995
  var valid_593996 = path.getOrDefault("subscriptionId")
  valid_593996 = validateParameter(valid_593996, JString, required = true,
                                 default = nil)
  if valid_593996 != nil:
    section.add "subscriptionId", valid_593996
  var valid_593997 = path.getOrDefault("resourceName")
  valid_593997 = validateParameter(valid_593997, JString, required = true,
                                 default = nil)
  if valid_593997 != nil:
    section.add "resourceName", valid_593997
  var valid_593998 = path.getOrDefault("scopePath")
  valid_593998 = validateParameter(valid_593998, JString, required = true,
                                 default = newJString("analyticsItems"))
  if valid_593998 != nil:
    section.add "scopePath", valid_593998
  result.add "path", section
  ## parameters in `query` object:
  ##   overrideItem: JBool
  ##               : Flag indicating whether or not to force save an item. This allows overriding an item if it already exists.
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  var valid_593999 = query.getOrDefault("overrideItem")
  valid_593999 = validateParameter(valid_593999, JBool, required = false, default = nil)
  if valid_593999 != nil:
    section.add "overrideItem", valid_593999
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594000 = query.getOrDefault("api-version")
  valid_594000 = validateParameter(valid_594000, JString, required = true,
                                 default = nil)
  if valid_594000 != nil:
    section.add "api-version", valid_594000
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

proc call*(call_594002: Call_AnalyticsItemsPut_593992; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds or Updates a specific Analytics Item within an Application Insights component.
  ## 
  let valid = call_594002.validator(path, query, header, formData, body)
  let scheme = call_594002.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594002.url(scheme.get, call_594002.host, call_594002.base,
                         call_594002.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594002, url, valid)

proc call*(call_594003: Call_AnalyticsItemsPut_593992; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; itemProperties: JsonNode;
          resourceName: string; overrideItem: bool = false;
          scopePath: string = "analyticsItems"): Recallable =
  ## analyticsItemsPut
  ## Adds or Updates a specific Analytics Item within an Application Insights component.
  ##   overrideItem: bool
  ##               : Flag indicating whether or not to force save an item. This allows overriding an item if it already exists.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   itemProperties: JObject (required)
  ##                 : Properties that need to be specified to create a new item and add it to an Application Insights component.
  ##   resourceName: string (required)
  ##               : The name of the Application Insights component resource.
  ##   scopePath: string (required)
  ##            : Enum indicating if this item definition is owned by a specific user or is shared between all users with access to the Application Insights component.
  var path_594004 = newJObject()
  var query_594005 = newJObject()
  var body_594006 = newJObject()
  add(query_594005, "overrideItem", newJBool(overrideItem))
  add(path_594004, "resourceGroupName", newJString(resourceGroupName))
  add(query_594005, "api-version", newJString(apiVersion))
  add(path_594004, "subscriptionId", newJString(subscriptionId))
  if itemProperties != nil:
    body_594006 = itemProperties
  add(path_594004, "resourceName", newJString(resourceName))
  add(path_594004, "scopePath", newJString(scopePath))
  result = call_594003.call(path_594004, query_594005, nil, nil, body_594006)

var analyticsItemsPut* = Call_AnalyticsItemsPut_593992(name: "analyticsItemsPut",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/microsoft.insights/components/{resourceName}/{scopePath}/item",
    validator: validate_AnalyticsItemsPut_593993, base: "",
    url: url_AnalyticsItemsPut_593994, schemes: {Scheme.Https})
type
  Call_AnalyticsItemsGet_593978 = ref object of OpenApiRestCall_593425
proc url_AnalyticsItemsGet_593980(protocol: Scheme; host: string; base: string;
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

proc validate_AnalyticsItemsGet_593979(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets a specific Analytics Items defined within an Application Insights component.
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
  ##   scopePath: JString (required)
  ##            : Enum indicating if this item definition is owned by a specific user or is shared between all users with access to the Application Insights component.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593981 = path.getOrDefault("resourceGroupName")
  valid_593981 = validateParameter(valid_593981, JString, required = true,
                                 default = nil)
  if valid_593981 != nil:
    section.add "resourceGroupName", valid_593981
  var valid_593982 = path.getOrDefault("subscriptionId")
  valid_593982 = validateParameter(valid_593982, JString, required = true,
                                 default = nil)
  if valid_593982 != nil:
    section.add "subscriptionId", valid_593982
  var valid_593983 = path.getOrDefault("resourceName")
  valid_593983 = validateParameter(valid_593983, JString, required = true,
                                 default = nil)
  if valid_593983 != nil:
    section.add "resourceName", valid_593983
  var valid_593984 = path.getOrDefault("scopePath")
  valid_593984 = validateParameter(valid_593984, JString, required = true,
                                 default = newJString("analyticsItems"))
  if valid_593984 != nil:
    section.add "scopePath", valid_593984
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   id: JString
  ##     : The Id of a specific item defined in the Application Insights component
  ##   name: JString
  ##       : The name of a specific item defined in the Application Insights component
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593985 = query.getOrDefault("api-version")
  valid_593985 = validateParameter(valid_593985, JString, required = true,
                                 default = nil)
  if valid_593985 != nil:
    section.add "api-version", valid_593985
  var valid_593986 = query.getOrDefault("id")
  valid_593986 = validateParameter(valid_593986, JString, required = false,
                                 default = nil)
  if valid_593986 != nil:
    section.add "id", valid_593986
  var valid_593987 = query.getOrDefault("name")
  valid_593987 = validateParameter(valid_593987, JString, required = false,
                                 default = nil)
  if valid_593987 != nil:
    section.add "name", valid_593987
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593988: Call_AnalyticsItemsGet_593978; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a specific Analytics Items defined within an Application Insights component.
  ## 
  let valid = call_593988.validator(path, query, header, formData, body)
  let scheme = call_593988.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593988.url(scheme.get, call_593988.host, call_593988.base,
                         call_593988.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593988, url, valid)

proc call*(call_593989: Call_AnalyticsItemsGet_593978; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; resourceName: string;
          id: string = ""; name: string = ""; scopePath: string = "analyticsItems"): Recallable =
  ## analyticsItemsGet
  ## Gets a specific Analytics Items defined within an Application Insights component.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   id: string
  ##     : The Id of a specific item defined in the Application Insights component
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: string (required)
  ##               : The name of the Application Insights component resource.
  ##   name: string
  ##       : The name of a specific item defined in the Application Insights component
  ##   scopePath: string (required)
  ##            : Enum indicating if this item definition is owned by a specific user or is shared between all users with access to the Application Insights component.
  var path_593990 = newJObject()
  var query_593991 = newJObject()
  add(path_593990, "resourceGroupName", newJString(resourceGroupName))
  add(query_593991, "api-version", newJString(apiVersion))
  add(query_593991, "id", newJString(id))
  add(path_593990, "subscriptionId", newJString(subscriptionId))
  add(path_593990, "resourceName", newJString(resourceName))
  add(query_593991, "name", newJString(name))
  add(path_593990, "scopePath", newJString(scopePath))
  result = call_593989.call(path_593990, query_593991, nil, nil, nil)

var analyticsItemsGet* = Call_AnalyticsItemsGet_593978(name: "analyticsItemsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/microsoft.insights/components/{resourceName}/{scopePath}/item",
    validator: validate_AnalyticsItemsGet_593979, base: "",
    url: url_AnalyticsItemsGet_593980, schemes: {Scheme.Https})
type
  Call_AnalyticsItemsDelete_594007 = ref object of OpenApiRestCall_593425
proc url_AnalyticsItemsDelete_594009(protocol: Scheme; host: string; base: string;
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

proc validate_AnalyticsItemsDelete_594008(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a specific Analytics Items defined within an Application Insights component.
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
  ##   scopePath: JString (required)
  ##            : Enum indicating if this item definition is owned by a specific user or is shared between all users with access to the Application Insights component.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594010 = path.getOrDefault("resourceGroupName")
  valid_594010 = validateParameter(valid_594010, JString, required = true,
                                 default = nil)
  if valid_594010 != nil:
    section.add "resourceGroupName", valid_594010
  var valid_594011 = path.getOrDefault("subscriptionId")
  valid_594011 = validateParameter(valid_594011, JString, required = true,
                                 default = nil)
  if valid_594011 != nil:
    section.add "subscriptionId", valid_594011
  var valid_594012 = path.getOrDefault("resourceName")
  valid_594012 = validateParameter(valid_594012, JString, required = true,
                                 default = nil)
  if valid_594012 != nil:
    section.add "resourceName", valid_594012
  var valid_594013 = path.getOrDefault("scopePath")
  valid_594013 = validateParameter(valid_594013, JString, required = true,
                                 default = newJString("analyticsItems"))
  if valid_594013 != nil:
    section.add "scopePath", valid_594013
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   id: JString
  ##     : The Id of a specific item defined in the Application Insights component
  ##   name: JString
  ##       : The name of a specific item defined in the Application Insights component
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594014 = query.getOrDefault("api-version")
  valid_594014 = validateParameter(valid_594014, JString, required = true,
                                 default = nil)
  if valid_594014 != nil:
    section.add "api-version", valid_594014
  var valid_594015 = query.getOrDefault("id")
  valid_594015 = validateParameter(valid_594015, JString, required = false,
                                 default = nil)
  if valid_594015 != nil:
    section.add "id", valid_594015
  var valid_594016 = query.getOrDefault("name")
  valid_594016 = validateParameter(valid_594016, JString, required = false,
                                 default = nil)
  if valid_594016 != nil:
    section.add "name", valid_594016
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594017: Call_AnalyticsItemsDelete_594007; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a specific Analytics Items defined within an Application Insights component.
  ## 
  let valid = call_594017.validator(path, query, header, formData, body)
  let scheme = call_594017.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594017.url(scheme.get, call_594017.host, call_594017.base,
                         call_594017.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594017, url, valid)

proc call*(call_594018: Call_AnalyticsItemsDelete_594007;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; id: string = ""; name: string = "";
          scopePath: string = "analyticsItems"): Recallable =
  ## analyticsItemsDelete
  ## Deletes a specific Analytics Items defined within an Application Insights component.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   id: string
  ##     : The Id of a specific item defined in the Application Insights component
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: string (required)
  ##               : The name of the Application Insights component resource.
  ##   name: string
  ##       : The name of a specific item defined in the Application Insights component
  ##   scopePath: string (required)
  ##            : Enum indicating if this item definition is owned by a specific user or is shared between all users with access to the Application Insights component.
  var path_594019 = newJObject()
  var query_594020 = newJObject()
  add(path_594019, "resourceGroupName", newJString(resourceGroupName))
  add(query_594020, "api-version", newJString(apiVersion))
  add(query_594020, "id", newJString(id))
  add(path_594019, "subscriptionId", newJString(subscriptionId))
  add(path_594019, "resourceName", newJString(resourceName))
  add(query_594020, "name", newJString(name))
  add(path_594019, "scopePath", newJString(scopePath))
  result = call_594018.call(path_594019, query_594020, nil, nil, nil)

var analyticsItemsDelete* = Call_AnalyticsItemsDelete_594007(
    name: "analyticsItemsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/microsoft.insights/components/{resourceName}/{scopePath}/item",
    validator: validate_AnalyticsItemsDelete_594008, base: "",
    url: url_AnalyticsItemsDelete_594009, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
