
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: SearchManagementClient
## version: 2015-08-19
## termsOfService: (not provided)
## license: (not provided)
## 
## Client that can be used to manage Azure Search services and API keys.
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
  macServiceName = "search"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_563778 = ref object of OpenApiRestCall_563556
proc url_OperationsList_563780(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_563779(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists all of the available REST API operations of the Microsoft.Search provider.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for each request. The current version is 2015-08-19.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563941 = query.getOrDefault("api-version")
  valid_563941 = validateParameter(valid_563941, JString, required = true,
                                 default = nil)
  if valid_563941 != nil:
    section.add "api-version", valid_563941
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563964: Call_OperationsList_563778; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available REST API operations of the Microsoft.Search provider.
  ## 
  let valid = call_563964.validator(path, query, header, formData, body)
  let scheme = call_563964.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563964.url(scheme.get, call_563964.host, call_563964.base,
                         call_563964.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563964, url, valid)

proc call*(call_564035: Call_OperationsList_563778; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available REST API operations of the Microsoft.Search provider.
  ##   apiVersion: string (required)
  ##             : The API version to use for each request. The current version is 2015-08-19.
  var query_564036 = newJObject()
  add(query_564036, "api-version", newJString(apiVersion))
  result = call_564035.call(nil, query_564036, nil, nil, nil)

var operationsList* = Call_OperationsList_563778(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Search/operations",
    validator: validate_OperationsList_563779, base: "", url: url_OperationsList_563780,
    schemes: {Scheme.Https})
type
  Call_ServicesCheckNameAvailability_564076 = ref object of OpenApiRestCall_563556
proc url_ServicesCheckNameAvailability_564078(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Search/checkNameAvailability")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesCheckNameAvailability_564077(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks whether or not the given Search service name is available for use. Search service names must be globally unique since they are part of the service URI (https://<name>.search.windows.net).
  ## 
  ## https://aka.ms/search-manage
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The unique identifier for a Microsoft Azure subscription. You can obtain this value from the Azure Resource Manager API or the portal.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564093 = path.getOrDefault("subscriptionId")
  valid_564093 = validateParameter(valid_564093, JString, required = true,
                                 default = nil)
  if valid_564093 != nil:
    section.add "subscriptionId", valid_564093
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for each request. The current version is 2015-08-19.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564094 = query.getOrDefault("api-version")
  valid_564094 = validateParameter(valid_564094, JString, required = true,
                                 default = nil)
  if valid_564094 != nil:
    section.add "api-version", valid_564094
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-client-request-id: JString
  ##                         : A client-generated GUID value that identifies this request. If specified, this will be included in response information as a way to track the request.
  section = newJObject()
  var valid_564095 = header.getOrDefault("x-ms-client-request-id")
  valid_564095 = validateParameter(valid_564095, JString, required = false,
                                 default = nil)
  if valid_564095 != nil:
    section.add "x-ms-client-request-id", valid_564095
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   checkNameAvailabilityInput: JObject (required)
  ##                             : The resource name and type to check.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564097: Call_ServicesCheckNameAvailability_564076; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks whether or not the given Search service name is available for use. Search service names must be globally unique since they are part of the service URI (https://<name>.search.windows.net).
  ## 
  ## https://aka.ms/search-manage
  let valid = call_564097.validator(path, query, header, formData, body)
  let scheme = call_564097.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564097.url(scheme.get, call_564097.host, call_564097.base,
                         call_564097.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564097, url, valid)

proc call*(call_564098: Call_ServicesCheckNameAvailability_564076;
          apiVersion: string; subscriptionId: string;
          checkNameAvailabilityInput: JsonNode): Recallable =
  ## servicesCheckNameAvailability
  ## Checks whether or not the given Search service name is available for use. Search service names must be globally unique since they are part of the service URI (https://<name>.search.windows.net).
  ## https://aka.ms/search-manage
  ##   apiVersion: string (required)
  ##             : The API version to use for each request. The current version is 2015-08-19.
  ##   subscriptionId: string (required)
  ##                 : The unique identifier for a Microsoft Azure subscription. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   checkNameAvailabilityInput: JObject (required)
  ##                             : The resource name and type to check.
  var path_564099 = newJObject()
  var query_564100 = newJObject()
  var body_564101 = newJObject()
  add(query_564100, "api-version", newJString(apiVersion))
  add(path_564099, "subscriptionId", newJString(subscriptionId))
  if checkNameAvailabilityInput != nil:
    body_564101 = checkNameAvailabilityInput
  result = call_564098.call(path_564099, query_564100, nil, nil, body_564101)

var servicesCheckNameAvailability* = Call_ServicesCheckNameAvailability_564076(
    name: "servicesCheckNameAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Search/checkNameAvailability",
    validator: validate_ServicesCheckNameAvailability_564077, base: "",
    url: url_ServicesCheckNameAvailability_564078, schemes: {Scheme.Https})
type
  Call_ServicesListBySubscription_564102 = ref object of OpenApiRestCall_563556
proc url_ServicesListBySubscription_564104(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Search/searchServices")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesListBySubscription_564103(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of all Search services in the given subscription.
  ## 
  ## https://aka.ms/search-manage
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The unique identifier for a Microsoft Azure subscription. You can obtain this value from the Azure Resource Manager API or the portal.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564105 = path.getOrDefault("subscriptionId")
  valid_564105 = validateParameter(valid_564105, JString, required = true,
                                 default = nil)
  if valid_564105 != nil:
    section.add "subscriptionId", valid_564105
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for each request. The current version is 2015-08-19.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564106 = query.getOrDefault("api-version")
  valid_564106 = validateParameter(valid_564106, JString, required = true,
                                 default = nil)
  if valid_564106 != nil:
    section.add "api-version", valid_564106
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-client-request-id: JString
  ##                         : A client-generated GUID value that identifies this request. If specified, this will be included in response information as a way to track the request.
  section = newJObject()
  var valid_564107 = header.getOrDefault("x-ms-client-request-id")
  valid_564107 = validateParameter(valid_564107, JString, required = false,
                                 default = nil)
  if valid_564107 != nil:
    section.add "x-ms-client-request-id", valid_564107
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564108: Call_ServicesListBySubscription_564102; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of all Search services in the given subscription.
  ## 
  ## https://aka.ms/search-manage
  let valid = call_564108.validator(path, query, header, formData, body)
  let scheme = call_564108.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564108.url(scheme.get, call_564108.host, call_564108.base,
                         call_564108.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564108, url, valid)

proc call*(call_564109: Call_ServicesListBySubscription_564102; apiVersion: string;
          subscriptionId: string): Recallable =
  ## servicesListBySubscription
  ## Gets a list of all Search services in the given subscription.
  ## https://aka.ms/search-manage
  ##   apiVersion: string (required)
  ##             : The API version to use for each request. The current version is 2015-08-19.
  ##   subscriptionId: string (required)
  ##                 : The unique identifier for a Microsoft Azure subscription. You can obtain this value from the Azure Resource Manager API or the portal.
  var path_564110 = newJObject()
  var query_564111 = newJObject()
  add(query_564111, "api-version", newJString(apiVersion))
  add(path_564110, "subscriptionId", newJString(subscriptionId))
  result = call_564109.call(path_564110, query_564111, nil, nil, nil)

var servicesListBySubscription* = Call_ServicesListBySubscription_564102(
    name: "servicesListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Search/searchServices",
    validator: validate_ServicesListBySubscription_564103, base: "",
    url: url_ServicesListBySubscription_564104, schemes: {Scheme.Https})
type
  Call_ServicesListByResourceGroup_564112 = ref object of OpenApiRestCall_563556
proc url_ServicesListByResourceGroup_564114(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Search/searchServices")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesListByResourceGroup_564113(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of all Search services in the given resource group.
  ## 
  ## https://aka.ms/search-manage
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The unique identifier for a Microsoft Azure subscription. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the current subscription. You can obtain this value from the Azure Resource Manager API or the portal.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
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
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for each request. The current version is 2015-08-19.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564117 = query.getOrDefault("api-version")
  valid_564117 = validateParameter(valid_564117, JString, required = true,
                                 default = nil)
  if valid_564117 != nil:
    section.add "api-version", valid_564117
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-client-request-id: JString
  ##                         : A client-generated GUID value that identifies this request. If specified, this will be included in response information as a way to track the request.
  section = newJObject()
  var valid_564118 = header.getOrDefault("x-ms-client-request-id")
  valid_564118 = validateParameter(valid_564118, JString, required = false,
                                 default = nil)
  if valid_564118 != nil:
    section.add "x-ms-client-request-id", valid_564118
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564119: Call_ServicesListByResourceGroup_564112; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of all Search services in the given resource group.
  ## 
  ## https://aka.ms/search-manage
  let valid = call_564119.validator(path, query, header, formData, body)
  let scheme = call_564119.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564119.url(scheme.get, call_564119.host, call_564119.base,
                         call_564119.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564119, url, valid)

proc call*(call_564120: Call_ServicesListByResourceGroup_564112;
          apiVersion: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## servicesListByResourceGroup
  ## Gets a list of all Search services in the given resource group.
  ## https://aka.ms/search-manage
  ##   apiVersion: string (required)
  ##             : The API version to use for each request. The current version is 2015-08-19.
  ##   subscriptionId: string (required)
  ##                 : The unique identifier for a Microsoft Azure subscription. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the current subscription. You can obtain this value from the Azure Resource Manager API or the portal.
  var path_564121 = newJObject()
  var query_564122 = newJObject()
  add(query_564122, "api-version", newJString(apiVersion))
  add(path_564121, "subscriptionId", newJString(subscriptionId))
  add(path_564121, "resourceGroupName", newJString(resourceGroupName))
  result = call_564120.call(path_564121, query_564122, nil, nil, nil)

var servicesListByResourceGroup* = Call_ServicesListByResourceGroup_564112(
    name: "servicesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Search/searchServices",
    validator: validate_ServicesListByResourceGroup_564113, base: "",
    url: url_ServicesListByResourceGroup_564114, schemes: {Scheme.Https})
type
  Call_ServicesCreateOrUpdate_564135 = ref object of OpenApiRestCall_563556
proc url_ServicesCreateOrUpdate_564137(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "searchServiceName" in path,
        "`searchServiceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Search/searchServices/"),
               (kind: VariableSegment, value: "searchServiceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesCreateOrUpdate_564136(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a Search service in the given resource group. If the Search service already exists, all properties will be updated with the given values.
  ## 
  ## https://aka.ms/search-manage
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The unique identifier for a Microsoft Azure subscription. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   searchServiceName: JString (required)
  ##                    : The name of the Azure Search service to create or update. Search service names must only contain lowercase letters, digits or dashes, cannot use dash as the first two or last one characters, cannot contain consecutive dashes, and must be between 2 and 60 characters in length. Search service names must be globally unique since they are part of the service URI (https://<name>.search.windows.net). You cannot change the service name after the service is created.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the current subscription. You can obtain this value from the Azure Resource Manager API or the portal.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564155 = path.getOrDefault("subscriptionId")
  valid_564155 = validateParameter(valid_564155, JString, required = true,
                                 default = nil)
  if valid_564155 != nil:
    section.add "subscriptionId", valid_564155
  var valid_564156 = path.getOrDefault("searchServiceName")
  valid_564156 = validateParameter(valid_564156, JString, required = true,
                                 default = nil)
  if valid_564156 != nil:
    section.add "searchServiceName", valid_564156
  var valid_564157 = path.getOrDefault("resourceGroupName")
  valid_564157 = validateParameter(valid_564157, JString, required = true,
                                 default = nil)
  if valid_564157 != nil:
    section.add "resourceGroupName", valid_564157
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for each request. The current version is 2015-08-19.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564158 = query.getOrDefault("api-version")
  valid_564158 = validateParameter(valid_564158, JString, required = true,
                                 default = nil)
  if valid_564158 != nil:
    section.add "api-version", valid_564158
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-client-request-id: JString
  ##                         : A client-generated GUID value that identifies this request. If specified, this will be included in response information as a way to track the request.
  section = newJObject()
  var valid_564159 = header.getOrDefault("x-ms-client-request-id")
  valid_564159 = validateParameter(valid_564159, JString, required = false,
                                 default = nil)
  if valid_564159 != nil:
    section.add "x-ms-client-request-id", valid_564159
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   service: JObject (required)
  ##          : The definition of the Search service to create or update.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564161: Call_ServicesCreateOrUpdate_564135; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a Search service in the given resource group. If the Search service already exists, all properties will be updated with the given values.
  ## 
  ## https://aka.ms/search-manage
  let valid = call_564161.validator(path, query, header, formData, body)
  let scheme = call_564161.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564161.url(scheme.get, call_564161.host, call_564161.base,
                         call_564161.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564161, url, valid)

proc call*(call_564162: Call_ServicesCreateOrUpdate_564135; apiVersion: string;
          service: JsonNode; subscriptionId: string; searchServiceName: string;
          resourceGroupName: string): Recallable =
  ## servicesCreateOrUpdate
  ## Creates or updates a Search service in the given resource group. If the Search service already exists, all properties will be updated with the given values.
  ## https://aka.ms/search-manage
  ##   apiVersion: string (required)
  ##             : The API version to use for each request. The current version is 2015-08-19.
  ##   service: JObject (required)
  ##          : The definition of the Search service to create or update.
  ##   subscriptionId: string (required)
  ##                 : The unique identifier for a Microsoft Azure subscription. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   searchServiceName: string (required)
  ##                    : The name of the Azure Search service to create or update. Search service names must only contain lowercase letters, digits or dashes, cannot use dash as the first two or last one characters, cannot contain consecutive dashes, and must be between 2 and 60 characters in length. Search service names must be globally unique since they are part of the service URI (https://<name>.search.windows.net). You cannot change the service name after the service is created.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the current subscription. You can obtain this value from the Azure Resource Manager API or the portal.
  var path_564163 = newJObject()
  var query_564164 = newJObject()
  var body_564165 = newJObject()
  add(query_564164, "api-version", newJString(apiVersion))
  if service != nil:
    body_564165 = service
  add(path_564163, "subscriptionId", newJString(subscriptionId))
  add(path_564163, "searchServiceName", newJString(searchServiceName))
  add(path_564163, "resourceGroupName", newJString(resourceGroupName))
  result = call_564162.call(path_564163, query_564164, nil, nil, body_564165)

var servicesCreateOrUpdate* = Call_ServicesCreateOrUpdate_564135(
    name: "servicesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Search/searchServices/{searchServiceName}",
    validator: validate_ServicesCreateOrUpdate_564136, base: "",
    url: url_ServicesCreateOrUpdate_564137, schemes: {Scheme.Https})
type
  Call_ServicesGet_564123 = ref object of OpenApiRestCall_563556
proc url_ServicesGet_564125(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "searchServiceName" in path,
        "`searchServiceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Search/searchServices/"),
               (kind: VariableSegment, value: "searchServiceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesGet_564124(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the Search service with the given name in the given resource group.
  ## 
  ## https://aka.ms/search-manage
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The unique identifier for a Microsoft Azure subscription. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   searchServiceName: JString (required)
  ##                    : The name of the Azure Search service associated with the specified resource group.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the current subscription. You can obtain this value from the Azure Resource Manager API or the portal.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564126 = path.getOrDefault("subscriptionId")
  valid_564126 = validateParameter(valid_564126, JString, required = true,
                                 default = nil)
  if valid_564126 != nil:
    section.add "subscriptionId", valid_564126
  var valid_564127 = path.getOrDefault("searchServiceName")
  valid_564127 = validateParameter(valid_564127, JString, required = true,
                                 default = nil)
  if valid_564127 != nil:
    section.add "searchServiceName", valid_564127
  var valid_564128 = path.getOrDefault("resourceGroupName")
  valid_564128 = validateParameter(valid_564128, JString, required = true,
                                 default = nil)
  if valid_564128 != nil:
    section.add "resourceGroupName", valid_564128
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for each request. The current version is 2015-08-19.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564129 = query.getOrDefault("api-version")
  valid_564129 = validateParameter(valid_564129, JString, required = true,
                                 default = nil)
  if valid_564129 != nil:
    section.add "api-version", valid_564129
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-client-request-id: JString
  ##                         : A client-generated GUID value that identifies this request. If specified, this will be included in response information as a way to track the request.
  section = newJObject()
  var valid_564130 = header.getOrDefault("x-ms-client-request-id")
  valid_564130 = validateParameter(valid_564130, JString, required = false,
                                 default = nil)
  if valid_564130 != nil:
    section.add "x-ms-client-request-id", valid_564130
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564131: Call_ServicesGet_564123; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the Search service with the given name in the given resource group.
  ## 
  ## https://aka.ms/search-manage
  let valid = call_564131.validator(path, query, header, formData, body)
  let scheme = call_564131.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564131.url(scheme.get, call_564131.host, call_564131.base,
                         call_564131.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564131, url, valid)

proc call*(call_564132: Call_ServicesGet_564123; apiVersion: string;
          subscriptionId: string; searchServiceName: string;
          resourceGroupName: string): Recallable =
  ## servicesGet
  ## Gets the Search service with the given name in the given resource group.
  ## https://aka.ms/search-manage
  ##   apiVersion: string (required)
  ##             : The API version to use for each request. The current version is 2015-08-19.
  ##   subscriptionId: string (required)
  ##                 : The unique identifier for a Microsoft Azure subscription. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   searchServiceName: string (required)
  ##                    : The name of the Azure Search service associated with the specified resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the current subscription. You can obtain this value from the Azure Resource Manager API or the portal.
  var path_564133 = newJObject()
  var query_564134 = newJObject()
  add(query_564134, "api-version", newJString(apiVersion))
  add(path_564133, "subscriptionId", newJString(subscriptionId))
  add(path_564133, "searchServiceName", newJString(searchServiceName))
  add(path_564133, "resourceGroupName", newJString(resourceGroupName))
  result = call_564132.call(path_564133, query_564134, nil, nil, nil)

var servicesGet* = Call_ServicesGet_564123(name: "servicesGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Search/searchServices/{searchServiceName}",
                                        validator: validate_ServicesGet_564124,
                                        base: "", url: url_ServicesGet_564125,
                                        schemes: {Scheme.Https})
type
  Call_ServicesUpdate_564178 = ref object of OpenApiRestCall_563556
proc url_ServicesUpdate_564180(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "searchServiceName" in path,
        "`searchServiceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Search/searchServices/"),
               (kind: VariableSegment, value: "searchServiceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesUpdate_564179(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Updates an existing Search service in the given resource group.
  ## 
  ## https://aka.ms/search-manage
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The unique identifier for a Microsoft Azure subscription. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   searchServiceName: JString (required)
  ##                    : The name of the Azure Search service to update.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the current subscription. You can obtain this value from the Azure Resource Manager API or the portal.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564181 = path.getOrDefault("subscriptionId")
  valid_564181 = validateParameter(valid_564181, JString, required = true,
                                 default = nil)
  if valid_564181 != nil:
    section.add "subscriptionId", valid_564181
  var valid_564182 = path.getOrDefault("searchServiceName")
  valid_564182 = validateParameter(valid_564182, JString, required = true,
                                 default = nil)
  if valid_564182 != nil:
    section.add "searchServiceName", valid_564182
  var valid_564183 = path.getOrDefault("resourceGroupName")
  valid_564183 = validateParameter(valid_564183, JString, required = true,
                                 default = nil)
  if valid_564183 != nil:
    section.add "resourceGroupName", valid_564183
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for each request. The current version is 2015-08-19.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564184 = query.getOrDefault("api-version")
  valid_564184 = validateParameter(valid_564184, JString, required = true,
                                 default = nil)
  if valid_564184 != nil:
    section.add "api-version", valid_564184
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-client-request-id: JString
  ##                         : A client-generated GUID value that identifies this request. If specified, this will be included in response information as a way to track the request.
  section = newJObject()
  var valid_564185 = header.getOrDefault("x-ms-client-request-id")
  valid_564185 = validateParameter(valid_564185, JString, required = false,
                                 default = nil)
  if valid_564185 != nil:
    section.add "x-ms-client-request-id", valid_564185
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   service: JObject (required)
  ##          : The definition of the Search service to update.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564187: Call_ServicesUpdate_564178; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing Search service in the given resource group.
  ## 
  ## https://aka.ms/search-manage
  let valid = call_564187.validator(path, query, header, formData, body)
  let scheme = call_564187.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564187.url(scheme.get, call_564187.host, call_564187.base,
                         call_564187.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564187, url, valid)

proc call*(call_564188: Call_ServicesUpdate_564178; apiVersion: string;
          service: JsonNode; subscriptionId: string; searchServiceName: string;
          resourceGroupName: string): Recallable =
  ## servicesUpdate
  ## Updates an existing Search service in the given resource group.
  ## https://aka.ms/search-manage
  ##   apiVersion: string (required)
  ##             : The API version to use for each request. The current version is 2015-08-19.
  ##   service: JObject (required)
  ##          : The definition of the Search service to update.
  ##   subscriptionId: string (required)
  ##                 : The unique identifier for a Microsoft Azure subscription. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   searchServiceName: string (required)
  ##                    : The name of the Azure Search service to update.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the current subscription. You can obtain this value from the Azure Resource Manager API or the portal.
  var path_564189 = newJObject()
  var query_564190 = newJObject()
  var body_564191 = newJObject()
  add(query_564190, "api-version", newJString(apiVersion))
  if service != nil:
    body_564191 = service
  add(path_564189, "subscriptionId", newJString(subscriptionId))
  add(path_564189, "searchServiceName", newJString(searchServiceName))
  add(path_564189, "resourceGroupName", newJString(resourceGroupName))
  result = call_564188.call(path_564189, query_564190, nil, nil, body_564191)

var servicesUpdate* = Call_ServicesUpdate_564178(name: "servicesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Search/searchServices/{searchServiceName}",
    validator: validate_ServicesUpdate_564179, base: "", url: url_ServicesUpdate_564180,
    schemes: {Scheme.Https})
type
  Call_ServicesDelete_564166 = ref object of OpenApiRestCall_563556
proc url_ServicesDelete_564168(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "searchServiceName" in path,
        "`searchServiceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Search/searchServices/"),
               (kind: VariableSegment, value: "searchServiceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesDelete_564167(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Deletes a Search service in the given resource group, along with its associated resources.
  ## 
  ## https://aka.ms/search-manage
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The unique identifier for a Microsoft Azure subscription. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   searchServiceName: JString (required)
  ##                    : The name of the Azure Search service associated with the specified resource group.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the current subscription. You can obtain this value from the Azure Resource Manager API or the portal.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564169 = path.getOrDefault("subscriptionId")
  valid_564169 = validateParameter(valid_564169, JString, required = true,
                                 default = nil)
  if valid_564169 != nil:
    section.add "subscriptionId", valid_564169
  var valid_564170 = path.getOrDefault("searchServiceName")
  valid_564170 = validateParameter(valid_564170, JString, required = true,
                                 default = nil)
  if valid_564170 != nil:
    section.add "searchServiceName", valid_564170
  var valid_564171 = path.getOrDefault("resourceGroupName")
  valid_564171 = validateParameter(valid_564171, JString, required = true,
                                 default = nil)
  if valid_564171 != nil:
    section.add "resourceGroupName", valid_564171
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for each request. The current version is 2015-08-19.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564172 = query.getOrDefault("api-version")
  valid_564172 = validateParameter(valid_564172, JString, required = true,
                                 default = nil)
  if valid_564172 != nil:
    section.add "api-version", valid_564172
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-client-request-id: JString
  ##                         : A client-generated GUID value that identifies this request. If specified, this will be included in response information as a way to track the request.
  section = newJObject()
  var valid_564173 = header.getOrDefault("x-ms-client-request-id")
  valid_564173 = validateParameter(valid_564173, JString, required = false,
                                 default = nil)
  if valid_564173 != nil:
    section.add "x-ms-client-request-id", valid_564173
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564174: Call_ServicesDelete_564166; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a Search service in the given resource group, along with its associated resources.
  ## 
  ## https://aka.ms/search-manage
  let valid = call_564174.validator(path, query, header, formData, body)
  let scheme = call_564174.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564174.url(scheme.get, call_564174.host, call_564174.base,
                         call_564174.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564174, url, valid)

proc call*(call_564175: Call_ServicesDelete_564166; apiVersion: string;
          subscriptionId: string; searchServiceName: string;
          resourceGroupName: string): Recallable =
  ## servicesDelete
  ## Deletes a Search service in the given resource group, along with its associated resources.
  ## https://aka.ms/search-manage
  ##   apiVersion: string (required)
  ##             : The API version to use for each request. The current version is 2015-08-19.
  ##   subscriptionId: string (required)
  ##                 : The unique identifier for a Microsoft Azure subscription. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   searchServiceName: string (required)
  ##                    : The name of the Azure Search service associated with the specified resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the current subscription. You can obtain this value from the Azure Resource Manager API or the portal.
  var path_564176 = newJObject()
  var query_564177 = newJObject()
  add(query_564177, "api-version", newJString(apiVersion))
  add(path_564176, "subscriptionId", newJString(subscriptionId))
  add(path_564176, "searchServiceName", newJString(searchServiceName))
  add(path_564176, "resourceGroupName", newJString(resourceGroupName))
  result = call_564175.call(path_564176, query_564177, nil, nil, nil)

var servicesDelete* = Call_ServicesDelete_564166(name: "servicesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Search/searchServices/{searchServiceName}",
    validator: validate_ServicesDelete_564167, base: "", url: url_ServicesDelete_564168,
    schemes: {Scheme.Https})
type
  Call_QueryKeysCreate_564192 = ref object of OpenApiRestCall_563556
proc url_QueryKeysCreate_564194(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "searchServiceName" in path,
        "`searchServiceName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Search/searchServices/"),
               (kind: VariableSegment, value: "searchServiceName"),
               (kind: ConstantSegment, value: "/createQueryKey/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_QueryKeysCreate_564193(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Generates a new query key for the specified Search service. You can create up to 50 query keys per service.
  ## 
  ## https://aka.ms/search-manage
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the new query API key.
  ##   subscriptionId: JString (required)
  ##                 : The unique identifier for a Microsoft Azure subscription. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   searchServiceName: JString (required)
  ##                    : The name of the Azure Search service associated with the specified resource group.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the current subscription. You can obtain this value from the Azure Resource Manager API or the portal.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_564195 = path.getOrDefault("name")
  valid_564195 = validateParameter(valid_564195, JString, required = true,
                                 default = nil)
  if valid_564195 != nil:
    section.add "name", valid_564195
  var valid_564196 = path.getOrDefault("subscriptionId")
  valid_564196 = validateParameter(valid_564196, JString, required = true,
                                 default = nil)
  if valid_564196 != nil:
    section.add "subscriptionId", valid_564196
  var valid_564197 = path.getOrDefault("searchServiceName")
  valid_564197 = validateParameter(valid_564197, JString, required = true,
                                 default = nil)
  if valid_564197 != nil:
    section.add "searchServiceName", valid_564197
  var valid_564198 = path.getOrDefault("resourceGroupName")
  valid_564198 = validateParameter(valid_564198, JString, required = true,
                                 default = nil)
  if valid_564198 != nil:
    section.add "resourceGroupName", valid_564198
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for each request. The current version is 2015-08-19.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564199 = query.getOrDefault("api-version")
  valid_564199 = validateParameter(valid_564199, JString, required = true,
                                 default = nil)
  if valid_564199 != nil:
    section.add "api-version", valid_564199
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-client-request-id: JString
  ##                         : A client-generated GUID value that identifies this request. If specified, this will be included in response information as a way to track the request.
  section = newJObject()
  var valid_564200 = header.getOrDefault("x-ms-client-request-id")
  valid_564200 = validateParameter(valid_564200, JString, required = false,
                                 default = nil)
  if valid_564200 != nil:
    section.add "x-ms-client-request-id", valid_564200
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564201: Call_QueryKeysCreate_564192; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Generates a new query key for the specified Search service. You can create up to 50 query keys per service.
  ## 
  ## https://aka.ms/search-manage
  let valid = call_564201.validator(path, query, header, formData, body)
  let scheme = call_564201.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564201.url(scheme.get, call_564201.host, call_564201.base,
                         call_564201.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564201, url, valid)

proc call*(call_564202: Call_QueryKeysCreate_564192; apiVersion: string;
          name: string; subscriptionId: string; searchServiceName: string;
          resourceGroupName: string): Recallable =
  ## queryKeysCreate
  ## Generates a new query key for the specified Search service. You can create up to 50 query keys per service.
  ## https://aka.ms/search-manage
  ##   apiVersion: string (required)
  ##             : The API version to use for each request. The current version is 2015-08-19.
  ##   name: string (required)
  ##       : The name of the new query API key.
  ##   subscriptionId: string (required)
  ##                 : The unique identifier for a Microsoft Azure subscription. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   searchServiceName: string (required)
  ##                    : The name of the Azure Search service associated with the specified resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the current subscription. You can obtain this value from the Azure Resource Manager API or the portal.
  var path_564203 = newJObject()
  var query_564204 = newJObject()
  add(query_564204, "api-version", newJString(apiVersion))
  add(path_564203, "name", newJString(name))
  add(path_564203, "subscriptionId", newJString(subscriptionId))
  add(path_564203, "searchServiceName", newJString(searchServiceName))
  add(path_564203, "resourceGroupName", newJString(resourceGroupName))
  result = call_564202.call(path_564203, query_564204, nil, nil, nil)

var queryKeysCreate* = Call_QueryKeysCreate_564192(name: "queryKeysCreate",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Search/searchServices/{searchServiceName}/createQueryKey/{name}",
    validator: validate_QueryKeysCreate_564193, base: "", url: url_QueryKeysCreate_564194,
    schemes: {Scheme.Https})
type
  Call_QueryKeysDelete_564205 = ref object of OpenApiRestCall_563556
proc url_QueryKeysDelete_564207(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "searchServiceName" in path,
        "`searchServiceName` is a required path parameter"
  assert "key" in path, "`key` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Search/searchServices/"),
               (kind: VariableSegment, value: "searchServiceName"),
               (kind: ConstantSegment, value: "/deleteQueryKey/"),
               (kind: VariableSegment, value: "key")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_QueryKeysDelete_564206(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Deletes the specified query key. Unlike admin keys, query keys are not regenerated. The process for regenerating a query key is to delete and then recreate it.
  ## 
  ## https://aka.ms/search-manage
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The unique identifier for a Microsoft Azure subscription. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   searchServiceName: JString (required)
  ##                    : The name of the Azure Search service associated with the specified resource group.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the current subscription. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   key: JString (required)
  ##      : The query key to be deleted. Query keys are identified by value, not by name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564208 = path.getOrDefault("subscriptionId")
  valid_564208 = validateParameter(valid_564208, JString, required = true,
                                 default = nil)
  if valid_564208 != nil:
    section.add "subscriptionId", valid_564208
  var valid_564209 = path.getOrDefault("searchServiceName")
  valid_564209 = validateParameter(valid_564209, JString, required = true,
                                 default = nil)
  if valid_564209 != nil:
    section.add "searchServiceName", valid_564209
  var valid_564210 = path.getOrDefault("resourceGroupName")
  valid_564210 = validateParameter(valid_564210, JString, required = true,
                                 default = nil)
  if valid_564210 != nil:
    section.add "resourceGroupName", valid_564210
  var valid_564211 = path.getOrDefault("key")
  valid_564211 = validateParameter(valid_564211, JString, required = true,
                                 default = nil)
  if valid_564211 != nil:
    section.add "key", valid_564211
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for each request. The current version is 2015-08-19.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564212 = query.getOrDefault("api-version")
  valid_564212 = validateParameter(valid_564212, JString, required = true,
                                 default = nil)
  if valid_564212 != nil:
    section.add "api-version", valid_564212
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-client-request-id: JString
  ##                         : A client-generated GUID value that identifies this request. If specified, this will be included in response information as a way to track the request.
  section = newJObject()
  var valid_564213 = header.getOrDefault("x-ms-client-request-id")
  valid_564213 = validateParameter(valid_564213, JString, required = false,
                                 default = nil)
  if valid_564213 != nil:
    section.add "x-ms-client-request-id", valid_564213
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564214: Call_QueryKeysDelete_564205; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified query key. Unlike admin keys, query keys are not regenerated. The process for regenerating a query key is to delete and then recreate it.
  ## 
  ## https://aka.ms/search-manage
  let valid = call_564214.validator(path, query, header, formData, body)
  let scheme = call_564214.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564214.url(scheme.get, call_564214.host, call_564214.base,
                         call_564214.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564214, url, valid)

proc call*(call_564215: Call_QueryKeysDelete_564205; apiVersion: string;
          subscriptionId: string; searchServiceName: string;
          resourceGroupName: string; key: string): Recallable =
  ## queryKeysDelete
  ## Deletes the specified query key. Unlike admin keys, query keys are not regenerated. The process for regenerating a query key is to delete and then recreate it.
  ## https://aka.ms/search-manage
  ##   apiVersion: string (required)
  ##             : The API version to use for each request. The current version is 2015-08-19.
  ##   subscriptionId: string (required)
  ##                 : The unique identifier for a Microsoft Azure subscription. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   searchServiceName: string (required)
  ##                    : The name of the Azure Search service associated with the specified resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the current subscription. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   key: string (required)
  ##      : The query key to be deleted. Query keys are identified by value, not by name.
  var path_564216 = newJObject()
  var query_564217 = newJObject()
  add(query_564217, "api-version", newJString(apiVersion))
  add(path_564216, "subscriptionId", newJString(subscriptionId))
  add(path_564216, "searchServiceName", newJString(searchServiceName))
  add(path_564216, "resourceGroupName", newJString(resourceGroupName))
  add(path_564216, "key", newJString(key))
  result = call_564215.call(path_564216, query_564217, nil, nil, nil)

var queryKeysDelete* = Call_QueryKeysDelete_564205(name: "queryKeysDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Search/searchServices/{searchServiceName}/deleteQueryKey/{key}",
    validator: validate_QueryKeysDelete_564206, base: "", url: url_QueryKeysDelete_564207,
    schemes: {Scheme.Https})
type
  Call_AdminKeysGet_564218 = ref object of OpenApiRestCall_563556
proc url_AdminKeysGet_564220(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "searchServiceName" in path,
        "`searchServiceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Search/searchServices/"),
               (kind: VariableSegment, value: "searchServiceName"),
               (kind: ConstantSegment, value: "/listAdminKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdminKeysGet_564219(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the primary and secondary admin API keys for the specified Azure Search service.
  ## 
  ## https://aka.ms/search-manage
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The unique identifier for a Microsoft Azure subscription. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   searchServiceName: JString (required)
  ##                    : The name of the Azure Search service associated with the specified resource group.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the current subscription. You can obtain this value from the Azure Resource Manager API or the portal.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564221 = path.getOrDefault("subscriptionId")
  valid_564221 = validateParameter(valid_564221, JString, required = true,
                                 default = nil)
  if valid_564221 != nil:
    section.add "subscriptionId", valid_564221
  var valid_564222 = path.getOrDefault("searchServiceName")
  valid_564222 = validateParameter(valid_564222, JString, required = true,
                                 default = nil)
  if valid_564222 != nil:
    section.add "searchServiceName", valid_564222
  var valid_564223 = path.getOrDefault("resourceGroupName")
  valid_564223 = validateParameter(valid_564223, JString, required = true,
                                 default = nil)
  if valid_564223 != nil:
    section.add "resourceGroupName", valid_564223
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for each request. The current version is 2015-08-19.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564224 = query.getOrDefault("api-version")
  valid_564224 = validateParameter(valid_564224, JString, required = true,
                                 default = nil)
  if valid_564224 != nil:
    section.add "api-version", valid_564224
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-client-request-id: JString
  ##                         : A client-generated GUID value that identifies this request. If specified, this will be included in response information as a way to track the request.
  section = newJObject()
  var valid_564225 = header.getOrDefault("x-ms-client-request-id")
  valid_564225 = validateParameter(valid_564225, JString, required = false,
                                 default = nil)
  if valid_564225 != nil:
    section.add "x-ms-client-request-id", valid_564225
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564226: Call_AdminKeysGet_564218; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the primary and secondary admin API keys for the specified Azure Search service.
  ## 
  ## https://aka.ms/search-manage
  let valid = call_564226.validator(path, query, header, formData, body)
  let scheme = call_564226.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564226.url(scheme.get, call_564226.host, call_564226.base,
                         call_564226.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564226, url, valid)

proc call*(call_564227: Call_AdminKeysGet_564218; apiVersion: string;
          subscriptionId: string; searchServiceName: string;
          resourceGroupName: string): Recallable =
  ## adminKeysGet
  ## Gets the primary and secondary admin API keys for the specified Azure Search service.
  ## https://aka.ms/search-manage
  ##   apiVersion: string (required)
  ##             : The API version to use for each request. The current version is 2015-08-19.
  ##   subscriptionId: string (required)
  ##                 : The unique identifier for a Microsoft Azure subscription. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   searchServiceName: string (required)
  ##                    : The name of the Azure Search service associated with the specified resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the current subscription. You can obtain this value from the Azure Resource Manager API or the portal.
  var path_564228 = newJObject()
  var query_564229 = newJObject()
  add(query_564229, "api-version", newJString(apiVersion))
  add(path_564228, "subscriptionId", newJString(subscriptionId))
  add(path_564228, "searchServiceName", newJString(searchServiceName))
  add(path_564228, "resourceGroupName", newJString(resourceGroupName))
  result = call_564227.call(path_564228, query_564229, nil, nil, nil)

var adminKeysGet* = Call_AdminKeysGet_564218(name: "adminKeysGet",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Search/searchServices/{searchServiceName}/listAdminKeys",
    validator: validate_AdminKeysGet_564219, base: "", url: url_AdminKeysGet_564220,
    schemes: {Scheme.Https})
type
  Call_QueryKeysListBySearchService_564230 = ref object of OpenApiRestCall_563556
proc url_QueryKeysListBySearchService_564232(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "searchServiceName" in path,
        "`searchServiceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Search/searchServices/"),
               (kind: VariableSegment, value: "searchServiceName"),
               (kind: ConstantSegment, value: "/listQueryKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_QueryKeysListBySearchService_564231(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the list of query API keys for the given Azure Search service.
  ## 
  ## https://aka.ms/search-manage
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The unique identifier for a Microsoft Azure subscription. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   searchServiceName: JString (required)
  ##                    : The name of the Azure Search service associated with the specified resource group.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the current subscription. You can obtain this value from the Azure Resource Manager API or the portal.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564233 = path.getOrDefault("subscriptionId")
  valid_564233 = validateParameter(valid_564233, JString, required = true,
                                 default = nil)
  if valid_564233 != nil:
    section.add "subscriptionId", valid_564233
  var valid_564234 = path.getOrDefault("searchServiceName")
  valid_564234 = validateParameter(valid_564234, JString, required = true,
                                 default = nil)
  if valid_564234 != nil:
    section.add "searchServiceName", valid_564234
  var valid_564235 = path.getOrDefault("resourceGroupName")
  valid_564235 = validateParameter(valid_564235, JString, required = true,
                                 default = nil)
  if valid_564235 != nil:
    section.add "resourceGroupName", valid_564235
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for each request. The current version is 2015-08-19.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564236 = query.getOrDefault("api-version")
  valid_564236 = validateParameter(valid_564236, JString, required = true,
                                 default = nil)
  if valid_564236 != nil:
    section.add "api-version", valid_564236
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-client-request-id: JString
  ##                         : A client-generated GUID value that identifies this request. If specified, this will be included in response information as a way to track the request.
  section = newJObject()
  var valid_564237 = header.getOrDefault("x-ms-client-request-id")
  valid_564237 = validateParameter(valid_564237, JString, required = false,
                                 default = nil)
  if valid_564237 != nil:
    section.add "x-ms-client-request-id", valid_564237
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564238: Call_QueryKeysListBySearchService_564230; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the list of query API keys for the given Azure Search service.
  ## 
  ## https://aka.ms/search-manage
  let valid = call_564238.validator(path, query, header, formData, body)
  let scheme = call_564238.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564238.url(scheme.get, call_564238.host, call_564238.base,
                         call_564238.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564238, url, valid)

proc call*(call_564239: Call_QueryKeysListBySearchService_564230;
          apiVersion: string; subscriptionId: string; searchServiceName: string;
          resourceGroupName: string): Recallable =
  ## queryKeysListBySearchService
  ## Returns the list of query API keys for the given Azure Search service.
  ## https://aka.ms/search-manage
  ##   apiVersion: string (required)
  ##             : The API version to use for each request. The current version is 2015-08-19.
  ##   subscriptionId: string (required)
  ##                 : The unique identifier for a Microsoft Azure subscription. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   searchServiceName: string (required)
  ##                    : The name of the Azure Search service associated with the specified resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the current subscription. You can obtain this value from the Azure Resource Manager API or the portal.
  var path_564240 = newJObject()
  var query_564241 = newJObject()
  add(query_564241, "api-version", newJString(apiVersion))
  add(path_564240, "subscriptionId", newJString(subscriptionId))
  add(path_564240, "searchServiceName", newJString(searchServiceName))
  add(path_564240, "resourceGroupName", newJString(resourceGroupName))
  result = call_564239.call(path_564240, query_564241, nil, nil, nil)

var queryKeysListBySearchService* = Call_QueryKeysListBySearchService_564230(
    name: "queryKeysListBySearchService", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Search/searchServices/{searchServiceName}/listQueryKeys",
    validator: validate_QueryKeysListBySearchService_564231, base: "",
    url: url_QueryKeysListBySearchService_564232, schemes: {Scheme.Https})
type
  Call_AdminKeysRegenerate_564242 = ref object of OpenApiRestCall_563556
proc url_AdminKeysRegenerate_564244(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "searchServiceName" in path,
        "`searchServiceName` is a required path parameter"
  assert "keyKind" in path, "`keyKind` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Search/searchServices/"),
               (kind: VariableSegment, value: "searchServiceName"),
               (kind: ConstantSegment, value: "/regenerateAdminKey/"),
               (kind: VariableSegment, value: "keyKind")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdminKeysRegenerate_564243(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Regenerates either the primary or secondary admin API key. You can only regenerate one key at a time.
  ## 
  ## https://aka.ms/search-manage
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The unique identifier for a Microsoft Azure subscription. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   searchServiceName: JString (required)
  ##                    : The name of the Azure Search service associated with the specified resource group.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the current subscription. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   keyKind: JString (required)
  ##          : Specifies which key to regenerate. Valid values include 'primary' and 'secondary'.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564245 = path.getOrDefault("subscriptionId")
  valid_564245 = validateParameter(valid_564245, JString, required = true,
                                 default = nil)
  if valid_564245 != nil:
    section.add "subscriptionId", valid_564245
  var valid_564246 = path.getOrDefault("searchServiceName")
  valid_564246 = validateParameter(valid_564246, JString, required = true,
                                 default = nil)
  if valid_564246 != nil:
    section.add "searchServiceName", valid_564246
  var valid_564247 = path.getOrDefault("resourceGroupName")
  valid_564247 = validateParameter(valid_564247, JString, required = true,
                                 default = nil)
  if valid_564247 != nil:
    section.add "resourceGroupName", valid_564247
  var valid_564261 = path.getOrDefault("keyKind")
  valid_564261 = validateParameter(valid_564261, JString, required = true,
                                 default = newJString("primary"))
  if valid_564261 != nil:
    section.add "keyKind", valid_564261
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for each request. The current version is 2015-08-19.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564262 = query.getOrDefault("api-version")
  valid_564262 = validateParameter(valid_564262, JString, required = true,
                                 default = nil)
  if valid_564262 != nil:
    section.add "api-version", valid_564262
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-client-request-id: JString
  ##                         : A client-generated GUID value that identifies this request. If specified, this will be included in response information as a way to track the request.
  section = newJObject()
  var valid_564263 = header.getOrDefault("x-ms-client-request-id")
  valid_564263 = validateParameter(valid_564263, JString, required = false,
                                 default = nil)
  if valid_564263 != nil:
    section.add "x-ms-client-request-id", valid_564263
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564264: Call_AdminKeysRegenerate_564242; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Regenerates either the primary or secondary admin API key. You can only regenerate one key at a time.
  ## 
  ## https://aka.ms/search-manage
  let valid = call_564264.validator(path, query, header, formData, body)
  let scheme = call_564264.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564264.url(scheme.get, call_564264.host, call_564264.base,
                         call_564264.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564264, url, valid)

proc call*(call_564265: Call_AdminKeysRegenerate_564242; apiVersion: string;
          subscriptionId: string; searchServiceName: string;
          resourceGroupName: string; keyKind: string = "primary"): Recallable =
  ## adminKeysRegenerate
  ## Regenerates either the primary or secondary admin API key. You can only regenerate one key at a time.
  ## https://aka.ms/search-manage
  ##   apiVersion: string (required)
  ##             : The API version to use for each request. The current version is 2015-08-19.
  ##   subscriptionId: string (required)
  ##                 : The unique identifier for a Microsoft Azure subscription. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   searchServiceName: string (required)
  ##                    : The name of the Azure Search service associated with the specified resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the current subscription. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   keyKind: string (required)
  ##          : Specifies which key to regenerate. Valid values include 'primary' and 'secondary'.
  var path_564266 = newJObject()
  var query_564267 = newJObject()
  add(query_564267, "api-version", newJString(apiVersion))
  add(path_564266, "subscriptionId", newJString(subscriptionId))
  add(path_564266, "searchServiceName", newJString(searchServiceName))
  add(path_564266, "resourceGroupName", newJString(resourceGroupName))
  add(path_564266, "keyKind", newJString(keyKind))
  result = call_564265.call(path_564266, query_564267, nil, nil, nil)

var adminKeysRegenerate* = Call_AdminKeysRegenerate_564242(
    name: "adminKeysRegenerate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Search/searchServices/{searchServiceName}/regenerateAdminKey/{keyKind}",
    validator: validate_AdminKeysRegenerate_564243, base: "",
    url: url_AdminKeysRegenerate_564244, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
