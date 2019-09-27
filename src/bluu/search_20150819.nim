
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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
  macServiceName = "search"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_593647 = ref object of OpenApiRestCall_593425
proc url_OperationsList_593649(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_593648(path: JsonNode; query: JsonNode;
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
  var valid_593808 = query.getOrDefault("api-version")
  valid_593808 = validateParameter(valid_593808, JString, required = true,
                                 default = nil)
  if valid_593808 != nil:
    section.add "api-version", valid_593808
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593831: Call_OperationsList_593647; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available REST API operations of the Microsoft.Search provider.
  ## 
  let valid = call_593831.validator(path, query, header, formData, body)
  let scheme = call_593831.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593831.url(scheme.get, call_593831.host, call_593831.base,
                         call_593831.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593831, url, valid)

proc call*(call_593902: Call_OperationsList_593647; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available REST API operations of the Microsoft.Search provider.
  ##   apiVersion: string (required)
  ##             : The API version to use for each request. The current version is 2015-08-19.
  var query_593903 = newJObject()
  add(query_593903, "api-version", newJString(apiVersion))
  result = call_593902.call(nil, query_593903, nil, nil, nil)

var operationsList* = Call_OperationsList_593647(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Search/operations",
    validator: validate_OperationsList_593648, base: "", url: url_OperationsList_593649,
    schemes: {Scheme.Https})
type
  Call_ServicesCheckNameAvailability_593943 = ref object of OpenApiRestCall_593425
proc url_ServicesCheckNameAvailability_593945(protocol: Scheme; host: string;
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

proc validate_ServicesCheckNameAvailability_593944(path: JsonNode; query: JsonNode;
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
  var valid_593960 = path.getOrDefault("subscriptionId")
  valid_593960 = validateParameter(valid_593960, JString, required = true,
                                 default = nil)
  if valid_593960 != nil:
    section.add "subscriptionId", valid_593960
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for each request. The current version is 2015-08-19.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593961 = query.getOrDefault("api-version")
  valid_593961 = validateParameter(valid_593961, JString, required = true,
                                 default = nil)
  if valid_593961 != nil:
    section.add "api-version", valid_593961
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-client-request-id: JString
  ##                         : A client-generated GUID value that identifies this request. If specified, this will be included in response information as a way to track the request.
  section = newJObject()
  var valid_593962 = header.getOrDefault("x-ms-client-request-id")
  valid_593962 = validateParameter(valid_593962, JString, required = false,
                                 default = nil)
  if valid_593962 != nil:
    section.add "x-ms-client-request-id", valid_593962
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

proc call*(call_593964: Call_ServicesCheckNameAvailability_593943; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks whether or not the given Search service name is available for use. Search service names must be globally unique since they are part of the service URI (https://<name>.search.windows.net).
  ## 
  ## https://aka.ms/search-manage
  let valid = call_593964.validator(path, query, header, formData, body)
  let scheme = call_593964.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593964.url(scheme.get, call_593964.host, call_593964.base,
                         call_593964.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593964, url, valid)

proc call*(call_593965: Call_ServicesCheckNameAvailability_593943;
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
  var path_593966 = newJObject()
  var query_593967 = newJObject()
  var body_593968 = newJObject()
  add(query_593967, "api-version", newJString(apiVersion))
  add(path_593966, "subscriptionId", newJString(subscriptionId))
  if checkNameAvailabilityInput != nil:
    body_593968 = checkNameAvailabilityInput
  result = call_593965.call(path_593966, query_593967, nil, nil, body_593968)

var servicesCheckNameAvailability* = Call_ServicesCheckNameAvailability_593943(
    name: "servicesCheckNameAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Search/checkNameAvailability",
    validator: validate_ServicesCheckNameAvailability_593944, base: "",
    url: url_ServicesCheckNameAvailability_593945, schemes: {Scheme.Https})
type
  Call_ServicesListBySubscription_593969 = ref object of OpenApiRestCall_593425
proc url_ServicesListBySubscription_593971(protocol: Scheme; host: string;
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

proc validate_ServicesListBySubscription_593970(path: JsonNode; query: JsonNode;
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
  var valid_593972 = path.getOrDefault("subscriptionId")
  valid_593972 = validateParameter(valid_593972, JString, required = true,
                                 default = nil)
  if valid_593972 != nil:
    section.add "subscriptionId", valid_593972
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for each request. The current version is 2015-08-19.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593973 = query.getOrDefault("api-version")
  valid_593973 = validateParameter(valid_593973, JString, required = true,
                                 default = nil)
  if valid_593973 != nil:
    section.add "api-version", valid_593973
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-client-request-id: JString
  ##                         : A client-generated GUID value that identifies this request. If specified, this will be included in response information as a way to track the request.
  section = newJObject()
  var valid_593974 = header.getOrDefault("x-ms-client-request-id")
  valid_593974 = validateParameter(valid_593974, JString, required = false,
                                 default = nil)
  if valid_593974 != nil:
    section.add "x-ms-client-request-id", valid_593974
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593975: Call_ServicesListBySubscription_593969; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of all Search services in the given subscription.
  ## 
  ## https://aka.ms/search-manage
  let valid = call_593975.validator(path, query, header, formData, body)
  let scheme = call_593975.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593975.url(scheme.get, call_593975.host, call_593975.base,
                         call_593975.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593975, url, valid)

proc call*(call_593976: Call_ServicesListBySubscription_593969; apiVersion: string;
          subscriptionId: string): Recallable =
  ## servicesListBySubscription
  ## Gets a list of all Search services in the given subscription.
  ## https://aka.ms/search-manage
  ##   apiVersion: string (required)
  ##             : The API version to use for each request. The current version is 2015-08-19.
  ##   subscriptionId: string (required)
  ##                 : The unique identifier for a Microsoft Azure subscription. You can obtain this value from the Azure Resource Manager API or the portal.
  var path_593977 = newJObject()
  var query_593978 = newJObject()
  add(query_593978, "api-version", newJString(apiVersion))
  add(path_593977, "subscriptionId", newJString(subscriptionId))
  result = call_593976.call(path_593977, query_593978, nil, nil, nil)

var servicesListBySubscription* = Call_ServicesListBySubscription_593969(
    name: "servicesListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Search/searchServices",
    validator: validate_ServicesListBySubscription_593970, base: "",
    url: url_ServicesListBySubscription_593971, schemes: {Scheme.Https})
type
  Call_ServicesListByResourceGroup_593979 = ref object of OpenApiRestCall_593425
proc url_ServicesListByResourceGroup_593981(protocol: Scheme; host: string;
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

proc validate_ServicesListByResourceGroup_593980(path: JsonNode; query: JsonNode;
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
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for each request. The current version is 2015-08-19.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593984 = query.getOrDefault("api-version")
  valid_593984 = validateParameter(valid_593984, JString, required = true,
                                 default = nil)
  if valid_593984 != nil:
    section.add "api-version", valid_593984
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-client-request-id: JString
  ##                         : A client-generated GUID value that identifies this request. If specified, this will be included in response information as a way to track the request.
  section = newJObject()
  var valid_593985 = header.getOrDefault("x-ms-client-request-id")
  valid_593985 = validateParameter(valid_593985, JString, required = false,
                                 default = nil)
  if valid_593985 != nil:
    section.add "x-ms-client-request-id", valid_593985
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593986: Call_ServicesListByResourceGroup_593979; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of all Search services in the given resource group.
  ## 
  ## https://aka.ms/search-manage
  let valid = call_593986.validator(path, query, header, formData, body)
  let scheme = call_593986.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593986.url(scheme.get, call_593986.host, call_593986.base,
                         call_593986.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593986, url, valid)

proc call*(call_593987: Call_ServicesListByResourceGroup_593979;
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
  var path_593988 = newJObject()
  var query_593989 = newJObject()
  add(path_593988, "resourceGroupName", newJString(resourceGroupName))
  add(query_593989, "api-version", newJString(apiVersion))
  add(path_593988, "subscriptionId", newJString(subscriptionId))
  result = call_593987.call(path_593988, query_593989, nil, nil, nil)

var servicesListByResourceGroup* = Call_ServicesListByResourceGroup_593979(
    name: "servicesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Search/searchServices",
    validator: validate_ServicesListByResourceGroup_593980, base: "",
    url: url_ServicesListByResourceGroup_593981, schemes: {Scheme.Https})
type
  Call_ServicesCreateOrUpdate_594002 = ref object of OpenApiRestCall_593425
proc url_ServicesCreateOrUpdate_594004(protocol: Scheme; host: string; base: string;
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

proc validate_ServicesCreateOrUpdate_594003(path: JsonNode; query: JsonNode;
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
  var valid_594022 = path.getOrDefault("resourceGroupName")
  valid_594022 = validateParameter(valid_594022, JString, required = true,
                                 default = nil)
  if valid_594022 != nil:
    section.add "resourceGroupName", valid_594022
  var valid_594023 = path.getOrDefault("subscriptionId")
  valid_594023 = validateParameter(valid_594023, JString, required = true,
                                 default = nil)
  if valid_594023 != nil:
    section.add "subscriptionId", valid_594023
  var valid_594024 = path.getOrDefault("searchServiceName")
  valid_594024 = validateParameter(valid_594024, JString, required = true,
                                 default = nil)
  if valid_594024 != nil:
    section.add "searchServiceName", valid_594024
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for each request. The current version is 2015-08-19.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594025 = query.getOrDefault("api-version")
  valid_594025 = validateParameter(valid_594025, JString, required = true,
                                 default = nil)
  if valid_594025 != nil:
    section.add "api-version", valid_594025
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-client-request-id: JString
  ##                         : A client-generated GUID value that identifies this request. If specified, this will be included in response information as a way to track the request.
  section = newJObject()
  var valid_594026 = header.getOrDefault("x-ms-client-request-id")
  valid_594026 = validateParameter(valid_594026, JString, required = false,
                                 default = nil)
  if valid_594026 != nil:
    section.add "x-ms-client-request-id", valid_594026
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

proc call*(call_594028: Call_ServicesCreateOrUpdate_594002; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a Search service in the given resource group. If the Search service already exists, all properties will be updated with the given values.
  ## 
  ## https://aka.ms/search-manage
  let valid = call_594028.validator(path, query, header, formData, body)
  let scheme = call_594028.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594028.url(scheme.get, call_594028.host, call_594028.base,
                         call_594028.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594028, url, valid)

proc call*(call_594029: Call_ServicesCreateOrUpdate_594002;
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
  var path_594030 = newJObject()
  var query_594031 = newJObject()
  var body_594032 = newJObject()
  add(path_594030, "resourceGroupName", newJString(resourceGroupName))
  add(query_594031, "api-version", newJString(apiVersion))
  add(path_594030, "subscriptionId", newJString(subscriptionId))
  add(path_594030, "searchServiceName", newJString(searchServiceName))
  if service != nil:
    body_594032 = service
  result = call_594029.call(path_594030, query_594031, nil, nil, body_594032)

var servicesCreateOrUpdate* = Call_ServicesCreateOrUpdate_594002(
    name: "servicesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Search/searchServices/{searchServiceName}",
    validator: validate_ServicesCreateOrUpdate_594003, base: "",
    url: url_ServicesCreateOrUpdate_594004, schemes: {Scheme.Https})
type
  Call_ServicesGet_593990 = ref object of OpenApiRestCall_593425
proc url_ServicesGet_593992(protocol: Scheme; host: string; base: string;
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

proc validate_ServicesGet_593991(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_593993 = path.getOrDefault("resourceGroupName")
  valid_593993 = validateParameter(valid_593993, JString, required = true,
                                 default = nil)
  if valid_593993 != nil:
    section.add "resourceGroupName", valid_593993
  var valid_593994 = path.getOrDefault("subscriptionId")
  valid_593994 = validateParameter(valid_593994, JString, required = true,
                                 default = nil)
  if valid_593994 != nil:
    section.add "subscriptionId", valid_593994
  var valid_593995 = path.getOrDefault("searchServiceName")
  valid_593995 = validateParameter(valid_593995, JString, required = true,
                                 default = nil)
  if valid_593995 != nil:
    section.add "searchServiceName", valid_593995
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for each request. The current version is 2015-08-19.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593996 = query.getOrDefault("api-version")
  valid_593996 = validateParameter(valid_593996, JString, required = true,
                                 default = nil)
  if valid_593996 != nil:
    section.add "api-version", valid_593996
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-client-request-id: JString
  ##                         : A client-generated GUID value that identifies this request. If specified, this will be included in response information as a way to track the request.
  section = newJObject()
  var valid_593997 = header.getOrDefault("x-ms-client-request-id")
  valid_593997 = validateParameter(valid_593997, JString, required = false,
                                 default = nil)
  if valid_593997 != nil:
    section.add "x-ms-client-request-id", valid_593997
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593998: Call_ServicesGet_593990; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the Search service with the given name in the given resource group.
  ## 
  ## https://aka.ms/search-manage
  let valid = call_593998.validator(path, query, header, formData, body)
  let scheme = call_593998.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593998.url(scheme.get, call_593998.host, call_593998.base,
                         call_593998.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593998, url, valid)

proc call*(call_593999: Call_ServicesGet_593990; resourceGroupName: string;
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
  var path_594000 = newJObject()
  var query_594001 = newJObject()
  add(path_594000, "resourceGroupName", newJString(resourceGroupName))
  add(query_594001, "api-version", newJString(apiVersion))
  add(path_594000, "subscriptionId", newJString(subscriptionId))
  add(path_594000, "searchServiceName", newJString(searchServiceName))
  result = call_593999.call(path_594000, query_594001, nil, nil, nil)

var servicesGet* = Call_ServicesGet_593990(name: "servicesGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Search/searchServices/{searchServiceName}",
                                        validator: validate_ServicesGet_593991,
                                        base: "", url: url_ServicesGet_593992,
                                        schemes: {Scheme.Https})
type
  Call_ServicesUpdate_594045 = ref object of OpenApiRestCall_593425
proc url_ServicesUpdate_594047(protocol: Scheme; host: string; base: string;
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

proc validate_ServicesUpdate_594046(path: JsonNode; query: JsonNode;
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
  var valid_594048 = path.getOrDefault("resourceGroupName")
  valid_594048 = validateParameter(valid_594048, JString, required = true,
                                 default = nil)
  if valid_594048 != nil:
    section.add "resourceGroupName", valid_594048
  var valid_594049 = path.getOrDefault("subscriptionId")
  valid_594049 = validateParameter(valid_594049, JString, required = true,
                                 default = nil)
  if valid_594049 != nil:
    section.add "subscriptionId", valid_594049
  var valid_594050 = path.getOrDefault("searchServiceName")
  valid_594050 = validateParameter(valid_594050, JString, required = true,
                                 default = nil)
  if valid_594050 != nil:
    section.add "searchServiceName", valid_594050
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for each request. The current version is 2015-08-19.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594051 = query.getOrDefault("api-version")
  valid_594051 = validateParameter(valid_594051, JString, required = true,
                                 default = nil)
  if valid_594051 != nil:
    section.add "api-version", valid_594051
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-client-request-id: JString
  ##                         : A client-generated GUID value that identifies this request. If specified, this will be included in response information as a way to track the request.
  section = newJObject()
  var valid_594052 = header.getOrDefault("x-ms-client-request-id")
  valid_594052 = validateParameter(valid_594052, JString, required = false,
                                 default = nil)
  if valid_594052 != nil:
    section.add "x-ms-client-request-id", valid_594052
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

proc call*(call_594054: Call_ServicesUpdate_594045; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing Search service in the given resource group.
  ## 
  ## https://aka.ms/search-manage
  let valid = call_594054.validator(path, query, header, formData, body)
  let scheme = call_594054.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594054.url(scheme.get, call_594054.host, call_594054.base,
                         call_594054.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594054, url, valid)

proc call*(call_594055: Call_ServicesUpdate_594045; resourceGroupName: string;
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
  var path_594056 = newJObject()
  var query_594057 = newJObject()
  var body_594058 = newJObject()
  add(path_594056, "resourceGroupName", newJString(resourceGroupName))
  add(query_594057, "api-version", newJString(apiVersion))
  add(path_594056, "subscriptionId", newJString(subscriptionId))
  add(path_594056, "searchServiceName", newJString(searchServiceName))
  if service != nil:
    body_594058 = service
  result = call_594055.call(path_594056, query_594057, nil, nil, body_594058)

var servicesUpdate* = Call_ServicesUpdate_594045(name: "servicesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Search/searchServices/{searchServiceName}",
    validator: validate_ServicesUpdate_594046, base: "", url: url_ServicesUpdate_594047,
    schemes: {Scheme.Https})
type
  Call_ServicesDelete_594033 = ref object of OpenApiRestCall_593425
proc url_ServicesDelete_594035(protocol: Scheme; host: string; base: string;
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

proc validate_ServicesDelete_594034(path: JsonNode; query: JsonNode;
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
  var valid_594036 = path.getOrDefault("resourceGroupName")
  valid_594036 = validateParameter(valid_594036, JString, required = true,
                                 default = nil)
  if valid_594036 != nil:
    section.add "resourceGroupName", valid_594036
  var valid_594037 = path.getOrDefault("subscriptionId")
  valid_594037 = validateParameter(valid_594037, JString, required = true,
                                 default = nil)
  if valid_594037 != nil:
    section.add "subscriptionId", valid_594037
  var valid_594038 = path.getOrDefault("searchServiceName")
  valid_594038 = validateParameter(valid_594038, JString, required = true,
                                 default = nil)
  if valid_594038 != nil:
    section.add "searchServiceName", valid_594038
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for each request. The current version is 2015-08-19.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594039 = query.getOrDefault("api-version")
  valid_594039 = validateParameter(valid_594039, JString, required = true,
                                 default = nil)
  if valid_594039 != nil:
    section.add "api-version", valid_594039
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-client-request-id: JString
  ##                         : A client-generated GUID value that identifies this request. If specified, this will be included in response information as a way to track the request.
  section = newJObject()
  var valid_594040 = header.getOrDefault("x-ms-client-request-id")
  valid_594040 = validateParameter(valid_594040, JString, required = false,
                                 default = nil)
  if valid_594040 != nil:
    section.add "x-ms-client-request-id", valid_594040
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594041: Call_ServicesDelete_594033; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a Search service in the given resource group, along with its associated resources.
  ## 
  ## https://aka.ms/search-manage
  let valid = call_594041.validator(path, query, header, formData, body)
  let scheme = call_594041.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594041.url(scheme.get, call_594041.host, call_594041.base,
                         call_594041.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594041, url, valid)

proc call*(call_594042: Call_ServicesDelete_594033; resourceGroupName: string;
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
  var path_594043 = newJObject()
  var query_594044 = newJObject()
  add(path_594043, "resourceGroupName", newJString(resourceGroupName))
  add(query_594044, "api-version", newJString(apiVersion))
  add(path_594043, "subscriptionId", newJString(subscriptionId))
  add(path_594043, "searchServiceName", newJString(searchServiceName))
  result = call_594042.call(path_594043, query_594044, nil, nil, nil)

var servicesDelete* = Call_ServicesDelete_594033(name: "servicesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Search/searchServices/{searchServiceName}",
    validator: validate_ServicesDelete_594034, base: "", url: url_ServicesDelete_594035,
    schemes: {Scheme.Https})
type
  Call_QueryKeysCreate_594059 = ref object of OpenApiRestCall_593425
proc url_QueryKeysCreate_594061(protocol: Scheme; host: string; base: string;
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

proc validate_QueryKeysCreate_594060(path: JsonNode; query: JsonNode;
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
  var valid_594062 = path.getOrDefault("resourceGroupName")
  valid_594062 = validateParameter(valid_594062, JString, required = true,
                                 default = nil)
  if valid_594062 != nil:
    section.add "resourceGroupName", valid_594062
  var valid_594063 = path.getOrDefault("name")
  valid_594063 = validateParameter(valid_594063, JString, required = true,
                                 default = nil)
  if valid_594063 != nil:
    section.add "name", valid_594063
  var valid_594064 = path.getOrDefault("subscriptionId")
  valid_594064 = validateParameter(valid_594064, JString, required = true,
                                 default = nil)
  if valid_594064 != nil:
    section.add "subscriptionId", valid_594064
  var valid_594065 = path.getOrDefault("searchServiceName")
  valid_594065 = validateParameter(valid_594065, JString, required = true,
                                 default = nil)
  if valid_594065 != nil:
    section.add "searchServiceName", valid_594065
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for each request. The current version is 2015-08-19.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594066 = query.getOrDefault("api-version")
  valid_594066 = validateParameter(valid_594066, JString, required = true,
                                 default = nil)
  if valid_594066 != nil:
    section.add "api-version", valid_594066
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-client-request-id: JString
  ##                         : A client-generated GUID value that identifies this request. If specified, this will be included in response information as a way to track the request.
  section = newJObject()
  var valid_594067 = header.getOrDefault("x-ms-client-request-id")
  valid_594067 = validateParameter(valid_594067, JString, required = false,
                                 default = nil)
  if valid_594067 != nil:
    section.add "x-ms-client-request-id", valid_594067
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594068: Call_QueryKeysCreate_594059; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Generates a new query key for the specified Search service. You can create up to 50 query keys per service.
  ## 
  ## https://aka.ms/search-manage
  let valid = call_594068.validator(path, query, header, formData, body)
  let scheme = call_594068.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594068.url(scheme.get, call_594068.host, call_594068.base,
                         call_594068.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594068, url, valid)

proc call*(call_594069: Call_QueryKeysCreate_594059; resourceGroupName: string;
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
  var path_594070 = newJObject()
  var query_594071 = newJObject()
  add(path_594070, "resourceGroupName", newJString(resourceGroupName))
  add(query_594071, "api-version", newJString(apiVersion))
  add(path_594070, "name", newJString(name))
  add(path_594070, "subscriptionId", newJString(subscriptionId))
  add(path_594070, "searchServiceName", newJString(searchServiceName))
  result = call_594069.call(path_594070, query_594071, nil, nil, nil)

var queryKeysCreate* = Call_QueryKeysCreate_594059(name: "queryKeysCreate",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Search/searchServices/{searchServiceName}/createQueryKey/{name}",
    validator: validate_QueryKeysCreate_594060, base: "", url: url_QueryKeysCreate_594061,
    schemes: {Scheme.Https})
type
  Call_QueryKeysDelete_594072 = ref object of OpenApiRestCall_593425
proc url_QueryKeysDelete_594074(protocol: Scheme; host: string; base: string;
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

proc validate_QueryKeysDelete_594073(path: JsonNode; query: JsonNode;
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
  var valid_594075 = path.getOrDefault("resourceGroupName")
  valid_594075 = validateParameter(valid_594075, JString, required = true,
                                 default = nil)
  if valid_594075 != nil:
    section.add "resourceGroupName", valid_594075
  var valid_594076 = path.getOrDefault("subscriptionId")
  valid_594076 = validateParameter(valid_594076, JString, required = true,
                                 default = nil)
  if valid_594076 != nil:
    section.add "subscriptionId", valid_594076
  var valid_594077 = path.getOrDefault("searchServiceName")
  valid_594077 = validateParameter(valid_594077, JString, required = true,
                                 default = nil)
  if valid_594077 != nil:
    section.add "searchServiceName", valid_594077
  var valid_594078 = path.getOrDefault("key")
  valid_594078 = validateParameter(valid_594078, JString, required = true,
                                 default = nil)
  if valid_594078 != nil:
    section.add "key", valid_594078
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for each request. The current version is 2015-08-19.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594079 = query.getOrDefault("api-version")
  valid_594079 = validateParameter(valid_594079, JString, required = true,
                                 default = nil)
  if valid_594079 != nil:
    section.add "api-version", valid_594079
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-client-request-id: JString
  ##                         : A client-generated GUID value that identifies this request. If specified, this will be included in response information as a way to track the request.
  section = newJObject()
  var valid_594080 = header.getOrDefault("x-ms-client-request-id")
  valid_594080 = validateParameter(valid_594080, JString, required = false,
                                 default = nil)
  if valid_594080 != nil:
    section.add "x-ms-client-request-id", valid_594080
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594081: Call_QueryKeysDelete_594072; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified query key. Unlike admin keys, query keys are not regenerated. The process for regenerating a query key is to delete and then recreate it.
  ## 
  ## https://aka.ms/search-manage
  let valid = call_594081.validator(path, query, header, formData, body)
  let scheme = call_594081.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594081.url(scheme.get, call_594081.host, call_594081.base,
                         call_594081.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594081, url, valid)

proc call*(call_594082: Call_QueryKeysDelete_594072; resourceGroupName: string;
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
  var path_594083 = newJObject()
  var query_594084 = newJObject()
  add(path_594083, "resourceGroupName", newJString(resourceGroupName))
  add(query_594084, "api-version", newJString(apiVersion))
  add(path_594083, "subscriptionId", newJString(subscriptionId))
  add(path_594083, "searchServiceName", newJString(searchServiceName))
  add(path_594083, "key", newJString(key))
  result = call_594082.call(path_594083, query_594084, nil, nil, nil)

var queryKeysDelete* = Call_QueryKeysDelete_594072(name: "queryKeysDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Search/searchServices/{searchServiceName}/deleteQueryKey/{key}",
    validator: validate_QueryKeysDelete_594073, base: "", url: url_QueryKeysDelete_594074,
    schemes: {Scheme.Https})
type
  Call_AdminKeysGet_594085 = ref object of OpenApiRestCall_593425
proc url_AdminKeysGet_594087(protocol: Scheme; host: string; base: string;
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

proc validate_AdminKeysGet_594086(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594088 = path.getOrDefault("resourceGroupName")
  valid_594088 = validateParameter(valid_594088, JString, required = true,
                                 default = nil)
  if valid_594088 != nil:
    section.add "resourceGroupName", valid_594088
  var valid_594089 = path.getOrDefault("subscriptionId")
  valid_594089 = validateParameter(valid_594089, JString, required = true,
                                 default = nil)
  if valid_594089 != nil:
    section.add "subscriptionId", valid_594089
  var valid_594090 = path.getOrDefault("searchServiceName")
  valid_594090 = validateParameter(valid_594090, JString, required = true,
                                 default = nil)
  if valid_594090 != nil:
    section.add "searchServiceName", valid_594090
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for each request. The current version is 2015-08-19.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594091 = query.getOrDefault("api-version")
  valid_594091 = validateParameter(valid_594091, JString, required = true,
                                 default = nil)
  if valid_594091 != nil:
    section.add "api-version", valid_594091
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-client-request-id: JString
  ##                         : A client-generated GUID value that identifies this request. If specified, this will be included in response information as a way to track the request.
  section = newJObject()
  var valid_594092 = header.getOrDefault("x-ms-client-request-id")
  valid_594092 = validateParameter(valid_594092, JString, required = false,
                                 default = nil)
  if valid_594092 != nil:
    section.add "x-ms-client-request-id", valid_594092
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594093: Call_AdminKeysGet_594085; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the primary and secondary admin API keys for the specified Azure Search service.
  ## 
  ## https://aka.ms/search-manage
  let valid = call_594093.validator(path, query, header, formData, body)
  let scheme = call_594093.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594093.url(scheme.get, call_594093.host, call_594093.base,
                         call_594093.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594093, url, valid)

proc call*(call_594094: Call_AdminKeysGet_594085; resourceGroupName: string;
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
  var path_594095 = newJObject()
  var query_594096 = newJObject()
  add(path_594095, "resourceGroupName", newJString(resourceGroupName))
  add(query_594096, "api-version", newJString(apiVersion))
  add(path_594095, "subscriptionId", newJString(subscriptionId))
  add(path_594095, "searchServiceName", newJString(searchServiceName))
  result = call_594094.call(path_594095, query_594096, nil, nil, nil)

var adminKeysGet* = Call_AdminKeysGet_594085(name: "adminKeysGet",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Search/searchServices/{searchServiceName}/listAdminKeys",
    validator: validate_AdminKeysGet_594086, base: "", url: url_AdminKeysGet_594087,
    schemes: {Scheme.Https})
type
  Call_QueryKeysListBySearchService_594097 = ref object of OpenApiRestCall_593425
proc url_QueryKeysListBySearchService_594099(protocol: Scheme; host: string;
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

proc validate_QueryKeysListBySearchService_594098(path: JsonNode; query: JsonNode;
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
  var valid_594100 = path.getOrDefault("resourceGroupName")
  valid_594100 = validateParameter(valid_594100, JString, required = true,
                                 default = nil)
  if valid_594100 != nil:
    section.add "resourceGroupName", valid_594100
  var valid_594101 = path.getOrDefault("subscriptionId")
  valid_594101 = validateParameter(valid_594101, JString, required = true,
                                 default = nil)
  if valid_594101 != nil:
    section.add "subscriptionId", valid_594101
  var valid_594102 = path.getOrDefault("searchServiceName")
  valid_594102 = validateParameter(valid_594102, JString, required = true,
                                 default = nil)
  if valid_594102 != nil:
    section.add "searchServiceName", valid_594102
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for each request. The current version is 2015-08-19.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594103 = query.getOrDefault("api-version")
  valid_594103 = validateParameter(valid_594103, JString, required = true,
                                 default = nil)
  if valid_594103 != nil:
    section.add "api-version", valid_594103
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-client-request-id: JString
  ##                         : A client-generated GUID value that identifies this request. If specified, this will be included in response information as a way to track the request.
  section = newJObject()
  var valid_594104 = header.getOrDefault("x-ms-client-request-id")
  valid_594104 = validateParameter(valid_594104, JString, required = false,
                                 default = nil)
  if valid_594104 != nil:
    section.add "x-ms-client-request-id", valid_594104
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594105: Call_QueryKeysListBySearchService_594097; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the list of query API keys for the given Azure Search service.
  ## 
  ## https://aka.ms/search-manage
  let valid = call_594105.validator(path, query, header, formData, body)
  let scheme = call_594105.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594105.url(scheme.get, call_594105.host, call_594105.base,
                         call_594105.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594105, url, valid)

proc call*(call_594106: Call_QueryKeysListBySearchService_594097;
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
  var path_594107 = newJObject()
  var query_594108 = newJObject()
  add(path_594107, "resourceGroupName", newJString(resourceGroupName))
  add(query_594108, "api-version", newJString(apiVersion))
  add(path_594107, "subscriptionId", newJString(subscriptionId))
  add(path_594107, "searchServiceName", newJString(searchServiceName))
  result = call_594106.call(path_594107, query_594108, nil, nil, nil)

var queryKeysListBySearchService* = Call_QueryKeysListBySearchService_594097(
    name: "queryKeysListBySearchService", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Search/searchServices/{searchServiceName}/listQueryKeys",
    validator: validate_QueryKeysListBySearchService_594098, base: "",
    url: url_QueryKeysListBySearchService_594099, schemes: {Scheme.Https})
type
  Call_AdminKeysRegenerate_594109 = ref object of OpenApiRestCall_593425
proc url_AdminKeysRegenerate_594111(protocol: Scheme; host: string; base: string;
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

proc validate_AdminKeysRegenerate_594110(path: JsonNode; query: JsonNode;
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
  var valid_594112 = path.getOrDefault("resourceGroupName")
  valid_594112 = validateParameter(valid_594112, JString, required = true,
                                 default = nil)
  if valid_594112 != nil:
    section.add "resourceGroupName", valid_594112
  var valid_594126 = path.getOrDefault("keyKind")
  valid_594126 = validateParameter(valid_594126, JString, required = true,
                                 default = newJString("primary"))
  if valid_594126 != nil:
    section.add "keyKind", valid_594126
  var valid_594127 = path.getOrDefault("subscriptionId")
  valid_594127 = validateParameter(valid_594127, JString, required = true,
                                 default = nil)
  if valid_594127 != nil:
    section.add "subscriptionId", valid_594127
  var valid_594128 = path.getOrDefault("searchServiceName")
  valid_594128 = validateParameter(valid_594128, JString, required = true,
                                 default = nil)
  if valid_594128 != nil:
    section.add "searchServiceName", valid_594128
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for each request. The current version is 2015-08-19.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594129 = query.getOrDefault("api-version")
  valid_594129 = validateParameter(valid_594129, JString, required = true,
                                 default = nil)
  if valid_594129 != nil:
    section.add "api-version", valid_594129
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-client-request-id: JString
  ##                         : A client-generated GUID value that identifies this request. If specified, this will be included in response information as a way to track the request.
  section = newJObject()
  var valid_594130 = header.getOrDefault("x-ms-client-request-id")
  valid_594130 = validateParameter(valid_594130, JString, required = false,
                                 default = nil)
  if valid_594130 != nil:
    section.add "x-ms-client-request-id", valid_594130
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594131: Call_AdminKeysRegenerate_594109; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Regenerates either the primary or secondary admin API key. You can only regenerate one key at a time.
  ## 
  ## https://aka.ms/search-manage
  let valid = call_594131.validator(path, query, header, formData, body)
  let scheme = call_594131.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594131.url(scheme.get, call_594131.host, call_594131.base,
                         call_594131.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594131, url, valid)

proc call*(call_594132: Call_AdminKeysRegenerate_594109; resourceGroupName: string;
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
  var path_594133 = newJObject()
  var query_594134 = newJObject()
  add(path_594133, "resourceGroupName", newJString(resourceGroupName))
  add(query_594134, "api-version", newJString(apiVersion))
  add(path_594133, "keyKind", newJString(keyKind))
  add(path_594133, "subscriptionId", newJString(subscriptionId))
  add(path_594133, "searchServiceName", newJString(searchServiceName))
  result = call_594132.call(path_594133, query_594134, nil, nil, nil)

var adminKeysRegenerate* = Call_AdminKeysRegenerate_594109(
    name: "adminKeysRegenerate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Search/searchServices/{searchServiceName}/regenerateAdminKey/{keyKind}",
    validator: validate_AdminKeysRegenerate_594110, base: "",
    url: url_AdminKeysRegenerate_594111, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
