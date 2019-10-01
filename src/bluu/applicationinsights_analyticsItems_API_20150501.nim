
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

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
  macServiceName = "applicationinsights-analyticsItems_API"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AnalyticsItemsList_596680 = ref object of OpenApiRestCall_596458
proc url_AnalyticsItemsList_596682(protocol: Scheme; host: string; base: string;
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

proc validate_AnalyticsItemsList_596681(path: JsonNode; query: JsonNode;
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
  var valid_596871 = path.getOrDefault("scopePath")
  valid_596871 = validateParameter(valid_596871, JString, required = true,
                                 default = newJString("analyticsItems"))
  if valid_596871 != nil:
    section.add "scopePath", valid_596871
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
  var valid_596872 = query.getOrDefault("api-version")
  valid_596872 = validateParameter(valid_596872, JString, required = true,
                                 default = nil)
  if valid_596872 != nil:
    section.add "api-version", valid_596872
  var valid_596873 = query.getOrDefault("scope")
  valid_596873 = validateParameter(valid_596873, JString, required = false,
                                 default = newJString("shared"))
  if valid_596873 != nil:
    section.add "scope", valid_596873
  var valid_596874 = query.getOrDefault("type")
  valid_596874 = validateParameter(valid_596874, JString, required = false,
                                 default = newJString("none"))
  if valid_596874 != nil:
    section.add "type", valid_596874
  var valid_596875 = query.getOrDefault("includeContent")
  valid_596875 = validateParameter(valid_596875, JBool, required = false, default = nil)
  if valid_596875 != nil:
    section.add "includeContent", valid_596875
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_596898: Call_AnalyticsItemsList_596680; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of Analytics Items defined within an Application Insights component.
  ## 
  let valid = call_596898.validator(path, query, header, formData, body)
  let scheme = call_596898.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596898.url(scheme.get, call_596898.host, call_596898.base,
                         call_596898.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596898, url, valid)

proc call*(call_596969: Call_AnalyticsItemsList_596680; resourceGroupName: string;
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
  var path_596970 = newJObject()
  var query_596972 = newJObject()
  add(path_596970, "resourceGroupName", newJString(resourceGroupName))
  add(query_596972, "api-version", newJString(apiVersion))
  add(query_596972, "scope", newJString(scope))
  add(query_596972, "type", newJString(`type`))
  add(path_596970, "subscriptionId", newJString(subscriptionId))
  add(query_596972, "includeContent", newJBool(includeContent))
  add(path_596970, "resourceName", newJString(resourceName))
  add(path_596970, "scopePath", newJString(scopePath))
  result = call_596969.call(path_596970, query_596972, nil, nil, nil)

var analyticsItemsList* = Call_AnalyticsItemsList_596680(
    name: "analyticsItemsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/microsoft.insights/components/{resourceName}/{scopePath}",
    validator: validate_AnalyticsItemsList_596681, base: "",
    url: url_AnalyticsItemsList_596682, schemes: {Scheme.Https})
type
  Call_AnalyticsItemsPut_597025 = ref object of OpenApiRestCall_596458
proc url_AnalyticsItemsPut_597027(protocol: Scheme; host: string; base: string;
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

proc validate_AnalyticsItemsPut_597026(path: JsonNode; query: JsonNode;
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
  var valid_597028 = path.getOrDefault("resourceGroupName")
  valid_597028 = validateParameter(valid_597028, JString, required = true,
                                 default = nil)
  if valid_597028 != nil:
    section.add "resourceGroupName", valid_597028
  var valid_597029 = path.getOrDefault("subscriptionId")
  valid_597029 = validateParameter(valid_597029, JString, required = true,
                                 default = nil)
  if valid_597029 != nil:
    section.add "subscriptionId", valid_597029
  var valid_597030 = path.getOrDefault("resourceName")
  valid_597030 = validateParameter(valid_597030, JString, required = true,
                                 default = nil)
  if valid_597030 != nil:
    section.add "resourceName", valid_597030
  var valid_597031 = path.getOrDefault("scopePath")
  valid_597031 = validateParameter(valid_597031, JString, required = true,
                                 default = newJString("analyticsItems"))
  if valid_597031 != nil:
    section.add "scopePath", valid_597031
  result.add "path", section
  ## parameters in `query` object:
  ##   overrideItem: JBool
  ##               : Flag indicating whether or not to force save an item. This allows overriding an item if it already exists.
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  var valid_597032 = query.getOrDefault("overrideItem")
  valid_597032 = validateParameter(valid_597032, JBool, required = false, default = nil)
  if valid_597032 != nil:
    section.add "overrideItem", valid_597032
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597033 = query.getOrDefault("api-version")
  valid_597033 = validateParameter(valid_597033, JString, required = true,
                                 default = nil)
  if valid_597033 != nil:
    section.add "api-version", valid_597033
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

proc call*(call_597035: Call_AnalyticsItemsPut_597025; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds or Updates a specific Analytics Item within an Application Insights component.
  ## 
  let valid = call_597035.validator(path, query, header, formData, body)
  let scheme = call_597035.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597035.url(scheme.get, call_597035.host, call_597035.base,
                         call_597035.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597035, url, valid)

proc call*(call_597036: Call_AnalyticsItemsPut_597025; resourceGroupName: string;
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
  var path_597037 = newJObject()
  var query_597038 = newJObject()
  var body_597039 = newJObject()
  add(query_597038, "overrideItem", newJBool(overrideItem))
  add(path_597037, "resourceGroupName", newJString(resourceGroupName))
  add(query_597038, "api-version", newJString(apiVersion))
  add(path_597037, "subscriptionId", newJString(subscriptionId))
  if itemProperties != nil:
    body_597039 = itemProperties
  add(path_597037, "resourceName", newJString(resourceName))
  add(path_597037, "scopePath", newJString(scopePath))
  result = call_597036.call(path_597037, query_597038, nil, nil, body_597039)

var analyticsItemsPut* = Call_AnalyticsItemsPut_597025(name: "analyticsItemsPut",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/microsoft.insights/components/{resourceName}/{scopePath}/item",
    validator: validate_AnalyticsItemsPut_597026, base: "",
    url: url_AnalyticsItemsPut_597027, schemes: {Scheme.Https})
type
  Call_AnalyticsItemsGet_597011 = ref object of OpenApiRestCall_596458
proc url_AnalyticsItemsGet_597013(protocol: Scheme; host: string; base: string;
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

proc validate_AnalyticsItemsGet_597012(path: JsonNode; query: JsonNode;
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
  var valid_597014 = path.getOrDefault("resourceGroupName")
  valid_597014 = validateParameter(valid_597014, JString, required = true,
                                 default = nil)
  if valid_597014 != nil:
    section.add "resourceGroupName", valid_597014
  var valid_597015 = path.getOrDefault("subscriptionId")
  valid_597015 = validateParameter(valid_597015, JString, required = true,
                                 default = nil)
  if valid_597015 != nil:
    section.add "subscriptionId", valid_597015
  var valid_597016 = path.getOrDefault("resourceName")
  valid_597016 = validateParameter(valid_597016, JString, required = true,
                                 default = nil)
  if valid_597016 != nil:
    section.add "resourceName", valid_597016
  var valid_597017 = path.getOrDefault("scopePath")
  valid_597017 = validateParameter(valid_597017, JString, required = true,
                                 default = newJString("analyticsItems"))
  if valid_597017 != nil:
    section.add "scopePath", valid_597017
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
  var valid_597018 = query.getOrDefault("api-version")
  valid_597018 = validateParameter(valid_597018, JString, required = true,
                                 default = nil)
  if valid_597018 != nil:
    section.add "api-version", valid_597018
  var valid_597019 = query.getOrDefault("id")
  valid_597019 = validateParameter(valid_597019, JString, required = false,
                                 default = nil)
  if valid_597019 != nil:
    section.add "id", valid_597019
  var valid_597020 = query.getOrDefault("name")
  valid_597020 = validateParameter(valid_597020, JString, required = false,
                                 default = nil)
  if valid_597020 != nil:
    section.add "name", valid_597020
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597021: Call_AnalyticsItemsGet_597011; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a specific Analytics Items defined within an Application Insights component.
  ## 
  let valid = call_597021.validator(path, query, header, formData, body)
  let scheme = call_597021.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597021.url(scheme.get, call_597021.host, call_597021.base,
                         call_597021.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597021, url, valid)

proc call*(call_597022: Call_AnalyticsItemsGet_597011; resourceGroupName: string;
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
  var path_597023 = newJObject()
  var query_597024 = newJObject()
  add(path_597023, "resourceGroupName", newJString(resourceGroupName))
  add(query_597024, "api-version", newJString(apiVersion))
  add(query_597024, "id", newJString(id))
  add(path_597023, "subscriptionId", newJString(subscriptionId))
  add(path_597023, "resourceName", newJString(resourceName))
  add(query_597024, "name", newJString(name))
  add(path_597023, "scopePath", newJString(scopePath))
  result = call_597022.call(path_597023, query_597024, nil, nil, nil)

var analyticsItemsGet* = Call_AnalyticsItemsGet_597011(name: "analyticsItemsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/microsoft.insights/components/{resourceName}/{scopePath}/item",
    validator: validate_AnalyticsItemsGet_597012, base: "",
    url: url_AnalyticsItemsGet_597013, schemes: {Scheme.Https})
type
  Call_AnalyticsItemsDelete_597040 = ref object of OpenApiRestCall_596458
proc url_AnalyticsItemsDelete_597042(protocol: Scheme; host: string; base: string;
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

proc validate_AnalyticsItemsDelete_597041(path: JsonNode; query: JsonNode;
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
  var valid_597043 = path.getOrDefault("resourceGroupName")
  valid_597043 = validateParameter(valid_597043, JString, required = true,
                                 default = nil)
  if valid_597043 != nil:
    section.add "resourceGroupName", valid_597043
  var valid_597044 = path.getOrDefault("subscriptionId")
  valid_597044 = validateParameter(valid_597044, JString, required = true,
                                 default = nil)
  if valid_597044 != nil:
    section.add "subscriptionId", valid_597044
  var valid_597045 = path.getOrDefault("resourceName")
  valid_597045 = validateParameter(valid_597045, JString, required = true,
                                 default = nil)
  if valid_597045 != nil:
    section.add "resourceName", valid_597045
  var valid_597046 = path.getOrDefault("scopePath")
  valid_597046 = validateParameter(valid_597046, JString, required = true,
                                 default = newJString("analyticsItems"))
  if valid_597046 != nil:
    section.add "scopePath", valid_597046
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
  var valid_597047 = query.getOrDefault("api-version")
  valid_597047 = validateParameter(valid_597047, JString, required = true,
                                 default = nil)
  if valid_597047 != nil:
    section.add "api-version", valid_597047
  var valid_597048 = query.getOrDefault("id")
  valid_597048 = validateParameter(valid_597048, JString, required = false,
                                 default = nil)
  if valid_597048 != nil:
    section.add "id", valid_597048
  var valid_597049 = query.getOrDefault("name")
  valid_597049 = validateParameter(valid_597049, JString, required = false,
                                 default = nil)
  if valid_597049 != nil:
    section.add "name", valid_597049
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597050: Call_AnalyticsItemsDelete_597040; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a specific Analytics Items defined within an Application Insights component.
  ## 
  let valid = call_597050.validator(path, query, header, formData, body)
  let scheme = call_597050.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597050.url(scheme.get, call_597050.host, call_597050.base,
                         call_597050.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597050, url, valid)

proc call*(call_597051: Call_AnalyticsItemsDelete_597040;
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
  var path_597052 = newJObject()
  var query_597053 = newJObject()
  add(path_597052, "resourceGroupName", newJString(resourceGroupName))
  add(query_597053, "api-version", newJString(apiVersion))
  add(query_597053, "id", newJString(id))
  add(path_597052, "subscriptionId", newJString(subscriptionId))
  add(path_597052, "resourceName", newJString(resourceName))
  add(query_597053, "name", newJString(name))
  add(path_597052, "scopePath", newJString(scopePath))
  result = call_597051.call(path_597052, query_597053, nil, nil, nil)

var analyticsItemsDelete* = Call_AnalyticsItemsDelete_597040(
    name: "analyticsItemsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/microsoft.insights/components/{resourceName}/{scopePath}/item",
    validator: validate_AnalyticsItemsDelete_597041, base: "",
    url: url_AnalyticsItemsDelete_597042, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
