
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_567658 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567658](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567658): Option[Scheme] {.used.} =
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
  macServiceName = "search"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_567880 = ref object of OpenApiRestCall_567658
proc url_OperationsList_567882(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_567881(path: JsonNode; query: JsonNode;
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
  var valid_568041 = query.getOrDefault("api-version")
  valid_568041 = validateParameter(valid_568041, JString, required = true,
                                 default = nil)
  if valid_568041 != nil:
    section.add "api-version", valid_568041
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568064: Call_OperationsList_567880; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available REST API operations of the Microsoft.Search provider.
  ## 
  let valid = call_568064.validator(path, query, header, formData, body)
  let scheme = call_568064.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568064.url(scheme.get, call_568064.host, call_568064.base,
                         call_568064.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568064, url, valid)

proc call*(call_568135: Call_OperationsList_567880; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available REST API operations of the Microsoft.Search provider.
  ##   apiVersion: string (required)
  ##             : The API version to use for each request. The current version is 2015-08-19.
  var query_568136 = newJObject()
  add(query_568136, "api-version", newJString(apiVersion))
  result = call_568135.call(nil, query_568136, nil, nil, nil)

var operationsList* = Call_OperationsList_567880(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Search/operations",
    validator: validate_OperationsList_567881, base: "", url: url_OperationsList_567882,
    schemes: {Scheme.Https})
type
  Call_ServicesCheckNameAvailability_568176 = ref object of OpenApiRestCall_567658
proc url_ServicesCheckNameAvailability_568178(protocol: Scheme; host: string;
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

proc validate_ServicesCheckNameAvailability_568177(path: JsonNode; query: JsonNode;
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
  var valid_568193 = path.getOrDefault("subscriptionId")
  valid_568193 = validateParameter(valid_568193, JString, required = true,
                                 default = nil)
  if valid_568193 != nil:
    section.add "subscriptionId", valid_568193
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for each request. The current version is 2015-08-19.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568194 = query.getOrDefault("api-version")
  valid_568194 = validateParameter(valid_568194, JString, required = true,
                                 default = nil)
  if valid_568194 != nil:
    section.add "api-version", valid_568194
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-client-request-id: JString
  ##                         : A client-generated GUID value that identifies this request. If specified, this will be included in response information as a way to track the request.
  section = newJObject()
  var valid_568195 = header.getOrDefault("x-ms-client-request-id")
  valid_568195 = validateParameter(valid_568195, JString, required = false,
                                 default = nil)
  if valid_568195 != nil:
    section.add "x-ms-client-request-id", valid_568195
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

proc call*(call_568197: Call_ServicesCheckNameAvailability_568176; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks whether or not the given Search service name is available for use. Search service names must be globally unique since they are part of the service URI (https://<name>.search.windows.net).
  ## 
  ## https://aka.ms/search-manage
  let valid = call_568197.validator(path, query, header, formData, body)
  let scheme = call_568197.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568197.url(scheme.get, call_568197.host, call_568197.base,
                         call_568197.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568197, url, valid)

proc call*(call_568198: Call_ServicesCheckNameAvailability_568176;
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
  var path_568199 = newJObject()
  var query_568200 = newJObject()
  var body_568201 = newJObject()
  add(query_568200, "api-version", newJString(apiVersion))
  add(path_568199, "subscriptionId", newJString(subscriptionId))
  if checkNameAvailabilityInput != nil:
    body_568201 = checkNameAvailabilityInput
  result = call_568198.call(path_568199, query_568200, nil, nil, body_568201)

var servicesCheckNameAvailability* = Call_ServicesCheckNameAvailability_568176(
    name: "servicesCheckNameAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Search/checkNameAvailability",
    validator: validate_ServicesCheckNameAvailability_568177, base: "",
    url: url_ServicesCheckNameAvailability_568178, schemes: {Scheme.Https})
type
  Call_ServicesListBySubscription_568202 = ref object of OpenApiRestCall_567658
proc url_ServicesListBySubscription_568204(protocol: Scheme; host: string;
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

proc validate_ServicesListBySubscription_568203(path: JsonNode; query: JsonNode;
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
  var valid_568205 = path.getOrDefault("subscriptionId")
  valid_568205 = validateParameter(valid_568205, JString, required = true,
                                 default = nil)
  if valid_568205 != nil:
    section.add "subscriptionId", valid_568205
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for each request. The current version is 2015-08-19.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568206 = query.getOrDefault("api-version")
  valid_568206 = validateParameter(valid_568206, JString, required = true,
                                 default = nil)
  if valid_568206 != nil:
    section.add "api-version", valid_568206
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-client-request-id: JString
  ##                         : A client-generated GUID value that identifies this request. If specified, this will be included in response information as a way to track the request.
  section = newJObject()
  var valid_568207 = header.getOrDefault("x-ms-client-request-id")
  valid_568207 = validateParameter(valid_568207, JString, required = false,
                                 default = nil)
  if valid_568207 != nil:
    section.add "x-ms-client-request-id", valid_568207
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568208: Call_ServicesListBySubscription_568202; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of all Search services in the given subscription.
  ## 
  ## https://aka.ms/search-manage
  let valid = call_568208.validator(path, query, header, formData, body)
  let scheme = call_568208.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568208.url(scheme.get, call_568208.host, call_568208.base,
                         call_568208.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568208, url, valid)

proc call*(call_568209: Call_ServicesListBySubscription_568202; apiVersion: string;
          subscriptionId: string): Recallable =
  ## servicesListBySubscription
  ## Gets a list of all Search services in the given subscription.
  ## https://aka.ms/search-manage
  ##   apiVersion: string (required)
  ##             : The API version to use for each request. The current version is 2015-08-19.
  ##   subscriptionId: string (required)
  ##                 : The unique identifier for a Microsoft Azure subscription. You can obtain this value from the Azure Resource Manager API or the portal.
  var path_568210 = newJObject()
  var query_568211 = newJObject()
  add(query_568211, "api-version", newJString(apiVersion))
  add(path_568210, "subscriptionId", newJString(subscriptionId))
  result = call_568209.call(path_568210, query_568211, nil, nil, nil)

var servicesListBySubscription* = Call_ServicesListBySubscription_568202(
    name: "servicesListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Search/searchServices",
    validator: validate_ServicesListBySubscription_568203, base: "",
    url: url_ServicesListBySubscription_568204, schemes: {Scheme.Https})
type
  Call_ServicesListByResourceGroup_568212 = ref object of OpenApiRestCall_567658
proc url_ServicesListByResourceGroup_568214(protocol: Scheme; host: string;
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

proc validate_ServicesListByResourceGroup_568213(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of all Search services in the given resource group.
  ## 
  ## https://aka.ms/search-manage
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the current subscription. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   subscriptionId: JString (required)
  ##                 : The unique identifier for a Microsoft Azure subscription. You can obtain this value from the Azure Resource Manager API or the portal.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568215 = path.getOrDefault("resourceGroupName")
  valid_568215 = validateParameter(valid_568215, JString, required = true,
                                 default = nil)
  if valid_568215 != nil:
    section.add "resourceGroupName", valid_568215
  var valid_568216 = path.getOrDefault("subscriptionId")
  valid_568216 = validateParameter(valid_568216, JString, required = true,
                                 default = nil)
  if valid_568216 != nil:
    section.add "subscriptionId", valid_568216
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for each request. The current version is 2015-08-19.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568217 = query.getOrDefault("api-version")
  valid_568217 = validateParameter(valid_568217, JString, required = true,
                                 default = nil)
  if valid_568217 != nil:
    section.add "api-version", valid_568217
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-client-request-id: JString
  ##                         : A client-generated GUID value that identifies this request. If specified, this will be included in response information as a way to track the request.
  section = newJObject()
  var valid_568218 = header.getOrDefault("x-ms-client-request-id")
  valid_568218 = validateParameter(valid_568218, JString, required = false,
                                 default = nil)
  if valid_568218 != nil:
    section.add "x-ms-client-request-id", valid_568218
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568219: Call_ServicesListByResourceGroup_568212; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of all Search services in the given resource group.
  ## 
  ## https://aka.ms/search-manage
  let valid = call_568219.validator(path, query, header, formData, body)
  let scheme = call_568219.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568219.url(scheme.get, call_568219.host, call_568219.base,
                         call_568219.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568219, url, valid)

proc call*(call_568220: Call_ServicesListByResourceGroup_568212;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## servicesListByResourceGroup
  ## Gets a list of all Search services in the given resource group.
  ## https://aka.ms/search-manage
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the current subscription. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for each request. The current version is 2015-08-19.
  ##   subscriptionId: string (required)
  ##                 : The unique identifier for a Microsoft Azure subscription. You can obtain this value from the Azure Resource Manager API or the portal.
  var path_568221 = newJObject()
  var query_568222 = newJObject()
  add(path_568221, "resourceGroupName", newJString(resourceGroupName))
  add(query_568222, "api-version", newJString(apiVersion))
  add(path_568221, "subscriptionId", newJString(subscriptionId))
  result = call_568220.call(path_568221, query_568222, nil, nil, nil)

var servicesListByResourceGroup* = Call_ServicesListByResourceGroup_568212(
    name: "servicesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Search/searchServices",
    validator: validate_ServicesListByResourceGroup_568213, base: "",
    url: url_ServicesListByResourceGroup_568214, schemes: {Scheme.Https})
type
  Call_ServicesCreateOrUpdate_568235 = ref object of OpenApiRestCall_567658
proc url_ServicesCreateOrUpdate_568237(protocol: Scheme; host: string; base: string;
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

proc validate_ServicesCreateOrUpdate_568236(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a Search service in the given resource group. If the Search service already exists, all properties will be updated with the given values.
  ## 
  ## https://aka.ms/search-manage
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the current subscription. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   subscriptionId: JString (required)
  ##                 : The unique identifier for a Microsoft Azure subscription. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   searchServiceName: JString (required)
  ##                    : The name of the Azure Search service to create or update. Search service names must only contain lowercase letters, digits or dashes, cannot use dash as the first two or last one characters, cannot contain consecutive dashes, and must be between 2 and 60 characters in length. Search service names must be globally unique since they are part of the service URI (https://<name>.search.windows.net). You cannot change the service name after the service is created.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568255 = path.getOrDefault("resourceGroupName")
  valid_568255 = validateParameter(valid_568255, JString, required = true,
                                 default = nil)
  if valid_568255 != nil:
    section.add "resourceGroupName", valid_568255
  var valid_568256 = path.getOrDefault("subscriptionId")
  valid_568256 = validateParameter(valid_568256, JString, required = true,
                                 default = nil)
  if valid_568256 != nil:
    section.add "subscriptionId", valid_568256
  var valid_568257 = path.getOrDefault("searchServiceName")
  valid_568257 = validateParameter(valid_568257, JString, required = true,
                                 default = nil)
  if valid_568257 != nil:
    section.add "searchServiceName", valid_568257
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for each request. The current version is 2015-08-19.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568258 = query.getOrDefault("api-version")
  valid_568258 = validateParameter(valid_568258, JString, required = true,
                                 default = nil)
  if valid_568258 != nil:
    section.add "api-version", valid_568258
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-client-request-id: JString
  ##                         : A client-generated GUID value that identifies this request. If specified, this will be included in response information as a way to track the request.
  section = newJObject()
  var valid_568259 = header.getOrDefault("x-ms-client-request-id")
  valid_568259 = validateParameter(valid_568259, JString, required = false,
                                 default = nil)
  if valid_568259 != nil:
    section.add "x-ms-client-request-id", valid_568259
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

proc call*(call_568261: Call_ServicesCreateOrUpdate_568235; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a Search service in the given resource group. If the Search service already exists, all properties will be updated with the given values.
  ## 
  ## https://aka.ms/search-manage
  let valid = call_568261.validator(path, query, header, formData, body)
  let scheme = call_568261.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568261.url(scheme.get, call_568261.host, call_568261.base,
                         call_568261.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568261, url, valid)

proc call*(call_568262: Call_ServicesCreateOrUpdate_568235;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          searchServiceName: string; service: JsonNode): Recallable =
  ## servicesCreateOrUpdate
  ## Creates or updates a Search service in the given resource group. If the Search service already exists, all properties will be updated with the given values.
  ## https://aka.ms/search-manage
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the current subscription. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for each request. The current version is 2015-08-19.
  ##   subscriptionId: string (required)
  ##                 : The unique identifier for a Microsoft Azure subscription. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   searchServiceName: string (required)
  ##                    : The name of the Azure Search service to create or update. Search service names must only contain lowercase letters, digits or dashes, cannot use dash as the first two or last one characters, cannot contain consecutive dashes, and must be between 2 and 60 characters in length. Search service names must be globally unique since they are part of the service URI (https://<name>.search.windows.net). You cannot change the service name after the service is created.
  ##   service: JObject (required)
  ##          : The definition of the Search service to create or update.
  var path_568263 = newJObject()
  var query_568264 = newJObject()
  var body_568265 = newJObject()
  add(path_568263, "resourceGroupName", newJString(resourceGroupName))
  add(query_568264, "api-version", newJString(apiVersion))
  add(path_568263, "subscriptionId", newJString(subscriptionId))
  add(path_568263, "searchServiceName", newJString(searchServiceName))
  if service != nil:
    body_568265 = service
  result = call_568262.call(path_568263, query_568264, nil, nil, body_568265)

var servicesCreateOrUpdate* = Call_ServicesCreateOrUpdate_568235(
    name: "servicesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Search/searchServices/{searchServiceName}",
    validator: validate_ServicesCreateOrUpdate_568236, base: "",
    url: url_ServicesCreateOrUpdate_568237, schemes: {Scheme.Https})
type
  Call_ServicesGet_568223 = ref object of OpenApiRestCall_567658
proc url_ServicesGet_568225(protocol: Scheme; host: string; base: string;
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

proc validate_ServicesGet_568224(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the Search service with the given name in the given resource group.
  ## 
  ## https://aka.ms/search-manage
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the current subscription. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   subscriptionId: JString (required)
  ##                 : The unique identifier for a Microsoft Azure subscription. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   searchServiceName: JString (required)
  ##                    : The name of the Azure Search service associated with the specified resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568226 = path.getOrDefault("resourceGroupName")
  valid_568226 = validateParameter(valid_568226, JString, required = true,
                                 default = nil)
  if valid_568226 != nil:
    section.add "resourceGroupName", valid_568226
  var valid_568227 = path.getOrDefault("subscriptionId")
  valid_568227 = validateParameter(valid_568227, JString, required = true,
                                 default = nil)
  if valid_568227 != nil:
    section.add "subscriptionId", valid_568227
  var valid_568228 = path.getOrDefault("searchServiceName")
  valid_568228 = validateParameter(valid_568228, JString, required = true,
                                 default = nil)
  if valid_568228 != nil:
    section.add "searchServiceName", valid_568228
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for each request. The current version is 2015-08-19.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568229 = query.getOrDefault("api-version")
  valid_568229 = validateParameter(valid_568229, JString, required = true,
                                 default = nil)
  if valid_568229 != nil:
    section.add "api-version", valid_568229
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-client-request-id: JString
  ##                         : A client-generated GUID value that identifies this request. If specified, this will be included in response information as a way to track the request.
  section = newJObject()
  var valid_568230 = header.getOrDefault("x-ms-client-request-id")
  valid_568230 = validateParameter(valid_568230, JString, required = false,
                                 default = nil)
  if valid_568230 != nil:
    section.add "x-ms-client-request-id", valid_568230
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568231: Call_ServicesGet_568223; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the Search service with the given name in the given resource group.
  ## 
  ## https://aka.ms/search-manage
  let valid = call_568231.validator(path, query, header, formData, body)
  let scheme = call_568231.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568231.url(scheme.get, call_568231.host, call_568231.base,
                         call_568231.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568231, url, valid)

proc call*(call_568232: Call_ServicesGet_568223; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; searchServiceName: string): Recallable =
  ## servicesGet
  ## Gets the Search service with the given name in the given resource group.
  ## https://aka.ms/search-manage
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the current subscription. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for each request. The current version is 2015-08-19.
  ##   subscriptionId: string (required)
  ##                 : The unique identifier for a Microsoft Azure subscription. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   searchServiceName: string (required)
  ##                    : The name of the Azure Search service associated with the specified resource group.
  var path_568233 = newJObject()
  var query_568234 = newJObject()
  add(path_568233, "resourceGroupName", newJString(resourceGroupName))
  add(query_568234, "api-version", newJString(apiVersion))
  add(path_568233, "subscriptionId", newJString(subscriptionId))
  add(path_568233, "searchServiceName", newJString(searchServiceName))
  result = call_568232.call(path_568233, query_568234, nil, nil, nil)

var servicesGet* = Call_ServicesGet_568223(name: "servicesGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Search/searchServices/{searchServiceName}",
                                        validator: validate_ServicesGet_568224,
                                        base: "", url: url_ServicesGet_568225,
                                        schemes: {Scheme.Https})
type
  Call_ServicesUpdate_568278 = ref object of OpenApiRestCall_567658
proc url_ServicesUpdate_568280(protocol: Scheme; host: string; base: string;
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

proc validate_ServicesUpdate_568279(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Updates an existing Search service in the given resource group.
  ## 
  ## https://aka.ms/search-manage
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the current subscription. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   subscriptionId: JString (required)
  ##                 : The unique identifier for a Microsoft Azure subscription. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   searchServiceName: JString (required)
  ##                    : The name of the Azure Search service to update.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568281 = path.getOrDefault("resourceGroupName")
  valid_568281 = validateParameter(valid_568281, JString, required = true,
                                 default = nil)
  if valid_568281 != nil:
    section.add "resourceGroupName", valid_568281
  var valid_568282 = path.getOrDefault("subscriptionId")
  valid_568282 = validateParameter(valid_568282, JString, required = true,
                                 default = nil)
  if valid_568282 != nil:
    section.add "subscriptionId", valid_568282
  var valid_568283 = path.getOrDefault("searchServiceName")
  valid_568283 = validateParameter(valid_568283, JString, required = true,
                                 default = nil)
  if valid_568283 != nil:
    section.add "searchServiceName", valid_568283
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for each request. The current version is 2015-08-19.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568284 = query.getOrDefault("api-version")
  valid_568284 = validateParameter(valid_568284, JString, required = true,
                                 default = nil)
  if valid_568284 != nil:
    section.add "api-version", valid_568284
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-client-request-id: JString
  ##                         : A client-generated GUID value that identifies this request. If specified, this will be included in response information as a way to track the request.
  section = newJObject()
  var valid_568285 = header.getOrDefault("x-ms-client-request-id")
  valid_568285 = validateParameter(valid_568285, JString, required = false,
                                 default = nil)
  if valid_568285 != nil:
    section.add "x-ms-client-request-id", valid_568285
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

proc call*(call_568287: Call_ServicesUpdate_568278; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing Search service in the given resource group.
  ## 
  ## https://aka.ms/search-manage
  let valid = call_568287.validator(path, query, header, formData, body)
  let scheme = call_568287.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568287.url(scheme.get, call_568287.host, call_568287.base,
                         call_568287.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568287, url, valid)

proc call*(call_568288: Call_ServicesUpdate_568278; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; searchServiceName: string;
          service: JsonNode): Recallable =
  ## servicesUpdate
  ## Updates an existing Search service in the given resource group.
  ## https://aka.ms/search-manage
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the current subscription. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for each request. The current version is 2015-08-19.
  ##   subscriptionId: string (required)
  ##                 : The unique identifier for a Microsoft Azure subscription. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   searchServiceName: string (required)
  ##                    : The name of the Azure Search service to update.
  ##   service: JObject (required)
  ##          : The definition of the Search service to update.
  var path_568289 = newJObject()
  var query_568290 = newJObject()
  var body_568291 = newJObject()
  add(path_568289, "resourceGroupName", newJString(resourceGroupName))
  add(query_568290, "api-version", newJString(apiVersion))
  add(path_568289, "subscriptionId", newJString(subscriptionId))
  add(path_568289, "searchServiceName", newJString(searchServiceName))
  if service != nil:
    body_568291 = service
  result = call_568288.call(path_568289, query_568290, nil, nil, body_568291)

var servicesUpdate* = Call_ServicesUpdate_568278(name: "servicesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Search/searchServices/{searchServiceName}",
    validator: validate_ServicesUpdate_568279, base: "", url: url_ServicesUpdate_568280,
    schemes: {Scheme.Https})
type
  Call_ServicesDelete_568266 = ref object of OpenApiRestCall_567658
proc url_ServicesDelete_568268(protocol: Scheme; host: string; base: string;
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

proc validate_ServicesDelete_568267(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Deletes a Search service in the given resource group, along with its associated resources.
  ## 
  ## https://aka.ms/search-manage
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the current subscription. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   subscriptionId: JString (required)
  ##                 : The unique identifier for a Microsoft Azure subscription. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   searchServiceName: JString (required)
  ##                    : The name of the Azure Search service associated with the specified resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568269 = path.getOrDefault("resourceGroupName")
  valid_568269 = validateParameter(valid_568269, JString, required = true,
                                 default = nil)
  if valid_568269 != nil:
    section.add "resourceGroupName", valid_568269
  var valid_568270 = path.getOrDefault("subscriptionId")
  valid_568270 = validateParameter(valid_568270, JString, required = true,
                                 default = nil)
  if valid_568270 != nil:
    section.add "subscriptionId", valid_568270
  var valid_568271 = path.getOrDefault("searchServiceName")
  valid_568271 = validateParameter(valid_568271, JString, required = true,
                                 default = nil)
  if valid_568271 != nil:
    section.add "searchServiceName", valid_568271
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for each request. The current version is 2015-08-19.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568272 = query.getOrDefault("api-version")
  valid_568272 = validateParameter(valid_568272, JString, required = true,
                                 default = nil)
  if valid_568272 != nil:
    section.add "api-version", valid_568272
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-client-request-id: JString
  ##                         : A client-generated GUID value that identifies this request. If specified, this will be included in response information as a way to track the request.
  section = newJObject()
  var valid_568273 = header.getOrDefault("x-ms-client-request-id")
  valid_568273 = validateParameter(valid_568273, JString, required = false,
                                 default = nil)
  if valid_568273 != nil:
    section.add "x-ms-client-request-id", valid_568273
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568274: Call_ServicesDelete_568266; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a Search service in the given resource group, along with its associated resources.
  ## 
  ## https://aka.ms/search-manage
  let valid = call_568274.validator(path, query, header, formData, body)
  let scheme = call_568274.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568274.url(scheme.get, call_568274.host, call_568274.base,
                         call_568274.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568274, url, valid)

proc call*(call_568275: Call_ServicesDelete_568266; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; searchServiceName: string): Recallable =
  ## servicesDelete
  ## Deletes a Search service in the given resource group, along with its associated resources.
  ## https://aka.ms/search-manage
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the current subscription. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for each request. The current version is 2015-08-19.
  ##   subscriptionId: string (required)
  ##                 : The unique identifier for a Microsoft Azure subscription. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   searchServiceName: string (required)
  ##                    : The name of the Azure Search service associated with the specified resource group.
  var path_568276 = newJObject()
  var query_568277 = newJObject()
  add(path_568276, "resourceGroupName", newJString(resourceGroupName))
  add(query_568277, "api-version", newJString(apiVersion))
  add(path_568276, "subscriptionId", newJString(subscriptionId))
  add(path_568276, "searchServiceName", newJString(searchServiceName))
  result = call_568275.call(path_568276, query_568277, nil, nil, nil)

var servicesDelete* = Call_ServicesDelete_568266(name: "servicesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Search/searchServices/{searchServiceName}",
    validator: validate_ServicesDelete_568267, base: "", url: url_ServicesDelete_568268,
    schemes: {Scheme.Https})
type
  Call_QueryKeysCreate_568292 = ref object of OpenApiRestCall_567658
proc url_QueryKeysCreate_568294(protocol: Scheme; host: string; base: string;
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

proc validate_QueryKeysCreate_568293(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Generates a new query key for the specified Search service. You can create up to 50 query keys per service.
  ## 
  ## https://aka.ms/search-manage
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the current subscription. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   name: JString (required)
  ##       : The name of the new query API key.
  ##   subscriptionId: JString (required)
  ##                 : The unique identifier for a Microsoft Azure subscription. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   searchServiceName: JString (required)
  ##                    : The name of the Azure Search service associated with the specified resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568295 = path.getOrDefault("resourceGroupName")
  valid_568295 = validateParameter(valid_568295, JString, required = true,
                                 default = nil)
  if valid_568295 != nil:
    section.add "resourceGroupName", valid_568295
  var valid_568296 = path.getOrDefault("name")
  valid_568296 = validateParameter(valid_568296, JString, required = true,
                                 default = nil)
  if valid_568296 != nil:
    section.add "name", valid_568296
  var valid_568297 = path.getOrDefault("subscriptionId")
  valid_568297 = validateParameter(valid_568297, JString, required = true,
                                 default = nil)
  if valid_568297 != nil:
    section.add "subscriptionId", valid_568297
  var valid_568298 = path.getOrDefault("searchServiceName")
  valid_568298 = validateParameter(valid_568298, JString, required = true,
                                 default = nil)
  if valid_568298 != nil:
    section.add "searchServiceName", valid_568298
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for each request. The current version is 2015-08-19.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568299 = query.getOrDefault("api-version")
  valid_568299 = validateParameter(valid_568299, JString, required = true,
                                 default = nil)
  if valid_568299 != nil:
    section.add "api-version", valid_568299
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-client-request-id: JString
  ##                         : A client-generated GUID value that identifies this request. If specified, this will be included in response information as a way to track the request.
  section = newJObject()
  var valid_568300 = header.getOrDefault("x-ms-client-request-id")
  valid_568300 = validateParameter(valid_568300, JString, required = false,
                                 default = nil)
  if valid_568300 != nil:
    section.add "x-ms-client-request-id", valid_568300
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568301: Call_QueryKeysCreate_568292; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Generates a new query key for the specified Search service. You can create up to 50 query keys per service.
  ## 
  ## https://aka.ms/search-manage
  let valid = call_568301.validator(path, query, header, formData, body)
  let scheme = call_568301.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568301.url(scheme.get, call_568301.host, call_568301.base,
                         call_568301.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568301, url, valid)

proc call*(call_568302: Call_QueryKeysCreate_568292; resourceGroupName: string;
          apiVersion: string; name: string; subscriptionId: string;
          searchServiceName: string): Recallable =
  ## queryKeysCreate
  ## Generates a new query key for the specified Search service. You can create up to 50 query keys per service.
  ## https://aka.ms/search-manage
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the current subscription. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for each request. The current version is 2015-08-19.
  ##   name: string (required)
  ##       : The name of the new query API key.
  ##   subscriptionId: string (required)
  ##                 : The unique identifier for a Microsoft Azure subscription. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   searchServiceName: string (required)
  ##                    : The name of the Azure Search service associated with the specified resource group.
  var path_568303 = newJObject()
  var query_568304 = newJObject()
  add(path_568303, "resourceGroupName", newJString(resourceGroupName))
  add(query_568304, "api-version", newJString(apiVersion))
  add(path_568303, "name", newJString(name))
  add(path_568303, "subscriptionId", newJString(subscriptionId))
  add(path_568303, "searchServiceName", newJString(searchServiceName))
  result = call_568302.call(path_568303, query_568304, nil, nil, nil)

var queryKeysCreate* = Call_QueryKeysCreate_568292(name: "queryKeysCreate",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Search/searchServices/{searchServiceName}/createQueryKey/{name}",
    validator: validate_QueryKeysCreate_568293, base: "", url: url_QueryKeysCreate_568294,
    schemes: {Scheme.Https})
type
  Call_QueryKeysDelete_568305 = ref object of OpenApiRestCall_567658
proc url_QueryKeysDelete_568307(protocol: Scheme; host: string; base: string;
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

proc validate_QueryKeysDelete_568306(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Deletes the specified query key. Unlike admin keys, query keys are not regenerated. The process for regenerating a query key is to delete and then recreate it.
  ## 
  ## https://aka.ms/search-manage
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the current subscription. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   subscriptionId: JString (required)
  ##                 : The unique identifier for a Microsoft Azure subscription. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   searchServiceName: JString (required)
  ##                    : The name of the Azure Search service associated with the specified resource group.
  ##   key: JString (required)
  ##      : The query key to be deleted. Query keys are identified by value, not by name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568308 = path.getOrDefault("resourceGroupName")
  valid_568308 = validateParameter(valid_568308, JString, required = true,
                                 default = nil)
  if valid_568308 != nil:
    section.add "resourceGroupName", valid_568308
  var valid_568309 = path.getOrDefault("subscriptionId")
  valid_568309 = validateParameter(valid_568309, JString, required = true,
                                 default = nil)
  if valid_568309 != nil:
    section.add "subscriptionId", valid_568309
  var valid_568310 = path.getOrDefault("searchServiceName")
  valid_568310 = validateParameter(valid_568310, JString, required = true,
                                 default = nil)
  if valid_568310 != nil:
    section.add "searchServiceName", valid_568310
  var valid_568311 = path.getOrDefault("key")
  valid_568311 = validateParameter(valid_568311, JString, required = true,
                                 default = nil)
  if valid_568311 != nil:
    section.add "key", valid_568311
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for each request. The current version is 2015-08-19.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568312 = query.getOrDefault("api-version")
  valid_568312 = validateParameter(valid_568312, JString, required = true,
                                 default = nil)
  if valid_568312 != nil:
    section.add "api-version", valid_568312
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-client-request-id: JString
  ##                         : A client-generated GUID value that identifies this request. If specified, this will be included in response information as a way to track the request.
  section = newJObject()
  var valid_568313 = header.getOrDefault("x-ms-client-request-id")
  valid_568313 = validateParameter(valid_568313, JString, required = false,
                                 default = nil)
  if valid_568313 != nil:
    section.add "x-ms-client-request-id", valid_568313
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568314: Call_QueryKeysDelete_568305; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified query key. Unlike admin keys, query keys are not regenerated. The process for regenerating a query key is to delete and then recreate it.
  ## 
  ## https://aka.ms/search-manage
  let valid = call_568314.validator(path, query, header, formData, body)
  let scheme = call_568314.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568314.url(scheme.get, call_568314.host, call_568314.base,
                         call_568314.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568314, url, valid)

proc call*(call_568315: Call_QueryKeysDelete_568305; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; searchServiceName: string;
          key: string): Recallable =
  ## queryKeysDelete
  ## Deletes the specified query key. Unlike admin keys, query keys are not regenerated. The process for regenerating a query key is to delete and then recreate it.
  ## https://aka.ms/search-manage
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the current subscription. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for each request. The current version is 2015-08-19.
  ##   subscriptionId: string (required)
  ##                 : The unique identifier for a Microsoft Azure subscription. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   searchServiceName: string (required)
  ##                    : The name of the Azure Search service associated with the specified resource group.
  ##   key: string (required)
  ##      : The query key to be deleted. Query keys are identified by value, not by name.
  var path_568316 = newJObject()
  var query_568317 = newJObject()
  add(path_568316, "resourceGroupName", newJString(resourceGroupName))
  add(query_568317, "api-version", newJString(apiVersion))
  add(path_568316, "subscriptionId", newJString(subscriptionId))
  add(path_568316, "searchServiceName", newJString(searchServiceName))
  add(path_568316, "key", newJString(key))
  result = call_568315.call(path_568316, query_568317, nil, nil, nil)

var queryKeysDelete* = Call_QueryKeysDelete_568305(name: "queryKeysDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Search/searchServices/{searchServiceName}/deleteQueryKey/{key}",
    validator: validate_QueryKeysDelete_568306, base: "", url: url_QueryKeysDelete_568307,
    schemes: {Scheme.Https})
type
  Call_AdminKeysGet_568318 = ref object of OpenApiRestCall_567658
proc url_AdminKeysGet_568320(protocol: Scheme; host: string; base: string;
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

proc validate_AdminKeysGet_568319(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the primary and secondary admin API keys for the specified Azure Search service.
  ## 
  ## https://aka.ms/search-manage
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the current subscription. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   subscriptionId: JString (required)
  ##                 : The unique identifier for a Microsoft Azure subscription. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   searchServiceName: JString (required)
  ##                    : The name of the Azure Search service associated with the specified resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568321 = path.getOrDefault("resourceGroupName")
  valid_568321 = validateParameter(valid_568321, JString, required = true,
                                 default = nil)
  if valid_568321 != nil:
    section.add "resourceGroupName", valid_568321
  var valid_568322 = path.getOrDefault("subscriptionId")
  valid_568322 = validateParameter(valid_568322, JString, required = true,
                                 default = nil)
  if valid_568322 != nil:
    section.add "subscriptionId", valid_568322
  var valid_568323 = path.getOrDefault("searchServiceName")
  valid_568323 = validateParameter(valid_568323, JString, required = true,
                                 default = nil)
  if valid_568323 != nil:
    section.add "searchServiceName", valid_568323
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for each request. The current version is 2015-08-19.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568324 = query.getOrDefault("api-version")
  valid_568324 = validateParameter(valid_568324, JString, required = true,
                                 default = nil)
  if valid_568324 != nil:
    section.add "api-version", valid_568324
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-client-request-id: JString
  ##                         : A client-generated GUID value that identifies this request. If specified, this will be included in response information as a way to track the request.
  section = newJObject()
  var valid_568325 = header.getOrDefault("x-ms-client-request-id")
  valid_568325 = validateParameter(valid_568325, JString, required = false,
                                 default = nil)
  if valid_568325 != nil:
    section.add "x-ms-client-request-id", valid_568325
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568326: Call_AdminKeysGet_568318; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the primary and secondary admin API keys for the specified Azure Search service.
  ## 
  ## https://aka.ms/search-manage
  let valid = call_568326.validator(path, query, header, formData, body)
  let scheme = call_568326.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568326.url(scheme.get, call_568326.host, call_568326.base,
                         call_568326.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568326, url, valid)

proc call*(call_568327: Call_AdminKeysGet_568318; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; searchServiceName: string): Recallable =
  ## adminKeysGet
  ## Gets the primary and secondary admin API keys for the specified Azure Search service.
  ## https://aka.ms/search-manage
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the current subscription. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for each request. The current version is 2015-08-19.
  ##   subscriptionId: string (required)
  ##                 : The unique identifier for a Microsoft Azure subscription. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   searchServiceName: string (required)
  ##                    : The name of the Azure Search service associated with the specified resource group.
  var path_568328 = newJObject()
  var query_568329 = newJObject()
  add(path_568328, "resourceGroupName", newJString(resourceGroupName))
  add(query_568329, "api-version", newJString(apiVersion))
  add(path_568328, "subscriptionId", newJString(subscriptionId))
  add(path_568328, "searchServiceName", newJString(searchServiceName))
  result = call_568327.call(path_568328, query_568329, nil, nil, nil)

var adminKeysGet* = Call_AdminKeysGet_568318(name: "adminKeysGet",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Search/searchServices/{searchServiceName}/listAdminKeys",
    validator: validate_AdminKeysGet_568319, base: "", url: url_AdminKeysGet_568320,
    schemes: {Scheme.Https})
type
  Call_QueryKeysListBySearchService_568330 = ref object of OpenApiRestCall_567658
proc url_QueryKeysListBySearchService_568332(protocol: Scheme; host: string;
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

proc validate_QueryKeysListBySearchService_568331(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the list of query API keys for the given Azure Search service.
  ## 
  ## https://aka.ms/search-manage
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the current subscription. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   subscriptionId: JString (required)
  ##                 : The unique identifier for a Microsoft Azure subscription. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   searchServiceName: JString (required)
  ##                    : The name of the Azure Search service associated with the specified resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568333 = path.getOrDefault("resourceGroupName")
  valid_568333 = validateParameter(valid_568333, JString, required = true,
                                 default = nil)
  if valid_568333 != nil:
    section.add "resourceGroupName", valid_568333
  var valid_568334 = path.getOrDefault("subscriptionId")
  valid_568334 = validateParameter(valid_568334, JString, required = true,
                                 default = nil)
  if valid_568334 != nil:
    section.add "subscriptionId", valid_568334
  var valid_568335 = path.getOrDefault("searchServiceName")
  valid_568335 = validateParameter(valid_568335, JString, required = true,
                                 default = nil)
  if valid_568335 != nil:
    section.add "searchServiceName", valid_568335
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for each request. The current version is 2015-08-19.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568336 = query.getOrDefault("api-version")
  valid_568336 = validateParameter(valid_568336, JString, required = true,
                                 default = nil)
  if valid_568336 != nil:
    section.add "api-version", valid_568336
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-client-request-id: JString
  ##                         : A client-generated GUID value that identifies this request. If specified, this will be included in response information as a way to track the request.
  section = newJObject()
  var valid_568337 = header.getOrDefault("x-ms-client-request-id")
  valid_568337 = validateParameter(valid_568337, JString, required = false,
                                 default = nil)
  if valid_568337 != nil:
    section.add "x-ms-client-request-id", valid_568337
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568338: Call_QueryKeysListBySearchService_568330; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the list of query API keys for the given Azure Search service.
  ## 
  ## https://aka.ms/search-manage
  let valid = call_568338.validator(path, query, header, formData, body)
  let scheme = call_568338.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568338.url(scheme.get, call_568338.host, call_568338.base,
                         call_568338.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568338, url, valid)

proc call*(call_568339: Call_QueryKeysListBySearchService_568330;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          searchServiceName: string): Recallable =
  ## queryKeysListBySearchService
  ## Returns the list of query API keys for the given Azure Search service.
  ## https://aka.ms/search-manage
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the current subscription. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for each request. The current version is 2015-08-19.
  ##   subscriptionId: string (required)
  ##                 : The unique identifier for a Microsoft Azure subscription. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   searchServiceName: string (required)
  ##                    : The name of the Azure Search service associated with the specified resource group.
  var path_568340 = newJObject()
  var query_568341 = newJObject()
  add(path_568340, "resourceGroupName", newJString(resourceGroupName))
  add(query_568341, "api-version", newJString(apiVersion))
  add(path_568340, "subscriptionId", newJString(subscriptionId))
  add(path_568340, "searchServiceName", newJString(searchServiceName))
  result = call_568339.call(path_568340, query_568341, nil, nil, nil)

var queryKeysListBySearchService* = Call_QueryKeysListBySearchService_568330(
    name: "queryKeysListBySearchService", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Search/searchServices/{searchServiceName}/listQueryKeys",
    validator: validate_QueryKeysListBySearchService_568331, base: "",
    url: url_QueryKeysListBySearchService_568332, schemes: {Scheme.Https})
type
  Call_AdminKeysRegenerate_568342 = ref object of OpenApiRestCall_567658
proc url_AdminKeysRegenerate_568344(protocol: Scheme; host: string; base: string;
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

proc validate_AdminKeysRegenerate_568343(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Regenerates either the primary or secondary admin API key. You can only regenerate one key at a time.
  ## 
  ## https://aka.ms/search-manage
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the current subscription. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   keyKind: JString (required)
  ##          : Specifies which key to regenerate. Valid values include 'primary' and 'secondary'.
  ##   subscriptionId: JString (required)
  ##                 : The unique identifier for a Microsoft Azure subscription. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   searchServiceName: JString (required)
  ##                    : The name of the Azure Search service associated with the specified resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568345 = path.getOrDefault("resourceGroupName")
  valid_568345 = validateParameter(valid_568345, JString, required = true,
                                 default = nil)
  if valid_568345 != nil:
    section.add "resourceGroupName", valid_568345
  var valid_568359 = path.getOrDefault("keyKind")
  valid_568359 = validateParameter(valid_568359, JString, required = true,
                                 default = newJString("primary"))
  if valid_568359 != nil:
    section.add "keyKind", valid_568359
  var valid_568360 = path.getOrDefault("subscriptionId")
  valid_568360 = validateParameter(valid_568360, JString, required = true,
                                 default = nil)
  if valid_568360 != nil:
    section.add "subscriptionId", valid_568360
  var valid_568361 = path.getOrDefault("searchServiceName")
  valid_568361 = validateParameter(valid_568361, JString, required = true,
                                 default = nil)
  if valid_568361 != nil:
    section.add "searchServiceName", valid_568361
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for each request. The current version is 2015-08-19.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568362 = query.getOrDefault("api-version")
  valid_568362 = validateParameter(valid_568362, JString, required = true,
                                 default = nil)
  if valid_568362 != nil:
    section.add "api-version", valid_568362
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-client-request-id: JString
  ##                         : A client-generated GUID value that identifies this request. If specified, this will be included in response information as a way to track the request.
  section = newJObject()
  var valid_568363 = header.getOrDefault("x-ms-client-request-id")
  valid_568363 = validateParameter(valid_568363, JString, required = false,
                                 default = nil)
  if valid_568363 != nil:
    section.add "x-ms-client-request-id", valid_568363
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568364: Call_AdminKeysRegenerate_568342; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Regenerates either the primary or secondary admin API key. You can only regenerate one key at a time.
  ## 
  ## https://aka.ms/search-manage
  let valid = call_568364.validator(path, query, header, formData, body)
  let scheme = call_568364.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568364.url(scheme.get, call_568364.host, call_568364.base,
                         call_568364.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568364, url, valid)

proc call*(call_568365: Call_AdminKeysRegenerate_568342; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; searchServiceName: string;
          keyKind: string = "primary"): Recallable =
  ## adminKeysRegenerate
  ## Regenerates either the primary or secondary admin API key. You can only regenerate one key at a time.
  ## https://aka.ms/search-manage
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the current subscription. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for each request. The current version is 2015-08-19.
  ##   keyKind: string (required)
  ##          : Specifies which key to regenerate. Valid values include 'primary' and 'secondary'.
  ##   subscriptionId: string (required)
  ##                 : The unique identifier for a Microsoft Azure subscription. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   searchServiceName: string (required)
  ##                    : The name of the Azure Search service associated with the specified resource group.
  var path_568366 = newJObject()
  var query_568367 = newJObject()
  add(path_568366, "resourceGroupName", newJString(resourceGroupName))
  add(query_568367, "api-version", newJString(apiVersion))
  add(path_568366, "keyKind", newJString(keyKind))
  add(path_568366, "subscriptionId", newJString(subscriptionId))
  add(path_568366, "searchServiceName", newJString(searchServiceName))
  result = call_568365.call(path_568366, query_568367, nil, nil, nil)

var adminKeysRegenerate* = Call_AdminKeysRegenerate_568342(
    name: "adminKeysRegenerate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Search/searchServices/{searchServiceName}/regenerateAdminKey/{keyKind}",
    validator: validate_AdminKeysRegenerate_568343, base: "",
    url: url_AdminKeysRegenerate_568344, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
