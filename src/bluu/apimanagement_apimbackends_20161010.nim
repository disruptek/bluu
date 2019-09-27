
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: ApiManagementClient
## version: 2016-10-10
## termsOfService: (not provided)
## license: (not provided)
## 
## Use these REST APIs for performing operations on Backend entity in Azure API Management deployment. The Backend entity in API Management represents a backend service that is configured to skip certification chain validation when using a self-signed certificate to test mutual certificate authentication.
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

  OpenApiRestCall_593424 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593424](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593424): Option[Scheme] {.used.} =
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
  macServiceName = "apimanagement-apimbackends"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_BackendsListByService_593646 = ref object of OpenApiRestCall_593424
proc url_BackendsListByService_593648(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: ConstantSegment, value: "/backends")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackendsListByService_593647(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists a collection of backends in the specified service instance.
  ## 
  ## https://msdn.microsoft.com/en-us/library/dn935030.aspx
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
  var valid_593809 = path.getOrDefault("resourceGroupName")
  valid_593809 = validateParameter(valid_593809, JString, required = true,
                                 default = nil)
  if valid_593809 != nil:
    section.add "resourceGroupName", valid_593809
  var valid_593810 = path.getOrDefault("subscriptionId")
  valid_593810 = validateParameter(valid_593810, JString, required = true,
                                 default = nil)
  if valid_593810 != nil:
    section.add "subscriptionId", valid_593810
  var valid_593811 = path.getOrDefault("serviceName")
  valid_593811 = validateParameter(valid_593811, JString, required = true,
                                 default = nil)
  if valid_593811 != nil:
    section.add "serviceName", valid_593811
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : Number of records to return.
  ##   $skip: JInt
  ##        : Number of records to skip.
  ##   $filter: JString
  ##          : | Field | Supported operators    | Supported functions                         |
  ## 
  ## |-------|------------------------|---------------------------------------------|
  ## | id    | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | host  | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593812 = query.getOrDefault("api-version")
  valid_593812 = validateParameter(valid_593812, JString, required = true,
                                 default = nil)
  if valid_593812 != nil:
    section.add "api-version", valid_593812
  var valid_593813 = query.getOrDefault("$top")
  valid_593813 = validateParameter(valid_593813, JInt, required = false, default = nil)
  if valid_593813 != nil:
    section.add "$top", valid_593813
  var valid_593814 = query.getOrDefault("$skip")
  valid_593814 = validateParameter(valid_593814, JInt, required = false, default = nil)
  if valid_593814 != nil:
    section.add "$skip", valid_593814
  var valid_593815 = query.getOrDefault("$filter")
  valid_593815 = validateParameter(valid_593815, JString, required = false,
                                 default = nil)
  if valid_593815 != nil:
    section.add "$filter", valid_593815
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593842: Call_BackendsListByService_593646; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a collection of backends in the specified service instance.
  ## 
  ## https://msdn.microsoft.com/en-us/library/dn935030.aspx
  let valid = call_593842.validator(path, query, header, formData, body)
  let scheme = call_593842.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593842.url(scheme.get, call_593842.host, call_593842.base,
                         call_593842.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593842, url, valid)

proc call*(call_593913: Call_BackendsListByService_593646;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          serviceName: string; Top: int = 0; Skip: int = 0; Filter: string = ""): Recallable =
  ## backendsListByService
  ## Lists a collection of backends in the specified service instance.
  ## https://msdn.microsoft.com/en-us/library/dn935030.aspx
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : Number of records to return.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   Filter: string
  ##         : | Field | Supported operators    | Supported functions                         |
  ## 
  ## |-------|------------------------|---------------------------------------------|
  ## | id    | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | host  | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  var path_593914 = newJObject()
  var query_593916 = newJObject()
  add(path_593914, "resourceGroupName", newJString(resourceGroupName))
  add(query_593916, "api-version", newJString(apiVersion))
  add(path_593914, "subscriptionId", newJString(subscriptionId))
  add(query_593916, "$top", newJInt(Top))
  add(query_593916, "$skip", newJInt(Skip))
  add(path_593914, "serviceName", newJString(serviceName))
  add(query_593916, "$filter", newJString(Filter))
  result = call_593913.call(path_593914, query_593916, nil, nil, nil)

var backendsListByService* = Call_BackendsListByService_593646(
    name: "backendsListByService", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/backends",
    validator: validate_BackendsListByService_593647, base: "",
    url: url_BackendsListByService_593648, schemes: {Scheme.Https})
type
  Call_BackendsCreateOrUpdate_593976 = ref object of OpenApiRestCall_593424
proc url_BackendsCreateOrUpdate_593978(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "backendid" in path, "`backendid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/backends/"),
               (kind: VariableSegment, value: "backendid")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackendsCreateOrUpdate_593977(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or Updates a backend.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   backendid: JString (required)
  ##            : Identifier of the Backend entity. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594006 = path.getOrDefault("resourceGroupName")
  valid_594006 = validateParameter(valid_594006, JString, required = true,
                                 default = nil)
  if valid_594006 != nil:
    section.add "resourceGroupName", valid_594006
  var valid_594007 = path.getOrDefault("backendid")
  valid_594007 = validateParameter(valid_594007, JString, required = true,
                                 default = nil)
  if valid_594007 != nil:
    section.add "backendid", valid_594007
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
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Create parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594012: Call_BackendsCreateOrUpdate_593976; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or Updates a backend.
  ## 
  let valid = call_594012.validator(path, query, header, formData, body)
  let scheme = call_594012.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594012.url(scheme.get, call_594012.host, call_594012.base,
                         call_594012.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594012, url, valid)

proc call*(call_594013: Call_BackendsCreateOrUpdate_593976;
          resourceGroupName: string; backendid: string; apiVersion: string;
          subscriptionId: string; parameters: JsonNode; serviceName: string): Recallable =
  ## backendsCreateOrUpdate
  ## Creates or Updates a backend.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   backendid: string (required)
  ##            : Identifier of the Backend entity. Must be unique in the current API Management service instance.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Create parameters.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594014 = newJObject()
  var query_594015 = newJObject()
  var body_594016 = newJObject()
  add(path_594014, "resourceGroupName", newJString(resourceGroupName))
  add(path_594014, "backendid", newJString(backendid))
  add(query_594015, "api-version", newJString(apiVersion))
  add(path_594014, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594016 = parameters
  add(path_594014, "serviceName", newJString(serviceName))
  result = call_594013.call(path_594014, query_594015, nil, nil, body_594016)

var backendsCreateOrUpdate* = Call_BackendsCreateOrUpdate_593976(
    name: "backendsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/backends/{backendid}",
    validator: validate_BackendsCreateOrUpdate_593977, base: "",
    url: url_BackendsCreateOrUpdate_593978, schemes: {Scheme.Https})
type
  Call_BackendsGet_593955 = ref object of OpenApiRestCall_593424
proc url_BackendsGet_593957(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "backendid" in path, "`backendid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/backends/"),
               (kind: VariableSegment, value: "backendid")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackendsGet_593956(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of the backend specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   backendid: JString (required)
  ##            : Identifier of the Backend entity. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593967 = path.getOrDefault("resourceGroupName")
  valid_593967 = validateParameter(valid_593967, JString, required = true,
                                 default = nil)
  if valid_593967 != nil:
    section.add "resourceGroupName", valid_593967
  var valid_593968 = path.getOrDefault("backendid")
  valid_593968 = validateParameter(valid_593968, JString, required = true,
                                 default = nil)
  if valid_593968 != nil:
    section.add "backendid", valid_593968
  var valid_593969 = path.getOrDefault("subscriptionId")
  valid_593969 = validateParameter(valid_593969, JString, required = true,
                                 default = nil)
  if valid_593969 != nil:
    section.add "subscriptionId", valid_593969
  var valid_593970 = path.getOrDefault("serviceName")
  valid_593970 = validateParameter(valid_593970, JString, required = true,
                                 default = nil)
  if valid_593970 != nil:
    section.add "serviceName", valid_593970
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593971 = query.getOrDefault("api-version")
  valid_593971 = validateParameter(valid_593971, JString, required = true,
                                 default = nil)
  if valid_593971 != nil:
    section.add "api-version", valid_593971
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593972: Call_BackendsGet_593955; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the backend specified by its identifier.
  ## 
  let valid = call_593972.validator(path, query, header, formData, body)
  let scheme = call_593972.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593972.url(scheme.get, call_593972.host, call_593972.base,
                         call_593972.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593972, url, valid)

proc call*(call_593973: Call_BackendsGet_593955; resourceGroupName: string;
          backendid: string; apiVersion: string; subscriptionId: string;
          serviceName: string): Recallable =
  ## backendsGet
  ## Gets the details of the backend specified by its identifier.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   backendid: string (required)
  ##            : Identifier of the Backend entity. Must be unique in the current API Management service instance.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_593974 = newJObject()
  var query_593975 = newJObject()
  add(path_593974, "resourceGroupName", newJString(resourceGroupName))
  add(path_593974, "backendid", newJString(backendid))
  add(query_593975, "api-version", newJString(apiVersion))
  add(path_593974, "subscriptionId", newJString(subscriptionId))
  add(path_593974, "serviceName", newJString(serviceName))
  result = call_593973.call(path_593974, query_593975, nil, nil, nil)

var backendsGet* = Call_BackendsGet_593955(name: "backendsGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/backends/{backendid}",
                                        validator: validate_BackendsGet_593956,
                                        base: "", url: url_BackendsGet_593957,
                                        schemes: {Scheme.Https})
type
  Call_BackendsUpdate_594030 = ref object of OpenApiRestCall_593424
proc url_BackendsUpdate_594032(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "backendid" in path, "`backendid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/backends/"),
               (kind: VariableSegment, value: "backendid")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackendsUpdate_594031(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Updates an existing backend.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   backendid: JString (required)
  ##            : Identifier of the Backend entity. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594033 = path.getOrDefault("resourceGroupName")
  valid_594033 = validateParameter(valid_594033, JString, required = true,
                                 default = nil)
  if valid_594033 != nil:
    section.add "resourceGroupName", valid_594033
  var valid_594034 = path.getOrDefault("backendid")
  valid_594034 = validateParameter(valid_594034, JString, required = true,
                                 default = nil)
  if valid_594034 != nil:
    section.add "backendid", valid_594034
  var valid_594035 = path.getOrDefault("subscriptionId")
  valid_594035 = validateParameter(valid_594035, JString, required = true,
                                 default = nil)
  if valid_594035 != nil:
    section.add "subscriptionId", valid_594035
  var valid_594036 = path.getOrDefault("serviceName")
  valid_594036 = validateParameter(valid_594036, JString, required = true,
                                 default = nil)
  if valid_594036 != nil:
    section.add "serviceName", valid_594036
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594037 = query.getOrDefault("api-version")
  valid_594037 = validateParameter(valid_594037, JString, required = true,
                                 default = nil)
  if valid_594037 != nil:
    section.add "api-version", valid_594037
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : The entity state (Etag) version of the backend to update. A value of "*" can be used for If-Match to unconditionally apply the operation.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_594038 = header.getOrDefault("If-Match")
  valid_594038 = validateParameter(valid_594038, JString, required = true,
                                 default = nil)
  if valid_594038 != nil:
    section.add "If-Match", valid_594038
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Update parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594040: Call_BackendsUpdate_594030; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing backend.
  ## 
  let valid = call_594040.validator(path, query, header, formData, body)
  let scheme = call_594040.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594040.url(scheme.get, call_594040.host, call_594040.base,
                         call_594040.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594040, url, valid)

proc call*(call_594041: Call_BackendsUpdate_594030; resourceGroupName: string;
          backendid: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; serviceName: string): Recallable =
  ## backendsUpdate
  ## Updates an existing backend.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   backendid: string (required)
  ##            : Identifier of the Backend entity. Must be unique in the current API Management service instance.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Update parameters.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594042 = newJObject()
  var query_594043 = newJObject()
  var body_594044 = newJObject()
  add(path_594042, "resourceGroupName", newJString(resourceGroupName))
  add(path_594042, "backendid", newJString(backendid))
  add(query_594043, "api-version", newJString(apiVersion))
  add(path_594042, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594044 = parameters
  add(path_594042, "serviceName", newJString(serviceName))
  result = call_594041.call(path_594042, query_594043, nil, nil, body_594044)

var backendsUpdate* = Call_BackendsUpdate_594030(name: "backendsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/backends/{backendid}",
    validator: validate_BackendsUpdate_594031, base: "", url: url_BackendsUpdate_594032,
    schemes: {Scheme.Https})
type
  Call_BackendsDelete_594017 = ref object of OpenApiRestCall_593424
proc url_BackendsDelete_594019(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "backendid" in path, "`backendid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/backends/"),
               (kind: VariableSegment, value: "backendid")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackendsDelete_594018(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Deletes the specified backend.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   backendid: JString (required)
  ##            : Identifier of the Backend entity. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594020 = path.getOrDefault("resourceGroupName")
  valid_594020 = validateParameter(valid_594020, JString, required = true,
                                 default = nil)
  if valid_594020 != nil:
    section.add "resourceGroupName", valid_594020
  var valid_594021 = path.getOrDefault("backendid")
  valid_594021 = validateParameter(valid_594021, JString, required = true,
                                 default = nil)
  if valid_594021 != nil:
    section.add "backendid", valid_594021
  var valid_594022 = path.getOrDefault("subscriptionId")
  valid_594022 = validateParameter(valid_594022, JString, required = true,
                                 default = nil)
  if valid_594022 != nil:
    section.add "subscriptionId", valid_594022
  var valid_594023 = path.getOrDefault("serviceName")
  valid_594023 = validateParameter(valid_594023, JString, required = true,
                                 default = nil)
  if valid_594023 != nil:
    section.add "serviceName", valid_594023
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594024 = query.getOrDefault("api-version")
  valid_594024 = validateParameter(valid_594024, JString, required = true,
                                 default = nil)
  if valid_594024 != nil:
    section.add "api-version", valid_594024
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : The entity state (Etag) version of the backend to delete. A value of "*" can be used for If-Match to unconditionally apply the operation.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_594025 = header.getOrDefault("If-Match")
  valid_594025 = validateParameter(valid_594025, JString, required = true,
                                 default = nil)
  if valid_594025 != nil:
    section.add "If-Match", valid_594025
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594026: Call_BackendsDelete_594017; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified backend.
  ## 
  let valid = call_594026.validator(path, query, header, formData, body)
  let scheme = call_594026.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594026.url(scheme.get, call_594026.host, call_594026.base,
                         call_594026.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594026, url, valid)

proc call*(call_594027: Call_BackendsDelete_594017; resourceGroupName: string;
          backendid: string; apiVersion: string; subscriptionId: string;
          serviceName: string): Recallable =
  ## backendsDelete
  ## Deletes the specified backend.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   backendid: string (required)
  ##            : Identifier of the Backend entity. Must be unique in the current API Management service instance.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594028 = newJObject()
  var query_594029 = newJObject()
  add(path_594028, "resourceGroupName", newJString(resourceGroupName))
  add(path_594028, "backendid", newJString(backendid))
  add(query_594029, "api-version", newJString(apiVersion))
  add(path_594028, "subscriptionId", newJString(subscriptionId))
  add(path_594028, "serviceName", newJString(serviceName))
  result = call_594027.call(path_594028, query_594029, nil, nil, nil)

var backendsDelete* = Call_BackendsDelete_594017(name: "backendsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/backends/{backendid}",
    validator: validate_BackendsDelete_594018, base: "", url: url_BackendsDelete_594019,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
