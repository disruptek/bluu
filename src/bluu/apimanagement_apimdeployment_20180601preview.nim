
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: ApiManagementClient
## version: 2018-06-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## Use these REST APIs to manage Azure API Management deployment.
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
  macServiceName = "apimanagement-apimdeployment"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ApiManagementOperationsList_593647 = ref object of OpenApiRestCall_593425
proc url_ApiManagementOperationsList_593649(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ApiManagementOperationsList_593648(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all of the available REST API operations of the Microsoft.ApiManagement provider.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593795 = query.getOrDefault("api-version")
  valid_593795 = validateParameter(valid_593795, JString, required = true,
                                 default = nil)
  if valid_593795 != nil:
    section.add "api-version", valid_593795
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593822: Call_ApiManagementOperationsList_593647; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available REST API operations of the Microsoft.ApiManagement provider.
  ## 
  let valid = call_593822.validator(path, query, header, formData, body)
  let scheme = call_593822.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593822.url(scheme.get, call_593822.host, call_593822.base,
                         call_593822.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593822, url, valid)

proc call*(call_593893: Call_ApiManagementOperationsList_593647; apiVersion: string): Recallable =
  ## apiManagementOperationsList
  ## Lists all of the available REST API operations of the Microsoft.ApiManagement provider.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  var query_593894 = newJObject()
  add(query_593894, "api-version", newJString(apiVersion))
  result = call_593893.call(nil, query_593894, nil, nil, nil)

var apiManagementOperationsList* = Call_ApiManagementOperationsList_593647(
    name: "apiManagementOperationsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/Microsoft.ApiManagement/operations",
    validator: validate_ApiManagementOperationsList_593648, base: "",
    url: url_ApiManagementOperationsList_593649, schemes: {Scheme.Https})
type
  Call_ApiManagementServiceCheckNameAvailability_593934 = ref object of OpenApiRestCall_593425
proc url_ApiManagementServiceCheckNameAvailability_593936(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/checkNameAvailability")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiManagementServiceCheckNameAvailability_593935(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks availability and correctness of a name for an API Management service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_593977 = path.getOrDefault("subscriptionId")
  valid_593977 = validateParameter(valid_593977, JString, required = true,
                                 default = nil)
  if valid_593977 != nil:
    section.add "subscriptionId", valid_593977
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593978 = query.getOrDefault("api-version")
  valid_593978 = validateParameter(valid_593978, JString, required = true,
                                 default = nil)
  if valid_593978 != nil:
    section.add "api-version", valid_593978
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CheckNameAvailability operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_593980: Call_ApiManagementServiceCheckNameAvailability_593934;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Checks availability and correctness of a name for an API Management service.
  ## 
  let valid = call_593980.validator(path, query, header, formData, body)
  let scheme = call_593980.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593980.url(scheme.get, call_593980.host, call_593980.base,
                         call_593980.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593980, url, valid)

proc call*(call_593981: Call_ApiManagementServiceCheckNameAvailability_593934;
          apiVersion: string; subscriptionId: string; parameters: JsonNode): Recallable =
  ## apiManagementServiceCheckNameAvailability
  ## Checks availability and correctness of a name for an API Management service.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CheckNameAvailability operation.
  var path_593982 = newJObject()
  var query_593983 = newJObject()
  var body_593984 = newJObject()
  add(query_593983, "api-version", newJString(apiVersion))
  add(path_593982, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_593984 = parameters
  result = call_593981.call(path_593982, query_593983, nil, nil, body_593984)

var apiManagementServiceCheckNameAvailability* = Call_ApiManagementServiceCheckNameAvailability_593934(
    name: "apiManagementServiceCheckNameAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.ApiManagement/checkNameAvailability",
    validator: validate_ApiManagementServiceCheckNameAvailability_593935,
    base: "", url: url_ApiManagementServiceCheckNameAvailability_593936,
    schemes: {Scheme.Https})
type
  Call_ApiManagementServiceList_593985 = ref object of OpenApiRestCall_593425
proc url_ApiManagementServiceList_593987(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.ApiManagement/service")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiManagementServiceList_593986(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all API Management services within an Azure subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_593988 = path.getOrDefault("subscriptionId")
  valid_593988 = validateParameter(valid_593988, JString, required = true,
                                 default = nil)
  if valid_593988 != nil:
    section.add "subscriptionId", valid_593988
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593989 = query.getOrDefault("api-version")
  valid_593989 = validateParameter(valid_593989, JString, required = true,
                                 default = nil)
  if valid_593989 != nil:
    section.add "api-version", valid_593989
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593990: Call_ApiManagementServiceList_593985; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all API Management services within an Azure subscription.
  ## 
  let valid = call_593990.validator(path, query, header, formData, body)
  let scheme = call_593990.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593990.url(scheme.get, call_593990.host, call_593990.base,
                         call_593990.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593990, url, valid)

proc call*(call_593991: Call_ApiManagementServiceList_593985; apiVersion: string;
          subscriptionId: string): Recallable =
  ## apiManagementServiceList
  ## Lists all API Management services within an Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_593992 = newJObject()
  var query_593993 = newJObject()
  add(query_593993, "api-version", newJString(apiVersion))
  add(path_593992, "subscriptionId", newJString(subscriptionId))
  result = call_593991.call(path_593992, query_593993, nil, nil, nil)

var apiManagementServiceList* = Call_ApiManagementServiceList_593985(
    name: "apiManagementServiceList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.ApiManagement/service",
    validator: validate_ApiManagementServiceList_593986, base: "",
    url: url_ApiManagementServiceList_593987, schemes: {Scheme.Https})
type
  Call_ApiManagementServiceListByResourceGroup_593994 = ref object of OpenApiRestCall_593425
proc url_ApiManagementServiceListByResourceGroup_593996(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
        kind: ConstantSegment, value: "/providers/Microsoft.ApiManagement/service")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiManagementServiceListByResourceGroup_593995(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all API Management services within a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593997 = path.getOrDefault("resourceGroupName")
  valid_593997 = validateParameter(valid_593997, JString, required = true,
                                 default = nil)
  if valid_593997 != nil:
    section.add "resourceGroupName", valid_593997
  var valid_593998 = path.getOrDefault("subscriptionId")
  valid_593998 = validateParameter(valid_593998, JString, required = true,
                                 default = nil)
  if valid_593998 != nil:
    section.add "subscriptionId", valid_593998
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593999 = query.getOrDefault("api-version")
  valid_593999 = validateParameter(valid_593999, JString, required = true,
                                 default = nil)
  if valid_593999 != nil:
    section.add "api-version", valid_593999
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594000: Call_ApiManagementServiceListByResourceGroup_593994;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all API Management services within a resource group.
  ## 
  let valid = call_594000.validator(path, query, header, formData, body)
  let scheme = call_594000.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594000.url(scheme.get, call_594000.host, call_594000.base,
                         call_594000.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594000, url, valid)

proc call*(call_594001: Call_ApiManagementServiceListByResourceGroup_593994;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## apiManagementServiceListByResourceGroup
  ## List all API Management services within a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594002 = newJObject()
  var query_594003 = newJObject()
  add(path_594002, "resourceGroupName", newJString(resourceGroupName))
  add(query_594003, "api-version", newJString(apiVersion))
  add(path_594002, "subscriptionId", newJString(subscriptionId))
  result = call_594001.call(path_594002, query_594003, nil, nil, nil)

var apiManagementServiceListByResourceGroup* = Call_ApiManagementServiceListByResourceGroup_593994(
    name: "apiManagementServiceListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service",
    validator: validate_ApiManagementServiceListByResourceGroup_593995, base: "",
    url: url_ApiManagementServiceListByResourceGroup_593996,
    schemes: {Scheme.Https})
type
  Call_ApiManagementServiceCreateOrUpdate_594015 = ref object of OpenApiRestCall_593425
proc url_ApiManagementServiceCreateOrUpdate_594017(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiManagementServiceCreateOrUpdate_594016(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates an API Management service. This is long running operation and could take several minutes to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594018 = path.getOrDefault("resourceGroupName")
  valid_594018 = validateParameter(valid_594018, JString, required = true,
                                 default = nil)
  if valid_594018 != nil:
    section.add "resourceGroupName", valid_594018
  var valid_594019 = path.getOrDefault("subscriptionId")
  valid_594019 = validateParameter(valid_594019, JString, required = true,
                                 default = nil)
  if valid_594019 != nil:
    section.add "subscriptionId", valid_594019
  var valid_594020 = path.getOrDefault("serviceName")
  valid_594020 = validateParameter(valid_594020, JString, required = true,
                                 default = nil)
  if valid_594020 != nil:
    section.add "serviceName", valid_594020
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594021 = query.getOrDefault("api-version")
  valid_594021 = validateParameter(valid_594021, JString, required = true,
                                 default = nil)
  if valid_594021 != nil:
    section.add "api-version", valid_594021
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate API Management service operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594023: Call_ApiManagementServiceCreateOrUpdate_594015;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates an API Management service. This is long running operation and could take several minutes to complete.
  ## 
  let valid = call_594023.validator(path, query, header, formData, body)
  let scheme = call_594023.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594023.url(scheme.get, call_594023.host, call_594023.base,
                         call_594023.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594023, url, valid)

proc call*(call_594024: Call_ApiManagementServiceCreateOrUpdate_594015;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; serviceName: string): Recallable =
  ## apiManagementServiceCreateOrUpdate
  ## Creates or updates an API Management service. This is long running operation and could take several minutes to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate API Management service operation.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594025 = newJObject()
  var query_594026 = newJObject()
  var body_594027 = newJObject()
  add(path_594025, "resourceGroupName", newJString(resourceGroupName))
  add(query_594026, "api-version", newJString(apiVersion))
  add(path_594025, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594027 = parameters
  add(path_594025, "serviceName", newJString(serviceName))
  result = call_594024.call(path_594025, query_594026, nil, nil, body_594027)

var apiManagementServiceCreateOrUpdate* = Call_ApiManagementServiceCreateOrUpdate_594015(
    name: "apiManagementServiceCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}",
    validator: validate_ApiManagementServiceCreateOrUpdate_594016, base: "",
    url: url_ApiManagementServiceCreateOrUpdate_594017, schemes: {Scheme.Https})
type
  Call_ApiManagementServiceGet_594004 = ref object of OpenApiRestCall_593425
proc url_ApiManagementServiceGet_594006(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiManagementServiceGet_594005(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an API Management service resource description.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594007 = path.getOrDefault("resourceGroupName")
  valid_594007 = validateParameter(valid_594007, JString, required = true,
                                 default = nil)
  if valid_594007 != nil:
    section.add "resourceGroupName", valid_594007
  var valid_594008 = path.getOrDefault("subscriptionId")
  valid_594008 = validateParameter(valid_594008, JString, required = true,
                                 default = nil)
  if valid_594008 != nil:
    section.add "subscriptionId", valid_594008
  var valid_594009 = path.getOrDefault("serviceName")
  valid_594009 = validateParameter(valid_594009, JString, required = true,
                                 default = nil)
  if valid_594009 != nil:
    section.add "serviceName", valid_594009
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594010 = query.getOrDefault("api-version")
  valid_594010 = validateParameter(valid_594010, JString, required = true,
                                 default = nil)
  if valid_594010 != nil:
    section.add "api-version", valid_594010
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594011: Call_ApiManagementServiceGet_594004; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an API Management service resource description.
  ## 
  let valid = call_594011.validator(path, query, header, formData, body)
  let scheme = call_594011.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594011.url(scheme.get, call_594011.host, call_594011.base,
                         call_594011.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594011, url, valid)

proc call*(call_594012: Call_ApiManagementServiceGet_594004;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          serviceName: string): Recallable =
  ## apiManagementServiceGet
  ## Gets an API Management service resource description.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594013 = newJObject()
  var query_594014 = newJObject()
  add(path_594013, "resourceGroupName", newJString(resourceGroupName))
  add(query_594014, "api-version", newJString(apiVersion))
  add(path_594013, "subscriptionId", newJString(subscriptionId))
  add(path_594013, "serviceName", newJString(serviceName))
  result = call_594012.call(path_594013, query_594014, nil, nil, nil)

var apiManagementServiceGet* = Call_ApiManagementServiceGet_594004(
    name: "apiManagementServiceGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}",
    validator: validate_ApiManagementServiceGet_594005, base: "",
    url: url_ApiManagementServiceGet_594006, schemes: {Scheme.Https})
type
  Call_ApiManagementServiceUpdate_594039 = ref object of OpenApiRestCall_593425
proc url_ApiManagementServiceUpdate_594041(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiManagementServiceUpdate_594040(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing API Management service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594042 = path.getOrDefault("resourceGroupName")
  valid_594042 = validateParameter(valid_594042, JString, required = true,
                                 default = nil)
  if valid_594042 != nil:
    section.add "resourceGroupName", valid_594042
  var valid_594043 = path.getOrDefault("subscriptionId")
  valid_594043 = validateParameter(valid_594043, JString, required = true,
                                 default = nil)
  if valid_594043 != nil:
    section.add "subscriptionId", valid_594043
  var valid_594044 = path.getOrDefault("serviceName")
  valid_594044 = validateParameter(valid_594044, JString, required = true,
                                 default = nil)
  if valid_594044 != nil:
    section.add "serviceName", valid_594044
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594045 = query.getOrDefault("api-version")
  valid_594045 = validateParameter(valid_594045, JString, required = true,
                                 default = nil)
  if valid_594045 != nil:
    section.add "api-version", valid_594045
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate API Management service operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594047: Call_ApiManagementServiceUpdate_594039; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing API Management service.
  ## 
  let valid = call_594047.validator(path, query, header, formData, body)
  let scheme = call_594047.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594047.url(scheme.get, call_594047.host, call_594047.base,
                         call_594047.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594047, url, valid)

proc call*(call_594048: Call_ApiManagementServiceUpdate_594039;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; serviceName: string): Recallable =
  ## apiManagementServiceUpdate
  ## Updates an existing API Management service.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the CreateOrUpdate API Management service operation.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594049 = newJObject()
  var query_594050 = newJObject()
  var body_594051 = newJObject()
  add(path_594049, "resourceGroupName", newJString(resourceGroupName))
  add(query_594050, "api-version", newJString(apiVersion))
  add(path_594049, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594051 = parameters
  add(path_594049, "serviceName", newJString(serviceName))
  result = call_594048.call(path_594049, query_594050, nil, nil, body_594051)

var apiManagementServiceUpdate* = Call_ApiManagementServiceUpdate_594039(
    name: "apiManagementServiceUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}",
    validator: validate_ApiManagementServiceUpdate_594040, base: "",
    url: url_ApiManagementServiceUpdate_594041, schemes: {Scheme.Https})
type
  Call_ApiManagementServiceDelete_594028 = ref object of OpenApiRestCall_593425
proc url_ApiManagementServiceDelete_594030(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiManagementServiceDelete_594029(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an existing API Management service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594031 = path.getOrDefault("resourceGroupName")
  valid_594031 = validateParameter(valid_594031, JString, required = true,
                                 default = nil)
  if valid_594031 != nil:
    section.add "resourceGroupName", valid_594031
  var valid_594032 = path.getOrDefault("subscriptionId")
  valid_594032 = validateParameter(valid_594032, JString, required = true,
                                 default = nil)
  if valid_594032 != nil:
    section.add "subscriptionId", valid_594032
  var valid_594033 = path.getOrDefault("serviceName")
  valid_594033 = validateParameter(valid_594033, JString, required = true,
                                 default = nil)
  if valid_594033 != nil:
    section.add "serviceName", valid_594033
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594034 = query.getOrDefault("api-version")
  valid_594034 = validateParameter(valid_594034, JString, required = true,
                                 default = nil)
  if valid_594034 != nil:
    section.add "api-version", valid_594034
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594035: Call_ApiManagementServiceDelete_594028; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an existing API Management service.
  ## 
  let valid = call_594035.validator(path, query, header, formData, body)
  let scheme = call_594035.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594035.url(scheme.get, call_594035.host, call_594035.base,
                         call_594035.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594035, url, valid)

proc call*(call_594036: Call_ApiManagementServiceDelete_594028;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          serviceName: string): Recallable =
  ## apiManagementServiceDelete
  ## Deletes an existing API Management service.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594037 = newJObject()
  var query_594038 = newJObject()
  add(path_594037, "resourceGroupName", newJString(resourceGroupName))
  add(query_594038, "api-version", newJString(apiVersion))
  add(path_594037, "subscriptionId", newJString(subscriptionId))
  add(path_594037, "serviceName", newJString(serviceName))
  result = call_594036.call(path_594037, query_594038, nil, nil, nil)

var apiManagementServiceDelete* = Call_ApiManagementServiceDelete_594028(
    name: "apiManagementServiceDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}",
    validator: validate_ApiManagementServiceDelete_594029, base: "",
    url: url_ApiManagementServiceDelete_594030, schemes: {Scheme.Https})
type
  Call_ApiManagementServiceApplyNetworkConfigurationUpdates_594052 = ref object of OpenApiRestCall_593425
proc url_ApiManagementServiceApplyNetworkConfigurationUpdates_594054(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"), (
        kind: ConstantSegment, value: "/applynetworkconfigurationupdates")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiManagementServiceApplyNetworkConfigurationUpdates_594053(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Updates the Microsoft.ApiManagement resource running in the Virtual network to pick the updated network settings.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594055 = path.getOrDefault("resourceGroupName")
  valid_594055 = validateParameter(valid_594055, JString, required = true,
                                 default = nil)
  if valid_594055 != nil:
    section.add "resourceGroupName", valid_594055
  var valid_594056 = path.getOrDefault("subscriptionId")
  valid_594056 = validateParameter(valid_594056, JString, required = true,
                                 default = nil)
  if valid_594056 != nil:
    section.add "subscriptionId", valid_594056
  var valid_594057 = path.getOrDefault("serviceName")
  valid_594057 = validateParameter(valid_594057, JString, required = true,
                                 default = nil)
  if valid_594057 != nil:
    section.add "serviceName", valid_594057
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594058 = query.getOrDefault("api-version")
  valid_594058 = validateParameter(valid_594058, JString, required = true,
                                 default = nil)
  if valid_594058 != nil:
    section.add "api-version", valid_594058
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject
  ##             : Parameters supplied to the Apply Network Configuration operation. If the parameters are empty, all the regions in which the Api Management service is deployed will be updated sequentially without incurring downtime in the region.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594060: Call_ApiManagementServiceApplyNetworkConfigurationUpdates_594052;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the Microsoft.ApiManagement resource running in the Virtual network to pick the updated network settings.
  ## 
  let valid = call_594060.validator(path, query, header, formData, body)
  let scheme = call_594060.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594060.url(scheme.get, call_594060.host, call_594060.base,
                         call_594060.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594060, url, valid)

proc call*(call_594061: Call_ApiManagementServiceApplyNetworkConfigurationUpdates_594052;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          serviceName: string; parameters: JsonNode = nil): Recallable =
  ## apiManagementServiceApplyNetworkConfigurationUpdates
  ## Updates the Microsoft.ApiManagement resource running in the Virtual network to pick the updated network settings.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject
  ##             : Parameters supplied to the Apply Network Configuration operation. If the parameters are empty, all the regions in which the Api Management service is deployed will be updated sequentially without incurring downtime in the region.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594062 = newJObject()
  var query_594063 = newJObject()
  var body_594064 = newJObject()
  add(path_594062, "resourceGroupName", newJString(resourceGroupName))
  add(query_594063, "api-version", newJString(apiVersion))
  add(path_594062, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594064 = parameters
  add(path_594062, "serviceName", newJString(serviceName))
  result = call_594061.call(path_594062, query_594063, nil, nil, body_594064)

var apiManagementServiceApplyNetworkConfigurationUpdates* = Call_ApiManagementServiceApplyNetworkConfigurationUpdates_594052(
    name: "apiManagementServiceApplyNetworkConfigurationUpdates",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/applynetworkconfigurationupdates",
    validator: validate_ApiManagementServiceApplyNetworkConfigurationUpdates_594053,
    base: "", url: url_ApiManagementServiceApplyNetworkConfigurationUpdates_594054,
    schemes: {Scheme.Https})
type
  Call_ApiManagementServiceBackup_594065 = ref object of OpenApiRestCall_593425
proc url_ApiManagementServiceBackup_594067(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/backup")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiManagementServiceBackup_594066(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a backup of the API Management service to the given Azure Storage Account. This is long running operation and could take several minutes to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594068 = path.getOrDefault("resourceGroupName")
  valid_594068 = validateParameter(valid_594068, JString, required = true,
                                 default = nil)
  if valid_594068 != nil:
    section.add "resourceGroupName", valid_594068
  var valid_594069 = path.getOrDefault("subscriptionId")
  valid_594069 = validateParameter(valid_594069, JString, required = true,
                                 default = nil)
  if valid_594069 != nil:
    section.add "subscriptionId", valid_594069
  var valid_594070 = path.getOrDefault("serviceName")
  valid_594070 = validateParameter(valid_594070, JString, required = true,
                                 default = nil)
  if valid_594070 != nil:
    section.add "serviceName", valid_594070
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594071 = query.getOrDefault("api-version")
  valid_594071 = validateParameter(valid_594071, JString, required = true,
                                 default = nil)
  if valid_594071 != nil:
    section.add "api-version", valid_594071
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the ApiManagementService_Backup operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594073: Call_ApiManagementServiceBackup_594065; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a backup of the API Management service to the given Azure Storage Account. This is long running operation and could take several minutes to complete.
  ## 
  let valid = call_594073.validator(path, query, header, formData, body)
  let scheme = call_594073.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594073.url(scheme.get, call_594073.host, call_594073.base,
                         call_594073.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594073, url, valid)

proc call*(call_594074: Call_ApiManagementServiceBackup_594065;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; serviceName: string): Recallable =
  ## apiManagementServiceBackup
  ## Creates a backup of the API Management service to the given Azure Storage Account. This is long running operation and could take several minutes to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the ApiManagementService_Backup operation.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594075 = newJObject()
  var query_594076 = newJObject()
  var body_594077 = newJObject()
  add(path_594075, "resourceGroupName", newJString(resourceGroupName))
  add(query_594076, "api-version", newJString(apiVersion))
  add(path_594075, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594077 = parameters
  add(path_594075, "serviceName", newJString(serviceName))
  result = call_594074.call(path_594075, query_594076, nil, nil, body_594077)

var apiManagementServiceBackup* = Call_ApiManagementServiceBackup_594065(
    name: "apiManagementServiceBackup", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/backup",
    validator: validate_ApiManagementServiceBackup_594066, base: "",
    url: url_ApiManagementServiceBackup_594067, schemes: {Scheme.Https})
type
  Call_ApiManagementServiceGetSsoToken_594078 = ref object of OpenApiRestCall_593425
proc url_ApiManagementServiceGetSsoToken_594080(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/getssotoken")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiManagementServiceGetSsoToken_594079(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the Single-Sign-On token for the API Management Service which is valid for 5 Minutes.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594081 = path.getOrDefault("resourceGroupName")
  valid_594081 = validateParameter(valid_594081, JString, required = true,
                                 default = nil)
  if valid_594081 != nil:
    section.add "resourceGroupName", valid_594081
  var valid_594082 = path.getOrDefault("subscriptionId")
  valid_594082 = validateParameter(valid_594082, JString, required = true,
                                 default = nil)
  if valid_594082 != nil:
    section.add "subscriptionId", valid_594082
  var valid_594083 = path.getOrDefault("serviceName")
  valid_594083 = validateParameter(valid_594083, JString, required = true,
                                 default = nil)
  if valid_594083 != nil:
    section.add "serviceName", valid_594083
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594084 = query.getOrDefault("api-version")
  valid_594084 = validateParameter(valid_594084, JString, required = true,
                                 default = nil)
  if valid_594084 != nil:
    section.add "api-version", valid_594084
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594085: Call_ApiManagementServiceGetSsoToken_594078;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the Single-Sign-On token for the API Management Service which is valid for 5 Minutes.
  ## 
  let valid = call_594085.validator(path, query, header, formData, body)
  let scheme = call_594085.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594085.url(scheme.get, call_594085.host, call_594085.base,
                         call_594085.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594085, url, valid)

proc call*(call_594086: Call_ApiManagementServiceGetSsoToken_594078;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          serviceName: string): Recallable =
  ## apiManagementServiceGetSsoToken
  ## Gets the Single-Sign-On token for the API Management Service which is valid for 5 Minutes.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594087 = newJObject()
  var query_594088 = newJObject()
  add(path_594087, "resourceGroupName", newJString(resourceGroupName))
  add(query_594088, "api-version", newJString(apiVersion))
  add(path_594087, "subscriptionId", newJString(subscriptionId))
  add(path_594087, "serviceName", newJString(serviceName))
  result = call_594086.call(path_594087, query_594088, nil, nil, nil)

var apiManagementServiceGetSsoToken* = Call_ApiManagementServiceGetSsoToken_594078(
    name: "apiManagementServiceGetSsoToken", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/getssotoken",
    validator: validate_ApiManagementServiceGetSsoToken_594079, base: "",
    url: url_ApiManagementServiceGetSsoToken_594080, schemes: {Scheme.Https})
type
  Call_ApiManagementServiceRestore_594089 = ref object of OpenApiRestCall_593425
proc url_ApiManagementServiceRestore_594091(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/restore")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiManagementServiceRestore_594090(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Restores a backup of an API Management service created using the ApiManagementService_Backup operation on the current service. This is a long running operation and could take several minutes to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594092 = path.getOrDefault("resourceGroupName")
  valid_594092 = validateParameter(valid_594092, JString, required = true,
                                 default = nil)
  if valid_594092 != nil:
    section.add "resourceGroupName", valid_594092
  var valid_594093 = path.getOrDefault("subscriptionId")
  valid_594093 = validateParameter(valid_594093, JString, required = true,
                                 default = nil)
  if valid_594093 != nil:
    section.add "subscriptionId", valid_594093
  var valid_594094 = path.getOrDefault("serviceName")
  valid_594094 = validateParameter(valid_594094, JString, required = true,
                                 default = nil)
  if valid_594094 != nil:
    section.add "serviceName", valid_594094
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594095 = query.getOrDefault("api-version")
  valid_594095 = validateParameter(valid_594095, JString, required = true,
                                 default = nil)
  if valid_594095 != nil:
    section.add "api-version", valid_594095
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Restore API Management service from backup operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594097: Call_ApiManagementServiceRestore_594089; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Restores a backup of an API Management service created using the ApiManagementService_Backup operation on the current service. This is a long running operation and could take several minutes to complete.
  ## 
  let valid = call_594097.validator(path, query, header, formData, body)
  let scheme = call_594097.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594097.url(scheme.get, call_594097.host, call_594097.base,
                         call_594097.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594097, url, valid)

proc call*(call_594098: Call_ApiManagementServiceRestore_594089;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; serviceName: string): Recallable =
  ## apiManagementServiceRestore
  ## Restores a backup of an API Management service created using the ApiManagementService_Backup operation on the current service. This is a long running operation and could take several minutes to complete.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Restore API Management service from backup operation.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594099 = newJObject()
  var query_594100 = newJObject()
  var body_594101 = newJObject()
  add(path_594099, "resourceGroupName", newJString(resourceGroupName))
  add(query_594100, "api-version", newJString(apiVersion))
  add(path_594099, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594101 = parameters
  add(path_594099, "serviceName", newJString(serviceName))
  result = call_594098.call(path_594099, query_594100, nil, nil, body_594101)

var apiManagementServiceRestore* = Call_ApiManagementServiceRestore_594089(
    name: "apiManagementServiceRestore", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/restore",
    validator: validate_ApiManagementServiceRestore_594090, base: "",
    url: url_ApiManagementServiceRestore_594091, schemes: {Scheme.Https})
type
  Call_ApiManagementServiceSkusListAvailableServiceSkus_594102 = ref object of OpenApiRestCall_593425
proc url_ApiManagementServiceSkusListAvailableServiceSkus_594104(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/skus")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiManagementServiceSkusListAvailableServiceSkus_594103(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets all available SKU for a given API Management service
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594105 = path.getOrDefault("resourceGroupName")
  valid_594105 = validateParameter(valid_594105, JString, required = true,
                                 default = nil)
  if valid_594105 != nil:
    section.add "resourceGroupName", valid_594105
  var valid_594106 = path.getOrDefault("subscriptionId")
  valid_594106 = validateParameter(valid_594106, JString, required = true,
                                 default = nil)
  if valid_594106 != nil:
    section.add "subscriptionId", valid_594106
  var valid_594107 = path.getOrDefault("serviceName")
  valid_594107 = validateParameter(valid_594107, JString, required = true,
                                 default = nil)
  if valid_594107 != nil:
    section.add "serviceName", valid_594107
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594108 = query.getOrDefault("api-version")
  valid_594108 = validateParameter(valid_594108, JString, required = true,
                                 default = nil)
  if valid_594108 != nil:
    section.add "api-version", valid_594108
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594109: Call_ApiManagementServiceSkusListAvailableServiceSkus_594102;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all available SKU for a given API Management service
  ## 
  let valid = call_594109.validator(path, query, header, formData, body)
  let scheme = call_594109.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594109.url(scheme.get, call_594109.host, call_594109.base,
                         call_594109.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594109, url, valid)

proc call*(call_594110: Call_ApiManagementServiceSkusListAvailableServiceSkus_594102;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          serviceName: string): Recallable =
  ## apiManagementServiceSkusListAvailableServiceSkus
  ## Gets all available SKU for a given API Management service
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594111 = newJObject()
  var query_594112 = newJObject()
  add(path_594111, "resourceGroupName", newJString(resourceGroupName))
  add(query_594112, "api-version", newJString(apiVersion))
  add(path_594111, "subscriptionId", newJString(subscriptionId))
  add(path_594111, "serviceName", newJString(serviceName))
  result = call_594110.call(path_594111, query_594112, nil, nil, nil)

var apiManagementServiceSkusListAvailableServiceSkus* = Call_ApiManagementServiceSkusListAvailableServiceSkus_594102(
    name: "apiManagementServiceSkusListAvailableServiceSkus",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/skus",
    validator: validate_ApiManagementServiceSkusListAvailableServiceSkus_594103,
    base: "", url: url_ApiManagementServiceSkusListAvailableServiceSkus_594104,
    schemes: {Scheme.Https})
type
  Call_ApiManagementServiceUploadCertificate_594113 = ref object of OpenApiRestCall_593425
proc url_ApiManagementServiceUploadCertificate_594115(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/updatecertificate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiManagementServiceUploadCertificate_594114(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Upload Custom Domain SSL certificate for an API Management service. This operation will be deprecated in future releases.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594116 = path.getOrDefault("resourceGroupName")
  valid_594116 = validateParameter(valid_594116, JString, required = true,
                                 default = nil)
  if valid_594116 != nil:
    section.add "resourceGroupName", valid_594116
  var valid_594117 = path.getOrDefault("subscriptionId")
  valid_594117 = validateParameter(valid_594117, JString, required = true,
                                 default = nil)
  if valid_594117 != nil:
    section.add "subscriptionId", valid_594117
  var valid_594118 = path.getOrDefault("serviceName")
  valid_594118 = validateParameter(valid_594118, JString, required = true,
                                 default = nil)
  if valid_594118 != nil:
    section.add "serviceName", valid_594118
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594119 = query.getOrDefault("api-version")
  valid_594119 = validateParameter(valid_594119, JString, required = true,
                                 default = nil)
  if valid_594119 != nil:
    section.add "api-version", valid_594119
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Upload SSL certificate for an API Management service operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594121: Call_ApiManagementServiceUploadCertificate_594113;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Upload Custom Domain SSL certificate for an API Management service. This operation will be deprecated in future releases.
  ## 
  let valid = call_594121.validator(path, query, header, formData, body)
  let scheme = call_594121.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594121.url(scheme.get, call_594121.host, call_594121.base,
                         call_594121.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594121, url, valid)

proc call*(call_594122: Call_ApiManagementServiceUploadCertificate_594113;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; serviceName: string): Recallable =
  ## apiManagementServiceUploadCertificate
  ## Upload Custom Domain SSL certificate for an API Management service. This operation will be deprecated in future releases.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Upload SSL certificate for an API Management service operation.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594123 = newJObject()
  var query_594124 = newJObject()
  var body_594125 = newJObject()
  add(path_594123, "resourceGroupName", newJString(resourceGroupName))
  add(query_594124, "api-version", newJString(apiVersion))
  add(path_594123, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594125 = parameters
  add(path_594123, "serviceName", newJString(serviceName))
  result = call_594122.call(path_594123, query_594124, nil, nil, body_594125)

var apiManagementServiceUploadCertificate* = Call_ApiManagementServiceUploadCertificate_594113(
    name: "apiManagementServiceUploadCertificate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/updatecertificate",
    validator: validate_ApiManagementServiceUploadCertificate_594114, base: "",
    url: url_ApiManagementServiceUploadCertificate_594115, schemes: {Scheme.Https})
type
  Call_ApiManagementServiceUpdateHostname_594126 = ref object of OpenApiRestCall_593425
proc url_ApiManagementServiceUpdateHostname_594128(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/updatehostname")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiManagementServiceUpdateHostname_594127(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates, updates, or deletes the custom hostnames for an API Management service. The custom hostname can be applied to the Proxy and Portal endpoint. This is a long running operation and could take several minutes to complete. This operation will be deprecated in the next version update.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594129 = path.getOrDefault("resourceGroupName")
  valid_594129 = validateParameter(valid_594129, JString, required = true,
                                 default = nil)
  if valid_594129 != nil:
    section.add "resourceGroupName", valid_594129
  var valid_594130 = path.getOrDefault("subscriptionId")
  valid_594130 = validateParameter(valid_594130, JString, required = true,
                                 default = nil)
  if valid_594130 != nil:
    section.add "subscriptionId", valid_594130
  var valid_594131 = path.getOrDefault("serviceName")
  valid_594131 = validateParameter(valid_594131, JString, required = true,
                                 default = nil)
  if valid_594131 != nil:
    section.add "serviceName", valid_594131
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594132 = query.getOrDefault("api-version")
  valid_594132 = validateParameter(valid_594132, JString, required = true,
                                 default = nil)
  if valid_594132 != nil:
    section.add "api-version", valid_594132
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the UpdateHostname operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594134: Call_ApiManagementServiceUpdateHostname_594126;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates, updates, or deletes the custom hostnames for an API Management service. The custom hostname can be applied to the Proxy and Portal endpoint. This is a long running operation and could take several minutes to complete. This operation will be deprecated in the next version update.
  ## 
  let valid = call_594134.validator(path, query, header, formData, body)
  let scheme = call_594134.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594134.url(scheme.get, call_594134.host, call_594134.base,
                         call_594134.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594134, url, valid)

proc call*(call_594135: Call_ApiManagementServiceUpdateHostname_594126;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; serviceName: string): Recallable =
  ## apiManagementServiceUpdateHostname
  ## Creates, updates, or deletes the custom hostnames for an API Management service. The custom hostname can be applied to the Proxy and Portal endpoint. This is a long running operation and could take several minutes to complete. This operation will be deprecated in the next version update.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the UpdateHostname operation.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594136 = newJObject()
  var query_594137 = newJObject()
  var body_594138 = newJObject()
  add(path_594136, "resourceGroupName", newJString(resourceGroupName))
  add(query_594137, "api-version", newJString(apiVersion))
  add(path_594136, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594138 = parameters
  add(path_594136, "serviceName", newJString(serviceName))
  result = call_594135.call(path_594136, query_594137, nil, nil, body_594138)

var apiManagementServiceUpdateHostname* = Call_ApiManagementServiceUpdateHostname_594126(
    name: "apiManagementServiceUpdateHostname", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/updatehostname",
    validator: validate_ApiManagementServiceUpdateHostname_594127, base: "",
    url: url_ApiManagementServiceUpdateHostname_594128, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
