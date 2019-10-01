
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: ApiManagementClient
## version: 2017-03-01
## termsOfService: (not provided)
## license: (not provided)
## 
## Use these REST APIs for performing operations on API entity and their Operations associated with your Azure API Management deployment.
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
  macServiceName = "apimanagement-apimapis"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ApiListByService_593647 = ref object of OpenApiRestCall_593425
proc url_ApiListByService_593649(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/apis")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiListByService_593648(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Lists all APIs of the API Management service instance.
  ## 
  ## https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-create-apis
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
  var valid_593810 = path.getOrDefault("resourceGroupName")
  valid_593810 = validateParameter(valid_593810, JString, required = true,
                                 default = nil)
  if valid_593810 != nil:
    section.add "resourceGroupName", valid_593810
  var valid_593811 = path.getOrDefault("subscriptionId")
  valid_593811 = validateParameter(valid_593811, JString, required = true,
                                 default = nil)
  if valid_593811 != nil:
    section.add "subscriptionId", valid_593811
  var valid_593812 = path.getOrDefault("serviceName")
  valid_593812 = validateParameter(valid_593812, JString, required = true,
                                 default = nil)
  if valid_593812 != nil:
    section.add "serviceName", valid_593812
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   expandApiVersionSet: JBool
  ##                      : Include full ApiVersionSet resource in response
  ##   $top: JInt
  ##       : Number of records to return.
  ##   $skip: JInt
  ##        : Number of records to skip.
  ##   $filter: JString
  ##          : | Field       | Supported operators    | Supported functions               |
  ## |-------------|------------------------|-----------------------------------|
  ## | id          | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  ## | name        | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  ## | description | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  ## | serviceUrl  | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  ## | path        | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593813 = query.getOrDefault("api-version")
  valid_593813 = validateParameter(valid_593813, JString, required = true,
                                 default = nil)
  if valid_593813 != nil:
    section.add "api-version", valid_593813
  var valid_593827 = query.getOrDefault("expandApiVersionSet")
  valid_593827 = validateParameter(valid_593827, JBool, required = false,
                                 default = newJBool(false))
  if valid_593827 != nil:
    section.add "expandApiVersionSet", valid_593827
  var valid_593828 = query.getOrDefault("$top")
  valid_593828 = validateParameter(valid_593828, JInt, required = false, default = nil)
  if valid_593828 != nil:
    section.add "$top", valid_593828
  var valid_593829 = query.getOrDefault("$skip")
  valid_593829 = validateParameter(valid_593829, JInt, required = false, default = nil)
  if valid_593829 != nil:
    section.add "$skip", valid_593829
  var valid_593830 = query.getOrDefault("$filter")
  valid_593830 = validateParameter(valid_593830, JString, required = false,
                                 default = nil)
  if valid_593830 != nil:
    section.add "$filter", valid_593830
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593857: Call_ApiListByService_593647; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all APIs of the API Management service instance.
  ## 
  ## https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-create-apis
  let valid = call_593857.validator(path, query, header, formData, body)
  let scheme = call_593857.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593857.url(scheme.get, call_593857.host, call_593857.base,
                         call_593857.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593857, url, valid)

proc call*(call_593928: Call_ApiListByService_593647; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; serviceName: string;
          expandApiVersionSet: bool = false; Top: int = 0; Skip: int = 0;
          Filter: string = ""): Recallable =
  ## apiListByService
  ## Lists all APIs of the API Management service instance.
  ## https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-create-apis
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   expandApiVersionSet: bool
  ##                      : Include full ApiVersionSet resource in response
  ##   Top: int
  ##      : Number of records to return.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   Filter: string
  ##         : | Field       | Supported operators    | Supported functions               |
  ## |-------------|------------------------|-----------------------------------|
  ## | id          | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  ## | name        | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  ## | description | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  ## | serviceUrl  | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  ## | path        | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  var path_593929 = newJObject()
  var query_593931 = newJObject()
  add(path_593929, "resourceGroupName", newJString(resourceGroupName))
  add(query_593931, "api-version", newJString(apiVersion))
  add(path_593929, "subscriptionId", newJString(subscriptionId))
  add(query_593931, "expandApiVersionSet", newJBool(expandApiVersionSet))
  add(query_593931, "$top", newJInt(Top))
  add(query_593931, "$skip", newJInt(Skip))
  add(path_593929, "serviceName", newJString(serviceName))
  add(query_593931, "$filter", newJString(Filter))
  result = call_593928.call(path_593929, query_593931, nil, nil, nil)

var apiListByService* = Call_ApiListByService_593647(name: "apiListByService",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis",
    validator: validate_ApiListByService_593648, base: "",
    url: url_ApiListByService_593649, schemes: {Scheme.Https})
type
  Call_ApiCreateOrUpdate_593991 = ref object of OpenApiRestCall_593425
proc url_ApiCreateOrUpdate_593993(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiCreateOrUpdate_593992(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Creates new or updates existing specified API of the API Management service instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594011 = path.getOrDefault("resourceGroupName")
  valid_594011 = validateParameter(valid_594011, JString, required = true,
                                 default = nil)
  if valid_594011 != nil:
    section.add "resourceGroupName", valid_594011
  var valid_594012 = path.getOrDefault("apiId")
  valid_594012 = validateParameter(valid_594012, JString, required = true,
                                 default = nil)
  if valid_594012 != nil:
    section.add "apiId", valid_594012
  var valid_594013 = path.getOrDefault("subscriptionId")
  valid_594013 = validateParameter(valid_594013, JString, required = true,
                                 default = nil)
  if valid_594013 != nil:
    section.add "subscriptionId", valid_594013
  var valid_594014 = path.getOrDefault("serviceName")
  valid_594014 = validateParameter(valid_594014, JString, required = true,
                                 default = nil)
  if valid_594014 != nil:
    section.add "serviceName", valid_594014
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594015 = query.getOrDefault("api-version")
  valid_594015 = validateParameter(valid_594015, JString, required = true,
                                 default = nil)
  if valid_594015 != nil:
    section.add "api-version", valid_594015
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the Api Entity. For Create Api Etag should not be specified. For Update Etag should match the existing Entity or it can be * for unconditional update.
  section = newJObject()
  var valid_594016 = header.getOrDefault("If-Match")
  valid_594016 = validateParameter(valid_594016, JString, required = false,
                                 default = nil)
  if valid_594016 != nil:
    section.add "If-Match", valid_594016
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Create or update parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594018: Call_ApiCreateOrUpdate_593991; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates new or updates existing specified API of the API Management service instance.
  ## 
  let valid = call_594018.validator(path, query, header, formData, body)
  let scheme = call_594018.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594018.url(scheme.get, call_594018.host, call_594018.base,
                         call_594018.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594018, url, valid)

proc call*(call_594019: Call_ApiCreateOrUpdate_593991; resourceGroupName: string;
          apiVersion: string; apiId: string; subscriptionId: string;
          parameters: JsonNode; serviceName: string): Recallable =
  ## apiCreateOrUpdate
  ## Creates new or updates existing specified API of the API Management service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Create or update parameters.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594020 = newJObject()
  var query_594021 = newJObject()
  var body_594022 = newJObject()
  add(path_594020, "resourceGroupName", newJString(resourceGroupName))
  add(query_594021, "api-version", newJString(apiVersion))
  add(path_594020, "apiId", newJString(apiId))
  add(path_594020, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594022 = parameters
  add(path_594020, "serviceName", newJString(serviceName))
  result = call_594019.call(path_594020, query_594021, nil, nil, body_594022)

var apiCreateOrUpdate* = Call_ApiCreateOrUpdate_593991(name: "apiCreateOrUpdate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}",
    validator: validate_ApiCreateOrUpdate_593992, base: "",
    url: url_ApiCreateOrUpdate_593993, schemes: {Scheme.Https})
type
  Call_ApiGetEntityTag_594036 = ref object of OpenApiRestCall_593425
proc url_ApiGetEntityTag_594038(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiGetEntityTag_594037(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Gets the entity state (Etag) version of the API specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594039 = path.getOrDefault("resourceGroupName")
  valid_594039 = validateParameter(valid_594039, JString, required = true,
                                 default = nil)
  if valid_594039 != nil:
    section.add "resourceGroupName", valid_594039
  var valid_594040 = path.getOrDefault("apiId")
  valid_594040 = validateParameter(valid_594040, JString, required = true,
                                 default = nil)
  if valid_594040 != nil:
    section.add "apiId", valid_594040
  var valid_594041 = path.getOrDefault("subscriptionId")
  valid_594041 = validateParameter(valid_594041, JString, required = true,
                                 default = nil)
  if valid_594041 != nil:
    section.add "subscriptionId", valid_594041
  var valid_594042 = path.getOrDefault("serviceName")
  valid_594042 = validateParameter(valid_594042, JString, required = true,
                                 default = nil)
  if valid_594042 != nil:
    section.add "serviceName", valid_594042
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594043 = query.getOrDefault("api-version")
  valid_594043 = validateParameter(valid_594043, JString, required = true,
                                 default = nil)
  if valid_594043 != nil:
    section.add "api-version", valid_594043
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594044: Call_ApiGetEntityTag_594036; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the entity state (Etag) version of the API specified by its identifier.
  ## 
  let valid = call_594044.validator(path, query, header, formData, body)
  let scheme = call_594044.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594044.url(scheme.get, call_594044.host, call_594044.base,
                         call_594044.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594044, url, valid)

proc call*(call_594045: Call_ApiGetEntityTag_594036; resourceGroupName: string;
          apiVersion: string; apiId: string; subscriptionId: string;
          serviceName: string): Recallable =
  ## apiGetEntityTag
  ## Gets the entity state (Etag) version of the API specified by its identifier.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594046 = newJObject()
  var query_594047 = newJObject()
  add(path_594046, "resourceGroupName", newJString(resourceGroupName))
  add(query_594047, "api-version", newJString(apiVersion))
  add(path_594046, "apiId", newJString(apiId))
  add(path_594046, "subscriptionId", newJString(subscriptionId))
  add(path_594046, "serviceName", newJString(serviceName))
  result = call_594045.call(path_594046, query_594047, nil, nil, nil)

var apiGetEntityTag* = Call_ApiGetEntityTag_594036(name: "apiGetEntityTag",
    meth: HttpMethod.HttpHead, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}",
    validator: validate_ApiGetEntityTag_594037, base: "", url: url_ApiGetEntityTag_594038,
    schemes: {Scheme.Https})
type
  Call_ApiGet_593970 = ref object of OpenApiRestCall_593425
proc url_ApiGet_593972(protocol: Scheme; host: string; base: string; route: string;
                      path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiGet_593971(path: JsonNode; query: JsonNode; header: JsonNode;
                           formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of the API specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593982 = path.getOrDefault("resourceGroupName")
  valid_593982 = validateParameter(valid_593982, JString, required = true,
                                 default = nil)
  if valid_593982 != nil:
    section.add "resourceGroupName", valid_593982
  var valid_593983 = path.getOrDefault("apiId")
  valid_593983 = validateParameter(valid_593983, JString, required = true,
                                 default = nil)
  if valid_593983 != nil:
    section.add "apiId", valid_593983
  var valid_593984 = path.getOrDefault("subscriptionId")
  valid_593984 = validateParameter(valid_593984, JString, required = true,
                                 default = nil)
  if valid_593984 != nil:
    section.add "subscriptionId", valid_593984
  var valid_593985 = path.getOrDefault("serviceName")
  valid_593985 = validateParameter(valid_593985, JString, required = true,
                                 default = nil)
  if valid_593985 != nil:
    section.add "serviceName", valid_593985
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593986 = query.getOrDefault("api-version")
  valid_593986 = validateParameter(valid_593986, JString, required = true,
                                 default = nil)
  if valid_593986 != nil:
    section.add "api-version", valid_593986
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593987: Call_ApiGet_593970; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the API specified by its identifier.
  ## 
  let valid = call_593987.validator(path, query, header, formData, body)
  let scheme = call_593987.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593987.url(scheme.get, call_593987.host, call_593987.base,
                         call_593987.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593987, url, valid)

proc call*(call_593988: Call_ApiGet_593970; resourceGroupName: string;
          apiVersion: string; apiId: string; subscriptionId: string;
          serviceName: string): Recallable =
  ## apiGet
  ## Gets the details of the API specified by its identifier.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_593989 = newJObject()
  var query_593990 = newJObject()
  add(path_593989, "resourceGroupName", newJString(resourceGroupName))
  add(query_593990, "api-version", newJString(apiVersion))
  add(path_593989, "apiId", newJString(apiId))
  add(path_593989, "subscriptionId", newJString(subscriptionId))
  add(path_593989, "serviceName", newJString(serviceName))
  result = call_593988.call(path_593989, query_593990, nil, nil, nil)

var apiGet* = Call_ApiGet_593970(name: "apiGet", meth: HttpMethod.HttpGet,
                              host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}",
                              validator: validate_ApiGet_593971, base: "",
                              url: url_ApiGet_593972, schemes: {Scheme.Https})
type
  Call_ApiUpdate_594048 = ref object of OpenApiRestCall_593425
proc url_ApiUpdate_594050(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiUpdate_594049(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the specified API of the API Management service instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594051 = path.getOrDefault("resourceGroupName")
  valid_594051 = validateParameter(valid_594051, JString, required = true,
                                 default = nil)
  if valid_594051 != nil:
    section.add "resourceGroupName", valid_594051
  var valid_594052 = path.getOrDefault("apiId")
  valid_594052 = validateParameter(valid_594052, JString, required = true,
                                 default = nil)
  if valid_594052 != nil:
    section.add "apiId", valid_594052
  var valid_594053 = path.getOrDefault("subscriptionId")
  valid_594053 = validateParameter(valid_594053, JString, required = true,
                                 default = nil)
  if valid_594053 != nil:
    section.add "subscriptionId", valid_594053
  var valid_594054 = path.getOrDefault("serviceName")
  valid_594054 = validateParameter(valid_594054, JString, required = true,
                                 default = nil)
  if valid_594054 != nil:
    section.add "serviceName", valid_594054
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594055 = query.getOrDefault("api-version")
  valid_594055 = validateParameter(valid_594055, JString, required = true,
                                 default = nil)
  if valid_594055 != nil:
    section.add "api-version", valid_594055
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the API entity. ETag should match the current entity state in the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_594056 = header.getOrDefault("If-Match")
  valid_594056 = validateParameter(valid_594056, JString, required = true,
                                 default = nil)
  if valid_594056 != nil:
    section.add "If-Match", valid_594056
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : API Update Contract parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594058: Call_ApiUpdate_594048; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specified API of the API Management service instance.
  ## 
  let valid = call_594058.validator(path, query, header, formData, body)
  let scheme = call_594058.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594058.url(scheme.get, call_594058.host, call_594058.base,
                         call_594058.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594058, url, valid)

proc call*(call_594059: Call_ApiUpdate_594048; resourceGroupName: string;
          apiVersion: string; apiId: string; subscriptionId: string;
          parameters: JsonNode; serviceName: string): Recallable =
  ## apiUpdate
  ## Updates the specified API of the API Management service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : API Update Contract parameters.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594060 = newJObject()
  var query_594061 = newJObject()
  var body_594062 = newJObject()
  add(path_594060, "resourceGroupName", newJString(resourceGroupName))
  add(query_594061, "api-version", newJString(apiVersion))
  add(path_594060, "apiId", newJString(apiId))
  add(path_594060, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594062 = parameters
  add(path_594060, "serviceName", newJString(serviceName))
  result = call_594059.call(path_594060, query_594061, nil, nil, body_594062)

var apiUpdate* = Call_ApiUpdate_594048(name: "apiUpdate", meth: HttpMethod.HttpPatch,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}",
                                    validator: validate_ApiUpdate_594049,
                                    base: "", url: url_ApiUpdate_594050,
                                    schemes: {Scheme.Https})
type
  Call_ApiDelete_594023 = ref object of OpenApiRestCall_593425
proc url_ApiDelete_594025(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiDelete_594024(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified API of the API Management service instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594026 = path.getOrDefault("resourceGroupName")
  valid_594026 = validateParameter(valid_594026, JString, required = true,
                                 default = nil)
  if valid_594026 != nil:
    section.add "resourceGroupName", valid_594026
  var valid_594027 = path.getOrDefault("apiId")
  valid_594027 = validateParameter(valid_594027, JString, required = true,
                                 default = nil)
  if valid_594027 != nil:
    section.add "apiId", valid_594027
  var valid_594028 = path.getOrDefault("subscriptionId")
  valid_594028 = validateParameter(valid_594028, JString, required = true,
                                 default = nil)
  if valid_594028 != nil:
    section.add "subscriptionId", valid_594028
  var valid_594029 = path.getOrDefault("serviceName")
  valid_594029 = validateParameter(valid_594029, JString, required = true,
                                 default = nil)
  if valid_594029 != nil:
    section.add "serviceName", valid_594029
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594030 = query.getOrDefault("api-version")
  valid_594030 = validateParameter(valid_594030, JString, required = true,
                                 default = nil)
  if valid_594030 != nil:
    section.add "api-version", valid_594030
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the API Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_594031 = header.getOrDefault("If-Match")
  valid_594031 = validateParameter(valid_594031, JString, required = true,
                                 default = nil)
  if valid_594031 != nil:
    section.add "If-Match", valid_594031
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594032: Call_ApiDelete_594023; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified API of the API Management service instance.
  ## 
  let valid = call_594032.validator(path, query, header, formData, body)
  let scheme = call_594032.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594032.url(scheme.get, call_594032.host, call_594032.base,
                         call_594032.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594032, url, valid)

proc call*(call_594033: Call_ApiDelete_594023; resourceGroupName: string;
          apiVersion: string; apiId: string; subscriptionId: string;
          serviceName: string): Recallable =
  ## apiDelete
  ## Deletes the specified API of the API Management service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594034 = newJObject()
  var query_594035 = newJObject()
  add(path_594034, "resourceGroupName", newJString(resourceGroupName))
  add(query_594035, "api-version", newJString(apiVersion))
  add(path_594034, "apiId", newJString(apiId))
  add(path_594034, "subscriptionId", newJString(subscriptionId))
  add(path_594034, "serviceName", newJString(serviceName))
  result = call_594033.call(path_594034, query_594035, nil, nil, nil)

var apiDelete* = Call_ApiDelete_594023(name: "apiDelete",
                                    meth: HttpMethod.HttpDelete,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}",
                                    validator: validate_ApiDelete_594024,
                                    base: "", url: url_ApiDelete_594025,
                                    schemes: {Scheme.Https})
type
  Call_ApiDiagnosticListByService_594063 = ref object of OpenApiRestCall_593425
proc url_ApiDiagnosticListByService_594065(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/diagnostics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiDiagnosticListByService_594064(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all diagnostics of an API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594066 = path.getOrDefault("resourceGroupName")
  valid_594066 = validateParameter(valid_594066, JString, required = true,
                                 default = nil)
  if valid_594066 != nil:
    section.add "resourceGroupName", valid_594066
  var valid_594067 = path.getOrDefault("apiId")
  valid_594067 = validateParameter(valid_594067, JString, required = true,
                                 default = nil)
  if valid_594067 != nil:
    section.add "apiId", valid_594067
  var valid_594068 = path.getOrDefault("subscriptionId")
  valid_594068 = validateParameter(valid_594068, JString, required = true,
                                 default = nil)
  if valid_594068 != nil:
    section.add "subscriptionId", valid_594068
  var valid_594069 = path.getOrDefault("serviceName")
  valid_594069 = validateParameter(valid_594069, JString, required = true,
                                 default = nil)
  if valid_594069 != nil:
    section.add "serviceName", valid_594069
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : Number of records to return.
  ##   $skip: JInt
  ##        : Number of records to skip.
  ##   $filter: JString
  ##          : | Field       | Supported operators    | Supported functions               |
  ## |-------------|------------------------|-----------------------------------|
  ## | id          | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594070 = query.getOrDefault("api-version")
  valid_594070 = validateParameter(valid_594070, JString, required = true,
                                 default = nil)
  if valid_594070 != nil:
    section.add "api-version", valid_594070
  var valid_594071 = query.getOrDefault("$top")
  valid_594071 = validateParameter(valid_594071, JInt, required = false, default = nil)
  if valid_594071 != nil:
    section.add "$top", valid_594071
  var valid_594072 = query.getOrDefault("$skip")
  valid_594072 = validateParameter(valid_594072, JInt, required = false, default = nil)
  if valid_594072 != nil:
    section.add "$skip", valid_594072
  var valid_594073 = query.getOrDefault("$filter")
  valid_594073 = validateParameter(valid_594073, JString, required = false,
                                 default = nil)
  if valid_594073 != nil:
    section.add "$filter", valid_594073
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594074: Call_ApiDiagnosticListByService_594063; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all diagnostics of an API.
  ## 
  let valid = call_594074.validator(path, query, header, formData, body)
  let scheme = call_594074.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594074.url(scheme.get, call_594074.host, call_594074.base,
                         call_594074.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594074, url, valid)

proc call*(call_594075: Call_ApiDiagnosticListByService_594063;
          resourceGroupName: string; apiVersion: string; apiId: string;
          subscriptionId: string; serviceName: string; Top: int = 0; Skip: int = 0;
          Filter: string = ""): Recallable =
  ## apiDiagnosticListByService
  ## Lists all diagnostics of an API.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : Number of records to return.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   Filter: string
  ##         : | Field       | Supported operators    | Supported functions               |
  ## |-------------|------------------------|-----------------------------------|
  ## | id          | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  var path_594076 = newJObject()
  var query_594077 = newJObject()
  add(path_594076, "resourceGroupName", newJString(resourceGroupName))
  add(query_594077, "api-version", newJString(apiVersion))
  add(path_594076, "apiId", newJString(apiId))
  add(path_594076, "subscriptionId", newJString(subscriptionId))
  add(query_594077, "$top", newJInt(Top))
  add(query_594077, "$skip", newJInt(Skip))
  add(path_594076, "serviceName", newJString(serviceName))
  add(query_594077, "$filter", newJString(Filter))
  result = call_594075.call(path_594076, query_594077, nil, nil, nil)

var apiDiagnosticListByService* = Call_ApiDiagnosticListByService_594063(
    name: "apiDiagnosticListByService", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/diagnostics",
    validator: validate_ApiDiagnosticListByService_594064, base: "",
    url: url_ApiDiagnosticListByService_594065, schemes: {Scheme.Https})
type
  Call_ApiDiagnosticCreateOrUpdate_594091 = ref object of OpenApiRestCall_593425
proc url_ApiDiagnosticCreateOrUpdate_594093(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "diagnosticId" in path, "`diagnosticId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/diagnostics/"),
               (kind: VariableSegment, value: "diagnosticId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiDiagnosticCreateOrUpdate_594092(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new Diagnostic for an API or updates an existing one.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   diagnosticId: JString (required)
  ##               : Diagnostic identifier. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594094 = path.getOrDefault("resourceGroupName")
  valid_594094 = validateParameter(valid_594094, JString, required = true,
                                 default = nil)
  if valid_594094 != nil:
    section.add "resourceGroupName", valid_594094
  var valid_594095 = path.getOrDefault("apiId")
  valid_594095 = validateParameter(valid_594095, JString, required = true,
                                 default = nil)
  if valid_594095 != nil:
    section.add "apiId", valid_594095
  var valid_594096 = path.getOrDefault("subscriptionId")
  valid_594096 = validateParameter(valid_594096, JString, required = true,
                                 default = nil)
  if valid_594096 != nil:
    section.add "subscriptionId", valid_594096
  var valid_594097 = path.getOrDefault("diagnosticId")
  valid_594097 = validateParameter(valid_594097, JString, required = true,
                                 default = nil)
  if valid_594097 != nil:
    section.add "diagnosticId", valid_594097
  var valid_594098 = path.getOrDefault("serviceName")
  valid_594098 = validateParameter(valid_594098, JString, required = true,
                                 default = nil)
  if valid_594098 != nil:
    section.add "serviceName", valid_594098
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594099 = query.getOrDefault("api-version")
  valid_594099 = validateParameter(valid_594099, JString, required = true,
                                 default = nil)
  if valid_594099 != nil:
    section.add "api-version", valid_594099
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the Diagnostic Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  var valid_594100 = header.getOrDefault("If-Match")
  valid_594100 = validateParameter(valid_594100, JString, required = false,
                                 default = nil)
  if valid_594100 != nil:
    section.add "If-Match", valid_594100
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

proc call*(call_594102: Call_ApiDiagnosticCreateOrUpdate_594091; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new Diagnostic for an API or updates an existing one.
  ## 
  let valid = call_594102.validator(path, query, header, formData, body)
  let scheme = call_594102.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594102.url(scheme.get, call_594102.host, call_594102.base,
                         call_594102.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594102, url, valid)

proc call*(call_594103: Call_ApiDiagnosticCreateOrUpdate_594091;
          resourceGroupName: string; apiVersion: string; apiId: string;
          subscriptionId: string; diagnosticId: string; parameters: JsonNode;
          serviceName: string): Recallable =
  ## apiDiagnosticCreateOrUpdate
  ## Creates a new Diagnostic for an API or updates an existing one.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   diagnosticId: string (required)
  ##               : Diagnostic identifier. Must be unique in the current API Management service instance.
  ##   parameters: JObject (required)
  ##             : Create parameters.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594104 = newJObject()
  var query_594105 = newJObject()
  var body_594106 = newJObject()
  add(path_594104, "resourceGroupName", newJString(resourceGroupName))
  add(query_594105, "api-version", newJString(apiVersion))
  add(path_594104, "apiId", newJString(apiId))
  add(path_594104, "subscriptionId", newJString(subscriptionId))
  add(path_594104, "diagnosticId", newJString(diagnosticId))
  if parameters != nil:
    body_594106 = parameters
  add(path_594104, "serviceName", newJString(serviceName))
  result = call_594103.call(path_594104, query_594105, nil, nil, body_594106)

var apiDiagnosticCreateOrUpdate* = Call_ApiDiagnosticCreateOrUpdate_594091(
    name: "apiDiagnosticCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/diagnostics/{diagnosticId}",
    validator: validate_ApiDiagnosticCreateOrUpdate_594092, base: "",
    url: url_ApiDiagnosticCreateOrUpdate_594093, schemes: {Scheme.Https})
type
  Call_ApiDiagnosticHead_594121 = ref object of OpenApiRestCall_593425
proc url_ApiDiagnosticHead_594123(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "diagnosticId" in path, "`diagnosticId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/diagnostics/"),
               (kind: VariableSegment, value: "diagnosticId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiDiagnosticHead_594122(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets the entity state (Etag) version of the Diagnostic for an API specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   diagnosticId: JString (required)
  ##               : Diagnostic identifier. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594124 = path.getOrDefault("resourceGroupName")
  valid_594124 = validateParameter(valid_594124, JString, required = true,
                                 default = nil)
  if valid_594124 != nil:
    section.add "resourceGroupName", valid_594124
  var valid_594125 = path.getOrDefault("apiId")
  valid_594125 = validateParameter(valid_594125, JString, required = true,
                                 default = nil)
  if valid_594125 != nil:
    section.add "apiId", valid_594125
  var valid_594126 = path.getOrDefault("subscriptionId")
  valid_594126 = validateParameter(valid_594126, JString, required = true,
                                 default = nil)
  if valid_594126 != nil:
    section.add "subscriptionId", valid_594126
  var valid_594127 = path.getOrDefault("diagnosticId")
  valid_594127 = validateParameter(valid_594127, JString, required = true,
                                 default = nil)
  if valid_594127 != nil:
    section.add "diagnosticId", valid_594127
  var valid_594128 = path.getOrDefault("serviceName")
  valid_594128 = validateParameter(valid_594128, JString, required = true,
                                 default = nil)
  if valid_594128 != nil:
    section.add "serviceName", valid_594128
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594129 = query.getOrDefault("api-version")
  valid_594129 = validateParameter(valid_594129, JString, required = true,
                                 default = nil)
  if valid_594129 != nil:
    section.add "api-version", valid_594129
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594130: Call_ApiDiagnosticHead_594121; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the entity state (Etag) version of the Diagnostic for an API specified by its identifier.
  ## 
  let valid = call_594130.validator(path, query, header, formData, body)
  let scheme = call_594130.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594130.url(scheme.get, call_594130.host, call_594130.base,
                         call_594130.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594130, url, valid)

proc call*(call_594131: Call_ApiDiagnosticHead_594121; resourceGroupName: string;
          apiVersion: string; apiId: string; subscriptionId: string;
          diagnosticId: string; serviceName: string): Recallable =
  ## apiDiagnosticHead
  ## Gets the entity state (Etag) version of the Diagnostic for an API specified by its identifier.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   diagnosticId: string (required)
  ##               : Diagnostic identifier. Must be unique in the current API Management service instance.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594132 = newJObject()
  var query_594133 = newJObject()
  add(path_594132, "resourceGroupName", newJString(resourceGroupName))
  add(query_594133, "api-version", newJString(apiVersion))
  add(path_594132, "apiId", newJString(apiId))
  add(path_594132, "subscriptionId", newJString(subscriptionId))
  add(path_594132, "diagnosticId", newJString(diagnosticId))
  add(path_594132, "serviceName", newJString(serviceName))
  result = call_594131.call(path_594132, query_594133, nil, nil, nil)

var apiDiagnosticHead* = Call_ApiDiagnosticHead_594121(name: "apiDiagnosticHead",
    meth: HttpMethod.HttpHead, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/diagnostics/{diagnosticId}",
    validator: validate_ApiDiagnosticHead_594122, base: "",
    url: url_ApiDiagnosticHead_594123, schemes: {Scheme.Https})
type
  Call_ApiDiagnosticGet_594078 = ref object of OpenApiRestCall_593425
proc url_ApiDiagnosticGet_594080(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "diagnosticId" in path, "`diagnosticId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/diagnostics/"),
               (kind: VariableSegment, value: "diagnosticId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiDiagnosticGet_594079(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Gets the details of the Diagnostic for an API specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   diagnosticId: JString (required)
  ##               : Diagnostic identifier. Must be unique in the current API Management service instance.
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
  var valid_594082 = path.getOrDefault("apiId")
  valid_594082 = validateParameter(valid_594082, JString, required = true,
                                 default = nil)
  if valid_594082 != nil:
    section.add "apiId", valid_594082
  var valid_594083 = path.getOrDefault("subscriptionId")
  valid_594083 = validateParameter(valid_594083, JString, required = true,
                                 default = nil)
  if valid_594083 != nil:
    section.add "subscriptionId", valid_594083
  var valid_594084 = path.getOrDefault("diagnosticId")
  valid_594084 = validateParameter(valid_594084, JString, required = true,
                                 default = nil)
  if valid_594084 != nil:
    section.add "diagnosticId", valid_594084
  var valid_594085 = path.getOrDefault("serviceName")
  valid_594085 = validateParameter(valid_594085, JString, required = true,
                                 default = nil)
  if valid_594085 != nil:
    section.add "serviceName", valid_594085
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594086 = query.getOrDefault("api-version")
  valid_594086 = validateParameter(valid_594086, JString, required = true,
                                 default = nil)
  if valid_594086 != nil:
    section.add "api-version", valid_594086
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594087: Call_ApiDiagnosticGet_594078; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the Diagnostic for an API specified by its identifier.
  ## 
  let valid = call_594087.validator(path, query, header, formData, body)
  let scheme = call_594087.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594087.url(scheme.get, call_594087.host, call_594087.base,
                         call_594087.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594087, url, valid)

proc call*(call_594088: Call_ApiDiagnosticGet_594078; resourceGroupName: string;
          apiVersion: string; apiId: string; subscriptionId: string;
          diagnosticId: string; serviceName: string): Recallable =
  ## apiDiagnosticGet
  ## Gets the details of the Diagnostic for an API specified by its identifier.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   diagnosticId: string (required)
  ##               : Diagnostic identifier. Must be unique in the current API Management service instance.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594089 = newJObject()
  var query_594090 = newJObject()
  add(path_594089, "resourceGroupName", newJString(resourceGroupName))
  add(query_594090, "api-version", newJString(apiVersion))
  add(path_594089, "apiId", newJString(apiId))
  add(path_594089, "subscriptionId", newJString(subscriptionId))
  add(path_594089, "diagnosticId", newJString(diagnosticId))
  add(path_594089, "serviceName", newJString(serviceName))
  result = call_594088.call(path_594089, query_594090, nil, nil, nil)

var apiDiagnosticGet* = Call_ApiDiagnosticGet_594078(name: "apiDiagnosticGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/diagnostics/{diagnosticId}",
    validator: validate_ApiDiagnosticGet_594079, base: "",
    url: url_ApiDiagnosticGet_594080, schemes: {Scheme.Https})
type
  Call_ApiDiagnosticUpdate_594134 = ref object of OpenApiRestCall_593425
proc url_ApiDiagnosticUpdate_594136(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "diagnosticId" in path, "`diagnosticId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/diagnostics/"),
               (kind: VariableSegment, value: "diagnosticId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiDiagnosticUpdate_594135(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Updates the details of the Diagnostic for an API specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   diagnosticId: JString (required)
  ##               : Diagnostic identifier. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594137 = path.getOrDefault("resourceGroupName")
  valid_594137 = validateParameter(valid_594137, JString, required = true,
                                 default = nil)
  if valid_594137 != nil:
    section.add "resourceGroupName", valid_594137
  var valid_594138 = path.getOrDefault("apiId")
  valid_594138 = validateParameter(valid_594138, JString, required = true,
                                 default = nil)
  if valid_594138 != nil:
    section.add "apiId", valid_594138
  var valid_594139 = path.getOrDefault("subscriptionId")
  valid_594139 = validateParameter(valid_594139, JString, required = true,
                                 default = nil)
  if valid_594139 != nil:
    section.add "subscriptionId", valid_594139
  var valid_594140 = path.getOrDefault("diagnosticId")
  valid_594140 = validateParameter(valid_594140, JString, required = true,
                                 default = nil)
  if valid_594140 != nil:
    section.add "diagnosticId", valid_594140
  var valid_594141 = path.getOrDefault("serviceName")
  valid_594141 = validateParameter(valid_594141, JString, required = true,
                                 default = nil)
  if valid_594141 != nil:
    section.add "serviceName", valid_594141
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594142 = query.getOrDefault("api-version")
  valid_594142 = validateParameter(valid_594142, JString, required = true,
                                 default = nil)
  if valid_594142 != nil:
    section.add "api-version", valid_594142
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Diagnostic Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_594143 = header.getOrDefault("If-Match")
  valid_594143 = validateParameter(valid_594143, JString, required = true,
                                 default = nil)
  if valid_594143 != nil:
    section.add "If-Match", valid_594143
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Diagnostic Update parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594145: Call_ApiDiagnosticUpdate_594134; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the details of the Diagnostic for an API specified by its identifier.
  ## 
  let valid = call_594145.validator(path, query, header, formData, body)
  let scheme = call_594145.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594145.url(scheme.get, call_594145.host, call_594145.base,
                         call_594145.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594145, url, valid)

proc call*(call_594146: Call_ApiDiagnosticUpdate_594134; resourceGroupName: string;
          apiVersion: string; apiId: string; subscriptionId: string;
          diagnosticId: string; parameters: JsonNode; serviceName: string): Recallable =
  ## apiDiagnosticUpdate
  ## Updates the details of the Diagnostic for an API specified by its identifier.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   diagnosticId: string (required)
  ##               : Diagnostic identifier. Must be unique in the current API Management service instance.
  ##   parameters: JObject (required)
  ##             : Diagnostic Update parameters.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594147 = newJObject()
  var query_594148 = newJObject()
  var body_594149 = newJObject()
  add(path_594147, "resourceGroupName", newJString(resourceGroupName))
  add(query_594148, "api-version", newJString(apiVersion))
  add(path_594147, "apiId", newJString(apiId))
  add(path_594147, "subscriptionId", newJString(subscriptionId))
  add(path_594147, "diagnosticId", newJString(diagnosticId))
  if parameters != nil:
    body_594149 = parameters
  add(path_594147, "serviceName", newJString(serviceName))
  result = call_594146.call(path_594147, query_594148, nil, nil, body_594149)

var apiDiagnosticUpdate* = Call_ApiDiagnosticUpdate_594134(
    name: "apiDiagnosticUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/diagnostics/{diagnosticId}",
    validator: validate_ApiDiagnosticUpdate_594135, base: "",
    url: url_ApiDiagnosticUpdate_594136, schemes: {Scheme.Https})
type
  Call_ApiDiagnosticDelete_594107 = ref object of OpenApiRestCall_593425
proc url_ApiDiagnosticDelete_594109(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "diagnosticId" in path, "`diagnosticId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/diagnostics/"),
               (kind: VariableSegment, value: "diagnosticId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiDiagnosticDelete_594108(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Deletes the specified Diagnostic from an API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   diagnosticId: JString (required)
  ##               : Diagnostic identifier. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594110 = path.getOrDefault("resourceGroupName")
  valid_594110 = validateParameter(valid_594110, JString, required = true,
                                 default = nil)
  if valid_594110 != nil:
    section.add "resourceGroupName", valid_594110
  var valid_594111 = path.getOrDefault("apiId")
  valid_594111 = validateParameter(valid_594111, JString, required = true,
                                 default = nil)
  if valid_594111 != nil:
    section.add "apiId", valid_594111
  var valid_594112 = path.getOrDefault("subscriptionId")
  valid_594112 = validateParameter(valid_594112, JString, required = true,
                                 default = nil)
  if valid_594112 != nil:
    section.add "subscriptionId", valid_594112
  var valid_594113 = path.getOrDefault("diagnosticId")
  valid_594113 = validateParameter(valid_594113, JString, required = true,
                                 default = nil)
  if valid_594113 != nil:
    section.add "diagnosticId", valid_594113
  var valid_594114 = path.getOrDefault("serviceName")
  valid_594114 = validateParameter(valid_594114, JString, required = true,
                                 default = nil)
  if valid_594114 != nil:
    section.add "serviceName", valid_594114
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594115 = query.getOrDefault("api-version")
  valid_594115 = validateParameter(valid_594115, JString, required = true,
                                 default = nil)
  if valid_594115 != nil:
    section.add "api-version", valid_594115
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Diagnostic Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_594116 = header.getOrDefault("If-Match")
  valid_594116 = validateParameter(valid_594116, JString, required = true,
                                 default = nil)
  if valid_594116 != nil:
    section.add "If-Match", valid_594116
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594117: Call_ApiDiagnosticDelete_594107; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified Diagnostic from an API.
  ## 
  let valid = call_594117.validator(path, query, header, formData, body)
  let scheme = call_594117.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594117.url(scheme.get, call_594117.host, call_594117.base,
                         call_594117.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594117, url, valid)

proc call*(call_594118: Call_ApiDiagnosticDelete_594107; resourceGroupName: string;
          apiVersion: string; apiId: string; subscriptionId: string;
          diagnosticId: string; serviceName: string): Recallable =
  ## apiDiagnosticDelete
  ## Deletes the specified Diagnostic from an API.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   diagnosticId: string (required)
  ##               : Diagnostic identifier. Must be unique in the current API Management service instance.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594119 = newJObject()
  var query_594120 = newJObject()
  add(path_594119, "resourceGroupName", newJString(resourceGroupName))
  add(query_594120, "api-version", newJString(apiVersion))
  add(path_594119, "apiId", newJString(apiId))
  add(path_594119, "subscriptionId", newJString(subscriptionId))
  add(path_594119, "diagnosticId", newJString(diagnosticId))
  add(path_594119, "serviceName", newJString(serviceName))
  result = call_594118.call(path_594119, query_594120, nil, nil, nil)

var apiDiagnosticDelete* = Call_ApiDiagnosticDelete_594107(
    name: "apiDiagnosticDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/diagnostics/{diagnosticId}",
    validator: validate_ApiDiagnosticDelete_594108, base: "",
    url: url_ApiDiagnosticDelete_594109, schemes: {Scheme.Https})
type
  Call_ApiDiagnosticLoggerListByService_594150 = ref object of OpenApiRestCall_593425
proc url_ApiDiagnosticLoggerListByService_594152(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "diagnosticId" in path, "`diagnosticId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/diagnostics/"),
               (kind: VariableSegment, value: "diagnosticId"),
               (kind: ConstantSegment, value: "/loggers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiDiagnosticLoggerListByService_594151(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all loggers associated with the specified Diagnostic of an API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   diagnosticId: JString (required)
  ##               : Diagnostic identifier. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594153 = path.getOrDefault("resourceGroupName")
  valid_594153 = validateParameter(valid_594153, JString, required = true,
                                 default = nil)
  if valid_594153 != nil:
    section.add "resourceGroupName", valid_594153
  var valid_594154 = path.getOrDefault("apiId")
  valid_594154 = validateParameter(valid_594154, JString, required = true,
                                 default = nil)
  if valid_594154 != nil:
    section.add "apiId", valid_594154
  var valid_594155 = path.getOrDefault("subscriptionId")
  valid_594155 = validateParameter(valid_594155, JString, required = true,
                                 default = nil)
  if valid_594155 != nil:
    section.add "subscriptionId", valid_594155
  var valid_594156 = path.getOrDefault("diagnosticId")
  valid_594156 = validateParameter(valid_594156, JString, required = true,
                                 default = nil)
  if valid_594156 != nil:
    section.add "diagnosticId", valid_594156
  var valid_594157 = path.getOrDefault("serviceName")
  valid_594157 = validateParameter(valid_594157, JString, required = true,
                                 default = nil)
  if valid_594157 != nil:
    section.add "serviceName", valid_594157
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : Number of records to return.
  ##   $skip: JInt
  ##        : Number of records to skip.
  ##   $filter: JString
  ##          : | Field       | Supported operators    | Supported functions               |
  ## |-------------|------------------------|-----------------------------------|
  ## | id          | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  ## | type        | eq                     |                                   |
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594158 = query.getOrDefault("api-version")
  valid_594158 = validateParameter(valid_594158, JString, required = true,
                                 default = nil)
  if valid_594158 != nil:
    section.add "api-version", valid_594158
  var valid_594159 = query.getOrDefault("$top")
  valid_594159 = validateParameter(valid_594159, JInt, required = false, default = nil)
  if valid_594159 != nil:
    section.add "$top", valid_594159
  var valid_594160 = query.getOrDefault("$skip")
  valid_594160 = validateParameter(valid_594160, JInt, required = false, default = nil)
  if valid_594160 != nil:
    section.add "$skip", valid_594160
  var valid_594161 = query.getOrDefault("$filter")
  valid_594161 = validateParameter(valid_594161, JString, required = false,
                                 default = nil)
  if valid_594161 != nil:
    section.add "$filter", valid_594161
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594162: Call_ApiDiagnosticLoggerListByService_594150;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all loggers associated with the specified Diagnostic of an API.
  ## 
  let valid = call_594162.validator(path, query, header, formData, body)
  let scheme = call_594162.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594162.url(scheme.get, call_594162.host, call_594162.base,
                         call_594162.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594162, url, valid)

proc call*(call_594163: Call_ApiDiagnosticLoggerListByService_594150;
          resourceGroupName: string; apiVersion: string; apiId: string;
          subscriptionId: string; diagnosticId: string; serviceName: string;
          Top: int = 0; Skip: int = 0; Filter: string = ""): Recallable =
  ## apiDiagnosticLoggerListByService
  ## Lists all loggers associated with the specified Diagnostic of an API.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : Number of records to return.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   diagnosticId: string (required)
  ##               : Diagnostic identifier. Must be unique in the current API Management service instance.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   Filter: string
  ##         : | Field       | Supported operators    | Supported functions               |
  ## |-------------|------------------------|-----------------------------------|
  ## | id          | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  ## | type        | eq                     |                                   |
  var path_594164 = newJObject()
  var query_594165 = newJObject()
  add(path_594164, "resourceGroupName", newJString(resourceGroupName))
  add(query_594165, "api-version", newJString(apiVersion))
  add(path_594164, "apiId", newJString(apiId))
  add(path_594164, "subscriptionId", newJString(subscriptionId))
  add(query_594165, "$top", newJInt(Top))
  add(query_594165, "$skip", newJInt(Skip))
  add(path_594164, "diagnosticId", newJString(diagnosticId))
  add(path_594164, "serviceName", newJString(serviceName))
  add(query_594165, "$filter", newJString(Filter))
  result = call_594163.call(path_594164, query_594165, nil, nil, nil)

var apiDiagnosticLoggerListByService* = Call_ApiDiagnosticLoggerListByService_594150(
    name: "apiDiagnosticLoggerListByService", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/diagnostics/{diagnosticId}/loggers",
    validator: validate_ApiDiagnosticLoggerListByService_594151, base: "",
    url: url_ApiDiagnosticLoggerListByService_594152, schemes: {Scheme.Https})
type
  Call_ApiDiagnosticLoggerCreateOrUpdate_594166 = ref object of OpenApiRestCall_593425
proc url_ApiDiagnosticLoggerCreateOrUpdate_594168(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "diagnosticId" in path, "`diagnosticId` is a required path parameter"
  assert "loggerid" in path, "`loggerid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/diagnostics/"),
               (kind: VariableSegment, value: "diagnosticId"),
               (kind: ConstantSegment, value: "/loggers/"),
               (kind: VariableSegment, value: "loggerid")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiDiagnosticLoggerCreateOrUpdate_594167(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Attaches a logger to a diagnostic for an API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   loggerid: JString (required)
  ##           : Logger identifier. Must be unique in the API Management service instance.
  ##   diagnosticId: JString (required)
  ##               : Diagnostic identifier. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594169 = path.getOrDefault("resourceGroupName")
  valid_594169 = validateParameter(valid_594169, JString, required = true,
                                 default = nil)
  if valid_594169 != nil:
    section.add "resourceGroupName", valid_594169
  var valid_594170 = path.getOrDefault("apiId")
  valid_594170 = validateParameter(valid_594170, JString, required = true,
                                 default = nil)
  if valid_594170 != nil:
    section.add "apiId", valid_594170
  var valid_594171 = path.getOrDefault("subscriptionId")
  valid_594171 = validateParameter(valid_594171, JString, required = true,
                                 default = nil)
  if valid_594171 != nil:
    section.add "subscriptionId", valid_594171
  var valid_594172 = path.getOrDefault("loggerid")
  valid_594172 = validateParameter(valid_594172, JString, required = true,
                                 default = nil)
  if valid_594172 != nil:
    section.add "loggerid", valid_594172
  var valid_594173 = path.getOrDefault("diagnosticId")
  valid_594173 = validateParameter(valid_594173, JString, required = true,
                                 default = nil)
  if valid_594173 != nil:
    section.add "diagnosticId", valid_594173
  var valid_594174 = path.getOrDefault("serviceName")
  valid_594174 = validateParameter(valid_594174, JString, required = true,
                                 default = nil)
  if valid_594174 != nil:
    section.add "serviceName", valid_594174
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594175 = query.getOrDefault("api-version")
  valid_594175 = validateParameter(valid_594175, JString, required = true,
                                 default = nil)
  if valid_594175 != nil:
    section.add "api-version", valid_594175
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594176: Call_ApiDiagnosticLoggerCreateOrUpdate_594166;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Attaches a logger to a diagnostic for an API.
  ## 
  let valid = call_594176.validator(path, query, header, formData, body)
  let scheme = call_594176.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594176.url(scheme.get, call_594176.host, call_594176.base,
                         call_594176.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594176, url, valid)

proc call*(call_594177: Call_ApiDiagnosticLoggerCreateOrUpdate_594166;
          resourceGroupName: string; apiVersion: string; apiId: string;
          subscriptionId: string; loggerid: string; diagnosticId: string;
          serviceName: string): Recallable =
  ## apiDiagnosticLoggerCreateOrUpdate
  ## Attaches a logger to a diagnostic for an API.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   loggerid: string (required)
  ##           : Logger identifier. Must be unique in the API Management service instance.
  ##   diagnosticId: string (required)
  ##               : Diagnostic identifier. Must be unique in the current API Management service instance.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594178 = newJObject()
  var query_594179 = newJObject()
  add(path_594178, "resourceGroupName", newJString(resourceGroupName))
  add(query_594179, "api-version", newJString(apiVersion))
  add(path_594178, "apiId", newJString(apiId))
  add(path_594178, "subscriptionId", newJString(subscriptionId))
  add(path_594178, "loggerid", newJString(loggerid))
  add(path_594178, "diagnosticId", newJString(diagnosticId))
  add(path_594178, "serviceName", newJString(serviceName))
  result = call_594177.call(path_594178, query_594179, nil, nil, nil)

var apiDiagnosticLoggerCreateOrUpdate* = Call_ApiDiagnosticLoggerCreateOrUpdate_594166(
    name: "apiDiagnosticLoggerCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/diagnostics/{diagnosticId}/loggers/{loggerid}",
    validator: validate_ApiDiagnosticLoggerCreateOrUpdate_594167, base: "",
    url: url_ApiDiagnosticLoggerCreateOrUpdate_594168, schemes: {Scheme.Https})
type
  Call_ApiDiagnosticLoggerCheckEntityExists_594194 = ref object of OpenApiRestCall_593425
proc url_ApiDiagnosticLoggerCheckEntityExists_594196(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "diagnosticId" in path, "`diagnosticId` is a required path parameter"
  assert "loggerid" in path, "`loggerid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/diagnostics/"),
               (kind: VariableSegment, value: "diagnosticId"),
               (kind: ConstantSegment, value: "/loggers/"),
               (kind: VariableSegment, value: "loggerid")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiDiagnosticLoggerCheckEntityExists_594195(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks that logger entity specified by identifier is associated with the diagnostics entity.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   loggerid: JString (required)
  ##           : Logger identifier. Must be unique in the API Management service instance.
  ##   diagnosticId: JString (required)
  ##               : Diagnostic identifier. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594197 = path.getOrDefault("resourceGroupName")
  valid_594197 = validateParameter(valid_594197, JString, required = true,
                                 default = nil)
  if valid_594197 != nil:
    section.add "resourceGroupName", valid_594197
  var valid_594198 = path.getOrDefault("apiId")
  valid_594198 = validateParameter(valid_594198, JString, required = true,
                                 default = nil)
  if valid_594198 != nil:
    section.add "apiId", valid_594198
  var valid_594199 = path.getOrDefault("subscriptionId")
  valid_594199 = validateParameter(valid_594199, JString, required = true,
                                 default = nil)
  if valid_594199 != nil:
    section.add "subscriptionId", valid_594199
  var valid_594200 = path.getOrDefault("loggerid")
  valid_594200 = validateParameter(valid_594200, JString, required = true,
                                 default = nil)
  if valid_594200 != nil:
    section.add "loggerid", valid_594200
  var valid_594201 = path.getOrDefault("diagnosticId")
  valid_594201 = validateParameter(valid_594201, JString, required = true,
                                 default = nil)
  if valid_594201 != nil:
    section.add "diagnosticId", valid_594201
  var valid_594202 = path.getOrDefault("serviceName")
  valid_594202 = validateParameter(valid_594202, JString, required = true,
                                 default = nil)
  if valid_594202 != nil:
    section.add "serviceName", valid_594202
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594203 = query.getOrDefault("api-version")
  valid_594203 = validateParameter(valid_594203, JString, required = true,
                                 default = nil)
  if valid_594203 != nil:
    section.add "api-version", valid_594203
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594204: Call_ApiDiagnosticLoggerCheckEntityExists_594194;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Checks that logger entity specified by identifier is associated with the diagnostics entity.
  ## 
  let valid = call_594204.validator(path, query, header, formData, body)
  let scheme = call_594204.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594204.url(scheme.get, call_594204.host, call_594204.base,
                         call_594204.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594204, url, valid)

proc call*(call_594205: Call_ApiDiagnosticLoggerCheckEntityExists_594194;
          resourceGroupName: string; apiVersion: string; apiId: string;
          subscriptionId: string; loggerid: string; diagnosticId: string;
          serviceName: string): Recallable =
  ## apiDiagnosticLoggerCheckEntityExists
  ## Checks that logger entity specified by identifier is associated with the diagnostics entity.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   loggerid: string (required)
  ##           : Logger identifier. Must be unique in the API Management service instance.
  ##   diagnosticId: string (required)
  ##               : Diagnostic identifier. Must be unique in the current API Management service instance.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594206 = newJObject()
  var query_594207 = newJObject()
  add(path_594206, "resourceGroupName", newJString(resourceGroupName))
  add(query_594207, "api-version", newJString(apiVersion))
  add(path_594206, "apiId", newJString(apiId))
  add(path_594206, "subscriptionId", newJString(subscriptionId))
  add(path_594206, "loggerid", newJString(loggerid))
  add(path_594206, "diagnosticId", newJString(diagnosticId))
  add(path_594206, "serviceName", newJString(serviceName))
  result = call_594205.call(path_594206, query_594207, nil, nil, nil)

var apiDiagnosticLoggerCheckEntityExists* = Call_ApiDiagnosticLoggerCheckEntityExists_594194(
    name: "apiDiagnosticLoggerCheckEntityExists", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/diagnostics/{diagnosticId}/loggers/{loggerid}",
    validator: validate_ApiDiagnosticLoggerCheckEntityExists_594195, base: "",
    url: url_ApiDiagnosticLoggerCheckEntityExists_594196, schemes: {Scheme.Https})
type
  Call_ApiDiagnosticLoggerDelete_594180 = ref object of OpenApiRestCall_593425
proc url_ApiDiagnosticLoggerDelete_594182(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "diagnosticId" in path, "`diagnosticId` is a required path parameter"
  assert "loggerid" in path, "`loggerid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/diagnostics/"),
               (kind: VariableSegment, value: "diagnosticId"),
               (kind: ConstantSegment, value: "/loggers/"),
               (kind: VariableSegment, value: "loggerid")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiDiagnosticLoggerDelete_594181(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified Logger from Diagnostic for an API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   loggerid: JString (required)
  ##           : Logger identifier. Must be unique in the API Management service instance.
  ##   diagnosticId: JString (required)
  ##               : Diagnostic identifier. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594183 = path.getOrDefault("resourceGroupName")
  valid_594183 = validateParameter(valid_594183, JString, required = true,
                                 default = nil)
  if valid_594183 != nil:
    section.add "resourceGroupName", valid_594183
  var valid_594184 = path.getOrDefault("apiId")
  valid_594184 = validateParameter(valid_594184, JString, required = true,
                                 default = nil)
  if valid_594184 != nil:
    section.add "apiId", valid_594184
  var valid_594185 = path.getOrDefault("subscriptionId")
  valid_594185 = validateParameter(valid_594185, JString, required = true,
                                 default = nil)
  if valid_594185 != nil:
    section.add "subscriptionId", valid_594185
  var valid_594186 = path.getOrDefault("loggerid")
  valid_594186 = validateParameter(valid_594186, JString, required = true,
                                 default = nil)
  if valid_594186 != nil:
    section.add "loggerid", valid_594186
  var valid_594187 = path.getOrDefault("diagnosticId")
  valid_594187 = validateParameter(valid_594187, JString, required = true,
                                 default = nil)
  if valid_594187 != nil:
    section.add "diagnosticId", valid_594187
  var valid_594188 = path.getOrDefault("serviceName")
  valid_594188 = validateParameter(valid_594188, JString, required = true,
                                 default = nil)
  if valid_594188 != nil:
    section.add "serviceName", valid_594188
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594189 = query.getOrDefault("api-version")
  valid_594189 = validateParameter(valid_594189, JString, required = true,
                                 default = nil)
  if valid_594189 != nil:
    section.add "api-version", valid_594189
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594190: Call_ApiDiagnosticLoggerDelete_594180; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified Logger from Diagnostic for an API.
  ## 
  let valid = call_594190.validator(path, query, header, formData, body)
  let scheme = call_594190.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594190.url(scheme.get, call_594190.host, call_594190.base,
                         call_594190.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594190, url, valid)

proc call*(call_594191: Call_ApiDiagnosticLoggerDelete_594180;
          resourceGroupName: string; apiVersion: string; apiId: string;
          subscriptionId: string; loggerid: string; diagnosticId: string;
          serviceName: string): Recallable =
  ## apiDiagnosticLoggerDelete
  ## Deletes the specified Logger from Diagnostic for an API.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   loggerid: string (required)
  ##           : Logger identifier. Must be unique in the API Management service instance.
  ##   diagnosticId: string (required)
  ##               : Diagnostic identifier. Must be unique in the current API Management service instance.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594192 = newJObject()
  var query_594193 = newJObject()
  add(path_594192, "resourceGroupName", newJString(resourceGroupName))
  add(query_594193, "api-version", newJString(apiVersion))
  add(path_594192, "apiId", newJString(apiId))
  add(path_594192, "subscriptionId", newJString(subscriptionId))
  add(path_594192, "loggerid", newJString(loggerid))
  add(path_594192, "diagnosticId", newJString(diagnosticId))
  add(path_594192, "serviceName", newJString(serviceName))
  result = call_594191.call(path_594192, query_594193, nil, nil, nil)

var apiDiagnosticLoggerDelete* = Call_ApiDiagnosticLoggerDelete_594180(
    name: "apiDiagnosticLoggerDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/diagnostics/{diagnosticId}/loggers/{loggerid}",
    validator: validate_ApiDiagnosticLoggerDelete_594181, base: "",
    url: url_ApiDiagnosticLoggerDelete_594182, schemes: {Scheme.Https})
type
  Call_ApiIssuesListByService_594208 = ref object of OpenApiRestCall_593425
proc url_ApiIssuesListByService_594210(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/issues")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiIssuesListByService_594209(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all issues associated with the specified API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594211 = path.getOrDefault("resourceGroupName")
  valid_594211 = validateParameter(valid_594211, JString, required = true,
                                 default = nil)
  if valid_594211 != nil:
    section.add "resourceGroupName", valid_594211
  var valid_594212 = path.getOrDefault("apiId")
  valid_594212 = validateParameter(valid_594212, JString, required = true,
                                 default = nil)
  if valid_594212 != nil:
    section.add "apiId", valid_594212
  var valid_594213 = path.getOrDefault("subscriptionId")
  valid_594213 = validateParameter(valid_594213, JString, required = true,
                                 default = nil)
  if valid_594213 != nil:
    section.add "subscriptionId", valid_594213
  var valid_594214 = path.getOrDefault("serviceName")
  valid_594214 = validateParameter(valid_594214, JString, required = true,
                                 default = nil)
  if valid_594214 != nil:
    section.add "serviceName", valid_594214
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : Number of records to return.
  ##   $skip: JInt
  ##        : Number of records to skip.
  ##   $filter: JString
  ##          : | Field       | Supported operators    | Supported functions               |
  ## |-------------|------------------------|-----------------------------------|
  ## | id          | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  ## | state        | eq                     |                                   |
  ## | userId          | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594215 = query.getOrDefault("api-version")
  valid_594215 = validateParameter(valid_594215, JString, required = true,
                                 default = nil)
  if valid_594215 != nil:
    section.add "api-version", valid_594215
  var valid_594216 = query.getOrDefault("$top")
  valid_594216 = validateParameter(valid_594216, JInt, required = false, default = nil)
  if valid_594216 != nil:
    section.add "$top", valid_594216
  var valid_594217 = query.getOrDefault("$skip")
  valid_594217 = validateParameter(valid_594217, JInt, required = false, default = nil)
  if valid_594217 != nil:
    section.add "$skip", valid_594217
  var valid_594218 = query.getOrDefault("$filter")
  valid_594218 = validateParameter(valid_594218, JString, required = false,
                                 default = nil)
  if valid_594218 != nil:
    section.add "$filter", valid_594218
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594219: Call_ApiIssuesListByService_594208; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all issues associated with the specified API.
  ## 
  let valid = call_594219.validator(path, query, header, formData, body)
  let scheme = call_594219.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594219.url(scheme.get, call_594219.host, call_594219.base,
                         call_594219.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594219, url, valid)

proc call*(call_594220: Call_ApiIssuesListByService_594208;
          resourceGroupName: string; apiVersion: string; apiId: string;
          subscriptionId: string; serviceName: string; Top: int = 0; Skip: int = 0;
          Filter: string = ""): Recallable =
  ## apiIssuesListByService
  ## Lists all issues associated with the specified API.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : Number of records to return.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   Filter: string
  ##         : | Field       | Supported operators    | Supported functions               |
  ## |-------------|------------------------|-----------------------------------|
  ## | id          | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  ## | state        | eq                     |                                   |
  ## | userId          | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  var path_594221 = newJObject()
  var query_594222 = newJObject()
  add(path_594221, "resourceGroupName", newJString(resourceGroupName))
  add(query_594222, "api-version", newJString(apiVersion))
  add(path_594221, "apiId", newJString(apiId))
  add(path_594221, "subscriptionId", newJString(subscriptionId))
  add(query_594222, "$top", newJInt(Top))
  add(query_594222, "$skip", newJInt(Skip))
  add(path_594221, "serviceName", newJString(serviceName))
  add(query_594222, "$filter", newJString(Filter))
  result = call_594220.call(path_594221, query_594222, nil, nil, nil)

var apiIssuesListByService* = Call_ApiIssuesListByService_594208(
    name: "apiIssuesListByService", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/issues",
    validator: validate_ApiIssuesListByService_594209, base: "",
    url: url_ApiIssuesListByService_594210, schemes: {Scheme.Https})
type
  Call_ApiIssueCreateOrUpdate_594236 = ref object of OpenApiRestCall_593425
proc url_ApiIssueCreateOrUpdate_594238(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "issueId" in path, "`issueId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/issues/"),
               (kind: VariableSegment, value: "issueId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiIssueCreateOrUpdate_594237(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new Issue for an API or updates an existing one.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   issueId: JString (required)
  ##          : Issue identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594239 = path.getOrDefault("resourceGroupName")
  valid_594239 = validateParameter(valid_594239, JString, required = true,
                                 default = nil)
  if valid_594239 != nil:
    section.add "resourceGroupName", valid_594239
  var valid_594240 = path.getOrDefault("apiId")
  valid_594240 = validateParameter(valid_594240, JString, required = true,
                                 default = nil)
  if valid_594240 != nil:
    section.add "apiId", valid_594240
  var valid_594241 = path.getOrDefault("issueId")
  valid_594241 = validateParameter(valid_594241, JString, required = true,
                                 default = nil)
  if valid_594241 != nil:
    section.add "issueId", valid_594241
  var valid_594242 = path.getOrDefault("subscriptionId")
  valid_594242 = validateParameter(valid_594242, JString, required = true,
                                 default = nil)
  if valid_594242 != nil:
    section.add "subscriptionId", valid_594242
  var valid_594243 = path.getOrDefault("serviceName")
  valid_594243 = validateParameter(valid_594243, JString, required = true,
                                 default = nil)
  if valid_594243 != nil:
    section.add "serviceName", valid_594243
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594244 = query.getOrDefault("api-version")
  valid_594244 = validateParameter(valid_594244, JString, required = true,
                                 default = nil)
  if valid_594244 != nil:
    section.add "api-version", valid_594244
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the Issue Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  var valid_594245 = header.getOrDefault("If-Match")
  valid_594245 = validateParameter(valid_594245, JString, required = false,
                                 default = nil)
  if valid_594245 != nil:
    section.add "If-Match", valid_594245
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

proc call*(call_594247: Call_ApiIssueCreateOrUpdate_594236; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new Issue for an API or updates an existing one.
  ## 
  let valid = call_594247.validator(path, query, header, formData, body)
  let scheme = call_594247.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594247.url(scheme.get, call_594247.host, call_594247.base,
                         call_594247.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594247, url, valid)

proc call*(call_594248: Call_ApiIssueCreateOrUpdate_594236;
          resourceGroupName: string; apiVersion: string; apiId: string;
          issueId: string; subscriptionId: string; parameters: JsonNode;
          serviceName: string): Recallable =
  ## apiIssueCreateOrUpdate
  ## Creates a new Issue for an API or updates an existing one.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   issueId: string (required)
  ##          : Issue identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Create parameters.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594249 = newJObject()
  var query_594250 = newJObject()
  var body_594251 = newJObject()
  add(path_594249, "resourceGroupName", newJString(resourceGroupName))
  add(query_594250, "api-version", newJString(apiVersion))
  add(path_594249, "apiId", newJString(apiId))
  add(path_594249, "issueId", newJString(issueId))
  add(path_594249, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594251 = parameters
  add(path_594249, "serviceName", newJString(serviceName))
  result = call_594248.call(path_594249, query_594250, nil, nil, body_594251)

var apiIssueCreateOrUpdate* = Call_ApiIssueCreateOrUpdate_594236(
    name: "apiIssueCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/issues/{issueId}",
    validator: validate_ApiIssueCreateOrUpdate_594237, base: "",
    url: url_ApiIssueCreateOrUpdate_594238, schemes: {Scheme.Https})
type
  Call_ApiIssueHead_594266 = ref object of OpenApiRestCall_593425
proc url_ApiIssueHead_594268(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "issueId" in path, "`issueId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/issues/"),
               (kind: VariableSegment, value: "issueId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiIssueHead_594267(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the entity state (Etag) version of the Issue for an API specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   issueId: JString (required)
  ##          : Issue identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594269 = path.getOrDefault("resourceGroupName")
  valid_594269 = validateParameter(valid_594269, JString, required = true,
                                 default = nil)
  if valid_594269 != nil:
    section.add "resourceGroupName", valid_594269
  var valid_594270 = path.getOrDefault("apiId")
  valid_594270 = validateParameter(valid_594270, JString, required = true,
                                 default = nil)
  if valid_594270 != nil:
    section.add "apiId", valid_594270
  var valid_594271 = path.getOrDefault("issueId")
  valid_594271 = validateParameter(valid_594271, JString, required = true,
                                 default = nil)
  if valid_594271 != nil:
    section.add "issueId", valid_594271
  var valid_594272 = path.getOrDefault("subscriptionId")
  valid_594272 = validateParameter(valid_594272, JString, required = true,
                                 default = nil)
  if valid_594272 != nil:
    section.add "subscriptionId", valid_594272
  var valid_594273 = path.getOrDefault("serviceName")
  valid_594273 = validateParameter(valid_594273, JString, required = true,
                                 default = nil)
  if valid_594273 != nil:
    section.add "serviceName", valid_594273
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594274 = query.getOrDefault("api-version")
  valid_594274 = validateParameter(valid_594274, JString, required = true,
                                 default = nil)
  if valid_594274 != nil:
    section.add "api-version", valid_594274
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594275: Call_ApiIssueHead_594266; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the entity state (Etag) version of the Issue for an API specified by its identifier.
  ## 
  let valid = call_594275.validator(path, query, header, formData, body)
  let scheme = call_594275.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594275.url(scheme.get, call_594275.host, call_594275.base,
                         call_594275.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594275, url, valid)

proc call*(call_594276: Call_ApiIssueHead_594266; resourceGroupName: string;
          apiVersion: string; apiId: string; issueId: string; subscriptionId: string;
          serviceName: string): Recallable =
  ## apiIssueHead
  ## Gets the entity state (Etag) version of the Issue for an API specified by its identifier.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   issueId: string (required)
  ##          : Issue identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594277 = newJObject()
  var query_594278 = newJObject()
  add(path_594277, "resourceGroupName", newJString(resourceGroupName))
  add(query_594278, "api-version", newJString(apiVersion))
  add(path_594277, "apiId", newJString(apiId))
  add(path_594277, "issueId", newJString(issueId))
  add(path_594277, "subscriptionId", newJString(subscriptionId))
  add(path_594277, "serviceName", newJString(serviceName))
  result = call_594276.call(path_594277, query_594278, nil, nil, nil)

var apiIssueHead* = Call_ApiIssueHead_594266(name: "apiIssueHead",
    meth: HttpMethod.HttpHead, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/issues/{issueId}",
    validator: validate_ApiIssueHead_594267, base: "", url: url_ApiIssueHead_594268,
    schemes: {Scheme.Https})
type
  Call_ApiIssueGet_594223 = ref object of OpenApiRestCall_593425
proc url_ApiIssueGet_594225(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "issueId" in path, "`issueId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/issues/"),
               (kind: VariableSegment, value: "issueId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiIssueGet_594224(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of the Issue for an API specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   issueId: JString (required)
  ##          : Issue identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594226 = path.getOrDefault("resourceGroupName")
  valid_594226 = validateParameter(valid_594226, JString, required = true,
                                 default = nil)
  if valid_594226 != nil:
    section.add "resourceGroupName", valid_594226
  var valid_594227 = path.getOrDefault("apiId")
  valid_594227 = validateParameter(valid_594227, JString, required = true,
                                 default = nil)
  if valid_594227 != nil:
    section.add "apiId", valid_594227
  var valid_594228 = path.getOrDefault("issueId")
  valid_594228 = validateParameter(valid_594228, JString, required = true,
                                 default = nil)
  if valid_594228 != nil:
    section.add "issueId", valid_594228
  var valid_594229 = path.getOrDefault("subscriptionId")
  valid_594229 = validateParameter(valid_594229, JString, required = true,
                                 default = nil)
  if valid_594229 != nil:
    section.add "subscriptionId", valid_594229
  var valid_594230 = path.getOrDefault("serviceName")
  valid_594230 = validateParameter(valid_594230, JString, required = true,
                                 default = nil)
  if valid_594230 != nil:
    section.add "serviceName", valid_594230
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594231 = query.getOrDefault("api-version")
  valid_594231 = validateParameter(valid_594231, JString, required = true,
                                 default = nil)
  if valid_594231 != nil:
    section.add "api-version", valid_594231
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594232: Call_ApiIssueGet_594223; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the Issue for an API specified by its identifier.
  ## 
  let valid = call_594232.validator(path, query, header, formData, body)
  let scheme = call_594232.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594232.url(scheme.get, call_594232.host, call_594232.base,
                         call_594232.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594232, url, valid)

proc call*(call_594233: Call_ApiIssueGet_594223; resourceGroupName: string;
          apiVersion: string; apiId: string; issueId: string; subscriptionId: string;
          serviceName: string): Recallable =
  ## apiIssueGet
  ## Gets the details of the Issue for an API specified by its identifier.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   issueId: string (required)
  ##          : Issue identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594234 = newJObject()
  var query_594235 = newJObject()
  add(path_594234, "resourceGroupName", newJString(resourceGroupName))
  add(query_594235, "api-version", newJString(apiVersion))
  add(path_594234, "apiId", newJString(apiId))
  add(path_594234, "issueId", newJString(issueId))
  add(path_594234, "subscriptionId", newJString(subscriptionId))
  add(path_594234, "serviceName", newJString(serviceName))
  result = call_594233.call(path_594234, query_594235, nil, nil, nil)

var apiIssueGet* = Call_ApiIssueGet_594223(name: "apiIssueGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/issues/{issueId}",
                                        validator: validate_ApiIssueGet_594224,
                                        base: "", url: url_ApiIssueGet_594225,
                                        schemes: {Scheme.Https})
type
  Call_ApiIssueDelete_594252 = ref object of OpenApiRestCall_593425
proc url_ApiIssueDelete_594254(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "issueId" in path, "`issueId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/issues/"),
               (kind: VariableSegment, value: "issueId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiIssueDelete_594253(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Deletes the specified Issue from an API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   issueId: JString (required)
  ##          : Issue identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594255 = path.getOrDefault("resourceGroupName")
  valid_594255 = validateParameter(valid_594255, JString, required = true,
                                 default = nil)
  if valid_594255 != nil:
    section.add "resourceGroupName", valid_594255
  var valid_594256 = path.getOrDefault("apiId")
  valid_594256 = validateParameter(valid_594256, JString, required = true,
                                 default = nil)
  if valid_594256 != nil:
    section.add "apiId", valid_594256
  var valid_594257 = path.getOrDefault("issueId")
  valid_594257 = validateParameter(valid_594257, JString, required = true,
                                 default = nil)
  if valid_594257 != nil:
    section.add "issueId", valid_594257
  var valid_594258 = path.getOrDefault("subscriptionId")
  valid_594258 = validateParameter(valid_594258, JString, required = true,
                                 default = nil)
  if valid_594258 != nil:
    section.add "subscriptionId", valid_594258
  var valid_594259 = path.getOrDefault("serviceName")
  valid_594259 = validateParameter(valid_594259, JString, required = true,
                                 default = nil)
  if valid_594259 != nil:
    section.add "serviceName", valid_594259
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594260 = query.getOrDefault("api-version")
  valid_594260 = validateParameter(valid_594260, JString, required = true,
                                 default = nil)
  if valid_594260 != nil:
    section.add "api-version", valid_594260
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Issue Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_594261 = header.getOrDefault("If-Match")
  valid_594261 = validateParameter(valid_594261, JString, required = true,
                                 default = nil)
  if valid_594261 != nil:
    section.add "If-Match", valid_594261
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594262: Call_ApiIssueDelete_594252; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified Issue from an API.
  ## 
  let valid = call_594262.validator(path, query, header, formData, body)
  let scheme = call_594262.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594262.url(scheme.get, call_594262.host, call_594262.base,
                         call_594262.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594262, url, valid)

proc call*(call_594263: Call_ApiIssueDelete_594252; resourceGroupName: string;
          apiVersion: string; apiId: string; issueId: string; subscriptionId: string;
          serviceName: string): Recallable =
  ## apiIssueDelete
  ## Deletes the specified Issue from an API.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   issueId: string (required)
  ##          : Issue identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594264 = newJObject()
  var query_594265 = newJObject()
  add(path_594264, "resourceGroupName", newJString(resourceGroupName))
  add(query_594265, "api-version", newJString(apiVersion))
  add(path_594264, "apiId", newJString(apiId))
  add(path_594264, "issueId", newJString(issueId))
  add(path_594264, "subscriptionId", newJString(subscriptionId))
  add(path_594264, "serviceName", newJString(serviceName))
  result = call_594263.call(path_594264, query_594265, nil, nil, nil)

var apiIssueDelete* = Call_ApiIssueDelete_594252(name: "apiIssueDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/issues/{issueId}",
    validator: validate_ApiIssueDelete_594253, base: "", url: url_ApiIssueDelete_594254,
    schemes: {Scheme.Https})
type
  Call_ApiIssueAttachmentsListByService_594279 = ref object of OpenApiRestCall_593425
proc url_ApiIssueAttachmentsListByService_594281(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "issueId" in path, "`issueId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/issues/"),
               (kind: VariableSegment, value: "issueId"),
               (kind: ConstantSegment, value: "/attachments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiIssueAttachmentsListByService_594280(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all comments for the Issue associated with the specified API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   issueId: JString (required)
  ##          : Issue identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594282 = path.getOrDefault("resourceGroupName")
  valid_594282 = validateParameter(valid_594282, JString, required = true,
                                 default = nil)
  if valid_594282 != nil:
    section.add "resourceGroupName", valid_594282
  var valid_594283 = path.getOrDefault("apiId")
  valid_594283 = validateParameter(valid_594283, JString, required = true,
                                 default = nil)
  if valid_594283 != nil:
    section.add "apiId", valid_594283
  var valid_594284 = path.getOrDefault("issueId")
  valid_594284 = validateParameter(valid_594284, JString, required = true,
                                 default = nil)
  if valid_594284 != nil:
    section.add "issueId", valid_594284
  var valid_594285 = path.getOrDefault("subscriptionId")
  valid_594285 = validateParameter(valid_594285, JString, required = true,
                                 default = nil)
  if valid_594285 != nil:
    section.add "subscriptionId", valid_594285
  var valid_594286 = path.getOrDefault("serviceName")
  valid_594286 = validateParameter(valid_594286, JString, required = true,
                                 default = nil)
  if valid_594286 != nil:
    section.add "serviceName", valid_594286
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : Number of records to return.
  ##   $skip: JInt
  ##        : Number of records to skip.
  ##   $filter: JString
  ##          : | Field       | Supported operators    | Supported functions               |
  ## |-------------|------------------------|-----------------------------------|
  ## | id          | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  ## | userId          | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594287 = query.getOrDefault("api-version")
  valid_594287 = validateParameter(valid_594287, JString, required = true,
                                 default = nil)
  if valid_594287 != nil:
    section.add "api-version", valid_594287
  var valid_594288 = query.getOrDefault("$top")
  valid_594288 = validateParameter(valid_594288, JInt, required = false, default = nil)
  if valid_594288 != nil:
    section.add "$top", valid_594288
  var valid_594289 = query.getOrDefault("$skip")
  valid_594289 = validateParameter(valid_594289, JInt, required = false, default = nil)
  if valid_594289 != nil:
    section.add "$skip", valid_594289
  var valid_594290 = query.getOrDefault("$filter")
  valid_594290 = validateParameter(valid_594290, JString, required = false,
                                 default = nil)
  if valid_594290 != nil:
    section.add "$filter", valid_594290
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594291: Call_ApiIssueAttachmentsListByService_594279;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all comments for the Issue associated with the specified API.
  ## 
  let valid = call_594291.validator(path, query, header, formData, body)
  let scheme = call_594291.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594291.url(scheme.get, call_594291.host, call_594291.base,
                         call_594291.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594291, url, valid)

proc call*(call_594292: Call_ApiIssueAttachmentsListByService_594279;
          resourceGroupName: string; apiVersion: string; apiId: string;
          issueId: string; subscriptionId: string; serviceName: string; Top: int = 0;
          Skip: int = 0; Filter: string = ""): Recallable =
  ## apiIssueAttachmentsListByService
  ## Lists all comments for the Issue associated with the specified API.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   issueId: string (required)
  ##          : Issue identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : Number of records to return.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   Filter: string
  ##         : | Field       | Supported operators    | Supported functions               |
  ## |-------------|------------------------|-----------------------------------|
  ## | id          | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  ## | userId          | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  var path_594293 = newJObject()
  var query_594294 = newJObject()
  add(path_594293, "resourceGroupName", newJString(resourceGroupName))
  add(query_594294, "api-version", newJString(apiVersion))
  add(path_594293, "apiId", newJString(apiId))
  add(path_594293, "issueId", newJString(issueId))
  add(path_594293, "subscriptionId", newJString(subscriptionId))
  add(query_594294, "$top", newJInt(Top))
  add(query_594294, "$skip", newJInt(Skip))
  add(path_594293, "serviceName", newJString(serviceName))
  add(query_594294, "$filter", newJString(Filter))
  result = call_594292.call(path_594293, query_594294, nil, nil, nil)

var apiIssueAttachmentsListByService* = Call_ApiIssueAttachmentsListByService_594279(
    name: "apiIssueAttachmentsListByService", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/issues/{issueId}/attachments",
    validator: validate_ApiIssueAttachmentsListByService_594280, base: "",
    url: url_ApiIssueAttachmentsListByService_594281, schemes: {Scheme.Https})
type
  Call_ApiIssueAttachmentCreateOrUpdate_594309 = ref object of OpenApiRestCall_593425
proc url_ApiIssueAttachmentCreateOrUpdate_594311(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "issueId" in path, "`issueId` is a required path parameter"
  assert "attachmentId" in path, "`attachmentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/issues/"),
               (kind: VariableSegment, value: "issueId"),
               (kind: ConstantSegment, value: "/attachments/"),
               (kind: VariableSegment, value: "attachmentId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiIssueAttachmentCreateOrUpdate_594310(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new Attachment for the Issue in an API or updates an existing one.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   issueId: JString (required)
  ##          : Issue identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   attachmentId: JString (required)
  ##               : Attachment identifier within an Issue. Must be unique in the current Issue.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594312 = path.getOrDefault("resourceGroupName")
  valid_594312 = validateParameter(valid_594312, JString, required = true,
                                 default = nil)
  if valid_594312 != nil:
    section.add "resourceGroupName", valid_594312
  var valid_594313 = path.getOrDefault("apiId")
  valid_594313 = validateParameter(valid_594313, JString, required = true,
                                 default = nil)
  if valid_594313 != nil:
    section.add "apiId", valid_594313
  var valid_594314 = path.getOrDefault("issueId")
  valid_594314 = validateParameter(valid_594314, JString, required = true,
                                 default = nil)
  if valid_594314 != nil:
    section.add "issueId", valid_594314
  var valid_594315 = path.getOrDefault("subscriptionId")
  valid_594315 = validateParameter(valid_594315, JString, required = true,
                                 default = nil)
  if valid_594315 != nil:
    section.add "subscriptionId", valid_594315
  var valid_594316 = path.getOrDefault("attachmentId")
  valid_594316 = validateParameter(valid_594316, JString, required = true,
                                 default = nil)
  if valid_594316 != nil:
    section.add "attachmentId", valid_594316
  var valid_594317 = path.getOrDefault("serviceName")
  valid_594317 = validateParameter(valid_594317, JString, required = true,
                                 default = nil)
  if valid_594317 != nil:
    section.add "serviceName", valid_594317
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594318 = query.getOrDefault("api-version")
  valid_594318 = validateParameter(valid_594318, JString, required = true,
                                 default = nil)
  if valid_594318 != nil:
    section.add "api-version", valid_594318
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the Issue Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  var valid_594319 = header.getOrDefault("If-Match")
  valid_594319 = validateParameter(valid_594319, JString, required = false,
                                 default = nil)
  if valid_594319 != nil:
    section.add "If-Match", valid_594319
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

proc call*(call_594321: Call_ApiIssueAttachmentCreateOrUpdate_594309;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new Attachment for the Issue in an API or updates an existing one.
  ## 
  let valid = call_594321.validator(path, query, header, formData, body)
  let scheme = call_594321.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594321.url(scheme.get, call_594321.host, call_594321.base,
                         call_594321.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594321, url, valid)

proc call*(call_594322: Call_ApiIssueAttachmentCreateOrUpdate_594309;
          resourceGroupName: string; apiVersion: string; apiId: string;
          issueId: string; subscriptionId: string; attachmentId: string;
          parameters: JsonNode; serviceName: string): Recallable =
  ## apiIssueAttachmentCreateOrUpdate
  ## Creates a new Attachment for the Issue in an API or updates an existing one.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   issueId: string (required)
  ##          : Issue identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   attachmentId: string (required)
  ##               : Attachment identifier within an Issue. Must be unique in the current Issue.
  ##   parameters: JObject (required)
  ##             : Create parameters.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594323 = newJObject()
  var query_594324 = newJObject()
  var body_594325 = newJObject()
  add(path_594323, "resourceGroupName", newJString(resourceGroupName))
  add(query_594324, "api-version", newJString(apiVersion))
  add(path_594323, "apiId", newJString(apiId))
  add(path_594323, "issueId", newJString(issueId))
  add(path_594323, "subscriptionId", newJString(subscriptionId))
  add(path_594323, "attachmentId", newJString(attachmentId))
  if parameters != nil:
    body_594325 = parameters
  add(path_594323, "serviceName", newJString(serviceName))
  result = call_594322.call(path_594323, query_594324, nil, nil, body_594325)

var apiIssueAttachmentCreateOrUpdate* = Call_ApiIssueAttachmentCreateOrUpdate_594309(
    name: "apiIssueAttachmentCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/issues/{issueId}/attachments/{attachmentId}",
    validator: validate_ApiIssueAttachmentCreateOrUpdate_594310, base: "",
    url: url_ApiIssueAttachmentCreateOrUpdate_594311, schemes: {Scheme.Https})
type
  Call_ApiIssuAttachmentHead_594341 = ref object of OpenApiRestCall_593425
proc url_ApiIssuAttachmentHead_594343(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "issueId" in path, "`issueId` is a required path parameter"
  assert "attachmentId" in path, "`attachmentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/issues/"),
               (kind: VariableSegment, value: "issueId"),
               (kind: ConstantSegment, value: "/attachments/"),
               (kind: VariableSegment, value: "attachmentId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiIssuAttachmentHead_594342(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the entity state (Etag) version of the issue Attachment for an API specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   issueId: JString (required)
  ##          : Issue identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   attachmentId: JString (required)
  ##               : Attachment identifier within an Issue. Must be unique in the current Issue.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594344 = path.getOrDefault("resourceGroupName")
  valid_594344 = validateParameter(valid_594344, JString, required = true,
                                 default = nil)
  if valid_594344 != nil:
    section.add "resourceGroupName", valid_594344
  var valid_594345 = path.getOrDefault("apiId")
  valid_594345 = validateParameter(valid_594345, JString, required = true,
                                 default = nil)
  if valid_594345 != nil:
    section.add "apiId", valid_594345
  var valid_594346 = path.getOrDefault("issueId")
  valid_594346 = validateParameter(valid_594346, JString, required = true,
                                 default = nil)
  if valid_594346 != nil:
    section.add "issueId", valid_594346
  var valid_594347 = path.getOrDefault("subscriptionId")
  valid_594347 = validateParameter(valid_594347, JString, required = true,
                                 default = nil)
  if valid_594347 != nil:
    section.add "subscriptionId", valid_594347
  var valid_594348 = path.getOrDefault("attachmentId")
  valid_594348 = validateParameter(valid_594348, JString, required = true,
                                 default = nil)
  if valid_594348 != nil:
    section.add "attachmentId", valid_594348
  var valid_594349 = path.getOrDefault("serviceName")
  valid_594349 = validateParameter(valid_594349, JString, required = true,
                                 default = nil)
  if valid_594349 != nil:
    section.add "serviceName", valid_594349
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594350 = query.getOrDefault("api-version")
  valid_594350 = validateParameter(valid_594350, JString, required = true,
                                 default = nil)
  if valid_594350 != nil:
    section.add "api-version", valid_594350
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594351: Call_ApiIssuAttachmentHead_594341; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the entity state (Etag) version of the issue Attachment for an API specified by its identifier.
  ## 
  let valid = call_594351.validator(path, query, header, formData, body)
  let scheme = call_594351.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594351.url(scheme.get, call_594351.host, call_594351.base,
                         call_594351.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594351, url, valid)

proc call*(call_594352: Call_ApiIssuAttachmentHead_594341;
          resourceGroupName: string; apiVersion: string; apiId: string;
          issueId: string; subscriptionId: string; attachmentId: string;
          serviceName: string): Recallable =
  ## apiIssuAttachmentHead
  ## Gets the entity state (Etag) version of the issue Attachment for an API specified by its identifier.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   issueId: string (required)
  ##          : Issue identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   attachmentId: string (required)
  ##               : Attachment identifier within an Issue. Must be unique in the current Issue.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594353 = newJObject()
  var query_594354 = newJObject()
  add(path_594353, "resourceGroupName", newJString(resourceGroupName))
  add(query_594354, "api-version", newJString(apiVersion))
  add(path_594353, "apiId", newJString(apiId))
  add(path_594353, "issueId", newJString(issueId))
  add(path_594353, "subscriptionId", newJString(subscriptionId))
  add(path_594353, "attachmentId", newJString(attachmentId))
  add(path_594353, "serviceName", newJString(serviceName))
  result = call_594352.call(path_594353, query_594354, nil, nil, nil)

var apiIssuAttachmentHead* = Call_ApiIssuAttachmentHead_594341(
    name: "apiIssuAttachmentHead", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/issues/{issueId}/attachments/{attachmentId}",
    validator: validate_ApiIssuAttachmentHead_594342, base: "",
    url: url_ApiIssuAttachmentHead_594343, schemes: {Scheme.Https})
type
  Call_ApiIssueAttachmentGet_594295 = ref object of OpenApiRestCall_593425
proc url_ApiIssueAttachmentGet_594297(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "issueId" in path, "`issueId` is a required path parameter"
  assert "attachmentId" in path, "`attachmentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/issues/"),
               (kind: VariableSegment, value: "issueId"),
               (kind: ConstantSegment, value: "/attachments/"),
               (kind: VariableSegment, value: "attachmentId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiIssueAttachmentGet_594296(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of the issue Attachment for an API specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   issueId: JString (required)
  ##          : Issue identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   attachmentId: JString (required)
  ##               : Attachment identifier within an Issue. Must be unique in the current Issue.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594298 = path.getOrDefault("resourceGroupName")
  valid_594298 = validateParameter(valid_594298, JString, required = true,
                                 default = nil)
  if valid_594298 != nil:
    section.add "resourceGroupName", valid_594298
  var valid_594299 = path.getOrDefault("apiId")
  valid_594299 = validateParameter(valid_594299, JString, required = true,
                                 default = nil)
  if valid_594299 != nil:
    section.add "apiId", valid_594299
  var valid_594300 = path.getOrDefault("issueId")
  valid_594300 = validateParameter(valid_594300, JString, required = true,
                                 default = nil)
  if valid_594300 != nil:
    section.add "issueId", valid_594300
  var valid_594301 = path.getOrDefault("subscriptionId")
  valid_594301 = validateParameter(valid_594301, JString, required = true,
                                 default = nil)
  if valid_594301 != nil:
    section.add "subscriptionId", valid_594301
  var valid_594302 = path.getOrDefault("attachmentId")
  valid_594302 = validateParameter(valid_594302, JString, required = true,
                                 default = nil)
  if valid_594302 != nil:
    section.add "attachmentId", valid_594302
  var valid_594303 = path.getOrDefault("serviceName")
  valid_594303 = validateParameter(valid_594303, JString, required = true,
                                 default = nil)
  if valid_594303 != nil:
    section.add "serviceName", valid_594303
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594304 = query.getOrDefault("api-version")
  valid_594304 = validateParameter(valid_594304, JString, required = true,
                                 default = nil)
  if valid_594304 != nil:
    section.add "api-version", valid_594304
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594305: Call_ApiIssueAttachmentGet_594295; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the issue Attachment for an API specified by its identifier.
  ## 
  let valid = call_594305.validator(path, query, header, formData, body)
  let scheme = call_594305.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594305.url(scheme.get, call_594305.host, call_594305.base,
                         call_594305.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594305, url, valid)

proc call*(call_594306: Call_ApiIssueAttachmentGet_594295;
          resourceGroupName: string; apiVersion: string; apiId: string;
          issueId: string; subscriptionId: string; attachmentId: string;
          serviceName: string): Recallable =
  ## apiIssueAttachmentGet
  ## Gets the details of the issue Attachment for an API specified by its identifier.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   issueId: string (required)
  ##          : Issue identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   attachmentId: string (required)
  ##               : Attachment identifier within an Issue. Must be unique in the current Issue.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594307 = newJObject()
  var query_594308 = newJObject()
  add(path_594307, "resourceGroupName", newJString(resourceGroupName))
  add(query_594308, "api-version", newJString(apiVersion))
  add(path_594307, "apiId", newJString(apiId))
  add(path_594307, "issueId", newJString(issueId))
  add(path_594307, "subscriptionId", newJString(subscriptionId))
  add(path_594307, "attachmentId", newJString(attachmentId))
  add(path_594307, "serviceName", newJString(serviceName))
  result = call_594306.call(path_594307, query_594308, nil, nil, nil)

var apiIssueAttachmentGet* = Call_ApiIssueAttachmentGet_594295(
    name: "apiIssueAttachmentGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/issues/{issueId}/attachments/{attachmentId}",
    validator: validate_ApiIssueAttachmentGet_594296, base: "",
    url: url_ApiIssueAttachmentGet_594297, schemes: {Scheme.Https})
type
  Call_ApiIssueAttachmentDelete_594326 = ref object of OpenApiRestCall_593425
proc url_ApiIssueAttachmentDelete_594328(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "issueId" in path, "`issueId` is a required path parameter"
  assert "attachmentId" in path, "`attachmentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/issues/"),
               (kind: VariableSegment, value: "issueId"),
               (kind: ConstantSegment, value: "/attachments/"),
               (kind: VariableSegment, value: "attachmentId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiIssueAttachmentDelete_594327(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified comment from an Issue.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   issueId: JString (required)
  ##          : Issue identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   attachmentId: JString (required)
  ##               : Attachment identifier within an Issue. Must be unique in the current Issue.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594329 = path.getOrDefault("resourceGroupName")
  valid_594329 = validateParameter(valid_594329, JString, required = true,
                                 default = nil)
  if valid_594329 != nil:
    section.add "resourceGroupName", valid_594329
  var valid_594330 = path.getOrDefault("apiId")
  valid_594330 = validateParameter(valid_594330, JString, required = true,
                                 default = nil)
  if valid_594330 != nil:
    section.add "apiId", valid_594330
  var valid_594331 = path.getOrDefault("issueId")
  valid_594331 = validateParameter(valid_594331, JString, required = true,
                                 default = nil)
  if valid_594331 != nil:
    section.add "issueId", valid_594331
  var valid_594332 = path.getOrDefault("subscriptionId")
  valid_594332 = validateParameter(valid_594332, JString, required = true,
                                 default = nil)
  if valid_594332 != nil:
    section.add "subscriptionId", valid_594332
  var valid_594333 = path.getOrDefault("attachmentId")
  valid_594333 = validateParameter(valid_594333, JString, required = true,
                                 default = nil)
  if valid_594333 != nil:
    section.add "attachmentId", valid_594333
  var valid_594334 = path.getOrDefault("serviceName")
  valid_594334 = validateParameter(valid_594334, JString, required = true,
                                 default = nil)
  if valid_594334 != nil:
    section.add "serviceName", valid_594334
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594335 = query.getOrDefault("api-version")
  valid_594335 = validateParameter(valid_594335, JString, required = true,
                                 default = nil)
  if valid_594335 != nil:
    section.add "api-version", valid_594335
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Issue Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_594336 = header.getOrDefault("If-Match")
  valid_594336 = validateParameter(valid_594336, JString, required = true,
                                 default = nil)
  if valid_594336 != nil:
    section.add "If-Match", valid_594336
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594337: Call_ApiIssueAttachmentDelete_594326; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified comment from an Issue.
  ## 
  let valid = call_594337.validator(path, query, header, formData, body)
  let scheme = call_594337.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594337.url(scheme.get, call_594337.host, call_594337.base,
                         call_594337.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594337, url, valid)

proc call*(call_594338: Call_ApiIssueAttachmentDelete_594326;
          resourceGroupName: string; apiVersion: string; apiId: string;
          issueId: string; subscriptionId: string; attachmentId: string;
          serviceName: string): Recallable =
  ## apiIssueAttachmentDelete
  ## Deletes the specified comment from an Issue.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   issueId: string (required)
  ##          : Issue identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   attachmentId: string (required)
  ##               : Attachment identifier within an Issue. Must be unique in the current Issue.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594339 = newJObject()
  var query_594340 = newJObject()
  add(path_594339, "resourceGroupName", newJString(resourceGroupName))
  add(query_594340, "api-version", newJString(apiVersion))
  add(path_594339, "apiId", newJString(apiId))
  add(path_594339, "issueId", newJString(issueId))
  add(path_594339, "subscriptionId", newJString(subscriptionId))
  add(path_594339, "attachmentId", newJString(attachmentId))
  add(path_594339, "serviceName", newJString(serviceName))
  result = call_594338.call(path_594339, query_594340, nil, nil, nil)

var apiIssueAttachmentDelete* = Call_ApiIssueAttachmentDelete_594326(
    name: "apiIssueAttachmentDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/issues/{issueId}/attachments/{attachmentId}",
    validator: validate_ApiIssueAttachmentDelete_594327, base: "",
    url: url_ApiIssueAttachmentDelete_594328, schemes: {Scheme.Https})
type
  Call_ApiIssueCommentsListByService_594355 = ref object of OpenApiRestCall_593425
proc url_ApiIssueCommentsListByService_594357(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "issueId" in path, "`issueId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/issues/"),
               (kind: VariableSegment, value: "issueId"),
               (kind: ConstantSegment, value: "/comments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiIssueCommentsListByService_594356(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all comments for the Issue associated with the specified API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   issueId: JString (required)
  ##          : Issue identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594358 = path.getOrDefault("resourceGroupName")
  valid_594358 = validateParameter(valid_594358, JString, required = true,
                                 default = nil)
  if valid_594358 != nil:
    section.add "resourceGroupName", valid_594358
  var valid_594359 = path.getOrDefault("apiId")
  valid_594359 = validateParameter(valid_594359, JString, required = true,
                                 default = nil)
  if valid_594359 != nil:
    section.add "apiId", valid_594359
  var valid_594360 = path.getOrDefault("issueId")
  valid_594360 = validateParameter(valid_594360, JString, required = true,
                                 default = nil)
  if valid_594360 != nil:
    section.add "issueId", valid_594360
  var valid_594361 = path.getOrDefault("subscriptionId")
  valid_594361 = validateParameter(valid_594361, JString, required = true,
                                 default = nil)
  if valid_594361 != nil:
    section.add "subscriptionId", valid_594361
  var valid_594362 = path.getOrDefault("serviceName")
  valid_594362 = validateParameter(valid_594362, JString, required = true,
                                 default = nil)
  if valid_594362 != nil:
    section.add "serviceName", valid_594362
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : Number of records to return.
  ##   $skip: JInt
  ##        : Number of records to skip.
  ##   $filter: JString
  ##          : | Field       | Supported operators    | Supported functions               |
  ## |-------------|------------------------|-----------------------------------|
  ## | id          | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  ## | userId          | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594363 = query.getOrDefault("api-version")
  valid_594363 = validateParameter(valid_594363, JString, required = true,
                                 default = nil)
  if valid_594363 != nil:
    section.add "api-version", valid_594363
  var valid_594364 = query.getOrDefault("$top")
  valid_594364 = validateParameter(valid_594364, JInt, required = false, default = nil)
  if valid_594364 != nil:
    section.add "$top", valid_594364
  var valid_594365 = query.getOrDefault("$skip")
  valid_594365 = validateParameter(valid_594365, JInt, required = false, default = nil)
  if valid_594365 != nil:
    section.add "$skip", valid_594365
  var valid_594366 = query.getOrDefault("$filter")
  valid_594366 = validateParameter(valid_594366, JString, required = false,
                                 default = nil)
  if valid_594366 != nil:
    section.add "$filter", valid_594366
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594367: Call_ApiIssueCommentsListByService_594355; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all comments for the Issue associated with the specified API.
  ## 
  let valid = call_594367.validator(path, query, header, formData, body)
  let scheme = call_594367.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594367.url(scheme.get, call_594367.host, call_594367.base,
                         call_594367.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594367, url, valid)

proc call*(call_594368: Call_ApiIssueCommentsListByService_594355;
          resourceGroupName: string; apiVersion: string; apiId: string;
          issueId: string; subscriptionId: string; serviceName: string; Top: int = 0;
          Skip: int = 0; Filter: string = ""): Recallable =
  ## apiIssueCommentsListByService
  ## Lists all comments for the Issue associated with the specified API.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   issueId: string (required)
  ##          : Issue identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : Number of records to return.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   Filter: string
  ##         : | Field       | Supported operators    | Supported functions               |
  ## |-------------|------------------------|-----------------------------------|
  ## | id          | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  ## | userId          | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  var path_594369 = newJObject()
  var query_594370 = newJObject()
  add(path_594369, "resourceGroupName", newJString(resourceGroupName))
  add(query_594370, "api-version", newJString(apiVersion))
  add(path_594369, "apiId", newJString(apiId))
  add(path_594369, "issueId", newJString(issueId))
  add(path_594369, "subscriptionId", newJString(subscriptionId))
  add(query_594370, "$top", newJInt(Top))
  add(query_594370, "$skip", newJInt(Skip))
  add(path_594369, "serviceName", newJString(serviceName))
  add(query_594370, "$filter", newJString(Filter))
  result = call_594368.call(path_594369, query_594370, nil, nil, nil)

var apiIssueCommentsListByService* = Call_ApiIssueCommentsListByService_594355(
    name: "apiIssueCommentsListByService", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/issues/{issueId}/comments",
    validator: validate_ApiIssueCommentsListByService_594356, base: "",
    url: url_ApiIssueCommentsListByService_594357, schemes: {Scheme.Https})
type
  Call_ApiIssueCommentCreateOrUpdate_594385 = ref object of OpenApiRestCall_593425
proc url_ApiIssueCommentCreateOrUpdate_594387(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "issueId" in path, "`issueId` is a required path parameter"
  assert "commentId" in path, "`commentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/issues/"),
               (kind: VariableSegment, value: "issueId"),
               (kind: ConstantSegment, value: "/comments/"),
               (kind: VariableSegment, value: "commentId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiIssueCommentCreateOrUpdate_594386(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new Comment for the Issue in an API or updates an existing one.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   issueId: JString (required)
  ##          : Issue identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   commentId: JString (required)
  ##            : Comment identifier within an Issue. Must be unique in the current Issue.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594388 = path.getOrDefault("resourceGroupName")
  valid_594388 = validateParameter(valid_594388, JString, required = true,
                                 default = nil)
  if valid_594388 != nil:
    section.add "resourceGroupName", valid_594388
  var valid_594389 = path.getOrDefault("apiId")
  valid_594389 = validateParameter(valid_594389, JString, required = true,
                                 default = nil)
  if valid_594389 != nil:
    section.add "apiId", valid_594389
  var valid_594390 = path.getOrDefault("issueId")
  valid_594390 = validateParameter(valid_594390, JString, required = true,
                                 default = nil)
  if valid_594390 != nil:
    section.add "issueId", valid_594390
  var valid_594391 = path.getOrDefault("subscriptionId")
  valid_594391 = validateParameter(valid_594391, JString, required = true,
                                 default = nil)
  if valid_594391 != nil:
    section.add "subscriptionId", valid_594391
  var valid_594392 = path.getOrDefault("commentId")
  valid_594392 = validateParameter(valid_594392, JString, required = true,
                                 default = nil)
  if valid_594392 != nil:
    section.add "commentId", valid_594392
  var valid_594393 = path.getOrDefault("serviceName")
  valid_594393 = validateParameter(valid_594393, JString, required = true,
                                 default = nil)
  if valid_594393 != nil:
    section.add "serviceName", valid_594393
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594394 = query.getOrDefault("api-version")
  valid_594394 = validateParameter(valid_594394, JString, required = true,
                                 default = nil)
  if valid_594394 != nil:
    section.add "api-version", valid_594394
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the Issue Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  var valid_594395 = header.getOrDefault("If-Match")
  valid_594395 = validateParameter(valid_594395, JString, required = false,
                                 default = nil)
  if valid_594395 != nil:
    section.add "If-Match", valid_594395
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

proc call*(call_594397: Call_ApiIssueCommentCreateOrUpdate_594385; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new Comment for the Issue in an API or updates an existing one.
  ## 
  let valid = call_594397.validator(path, query, header, formData, body)
  let scheme = call_594397.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594397.url(scheme.get, call_594397.host, call_594397.base,
                         call_594397.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594397, url, valid)

proc call*(call_594398: Call_ApiIssueCommentCreateOrUpdate_594385;
          resourceGroupName: string; apiVersion: string; apiId: string;
          issueId: string; subscriptionId: string; commentId: string;
          parameters: JsonNode; serviceName: string): Recallable =
  ## apiIssueCommentCreateOrUpdate
  ## Creates a new Comment for the Issue in an API or updates an existing one.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   issueId: string (required)
  ##          : Issue identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   commentId: string (required)
  ##            : Comment identifier within an Issue. Must be unique in the current Issue.
  ##   parameters: JObject (required)
  ##             : Create parameters.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594399 = newJObject()
  var query_594400 = newJObject()
  var body_594401 = newJObject()
  add(path_594399, "resourceGroupName", newJString(resourceGroupName))
  add(query_594400, "api-version", newJString(apiVersion))
  add(path_594399, "apiId", newJString(apiId))
  add(path_594399, "issueId", newJString(issueId))
  add(path_594399, "subscriptionId", newJString(subscriptionId))
  add(path_594399, "commentId", newJString(commentId))
  if parameters != nil:
    body_594401 = parameters
  add(path_594399, "serviceName", newJString(serviceName))
  result = call_594398.call(path_594399, query_594400, nil, nil, body_594401)

var apiIssueCommentCreateOrUpdate* = Call_ApiIssueCommentCreateOrUpdate_594385(
    name: "apiIssueCommentCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/issues/{issueId}/comments/{commentId}",
    validator: validate_ApiIssueCommentCreateOrUpdate_594386, base: "",
    url: url_ApiIssueCommentCreateOrUpdate_594387, schemes: {Scheme.Https})
type
  Call_ApiIssuCommentHead_594417 = ref object of OpenApiRestCall_593425
proc url_ApiIssuCommentHead_594419(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "issueId" in path, "`issueId` is a required path parameter"
  assert "commentId" in path, "`commentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/issues/"),
               (kind: VariableSegment, value: "issueId"),
               (kind: ConstantSegment, value: "/comments/"),
               (kind: VariableSegment, value: "commentId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiIssuCommentHead_594418(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets the entity state (Etag) version of the issue Comment for an API specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   issueId: JString (required)
  ##          : Issue identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   commentId: JString (required)
  ##            : Comment identifier within an Issue. Must be unique in the current Issue.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594420 = path.getOrDefault("resourceGroupName")
  valid_594420 = validateParameter(valid_594420, JString, required = true,
                                 default = nil)
  if valid_594420 != nil:
    section.add "resourceGroupName", valid_594420
  var valid_594421 = path.getOrDefault("apiId")
  valid_594421 = validateParameter(valid_594421, JString, required = true,
                                 default = nil)
  if valid_594421 != nil:
    section.add "apiId", valid_594421
  var valid_594422 = path.getOrDefault("issueId")
  valid_594422 = validateParameter(valid_594422, JString, required = true,
                                 default = nil)
  if valid_594422 != nil:
    section.add "issueId", valid_594422
  var valid_594423 = path.getOrDefault("subscriptionId")
  valid_594423 = validateParameter(valid_594423, JString, required = true,
                                 default = nil)
  if valid_594423 != nil:
    section.add "subscriptionId", valid_594423
  var valid_594424 = path.getOrDefault("commentId")
  valid_594424 = validateParameter(valid_594424, JString, required = true,
                                 default = nil)
  if valid_594424 != nil:
    section.add "commentId", valid_594424
  var valid_594425 = path.getOrDefault("serviceName")
  valid_594425 = validateParameter(valid_594425, JString, required = true,
                                 default = nil)
  if valid_594425 != nil:
    section.add "serviceName", valid_594425
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594426 = query.getOrDefault("api-version")
  valid_594426 = validateParameter(valid_594426, JString, required = true,
                                 default = nil)
  if valid_594426 != nil:
    section.add "api-version", valid_594426
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594427: Call_ApiIssuCommentHead_594417; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the entity state (Etag) version of the issue Comment for an API specified by its identifier.
  ## 
  let valid = call_594427.validator(path, query, header, formData, body)
  let scheme = call_594427.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594427.url(scheme.get, call_594427.host, call_594427.base,
                         call_594427.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594427, url, valid)

proc call*(call_594428: Call_ApiIssuCommentHead_594417; resourceGroupName: string;
          apiVersion: string; apiId: string; issueId: string; subscriptionId: string;
          commentId: string; serviceName: string): Recallable =
  ## apiIssuCommentHead
  ## Gets the entity state (Etag) version of the issue Comment for an API specified by its identifier.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   issueId: string (required)
  ##          : Issue identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   commentId: string (required)
  ##            : Comment identifier within an Issue. Must be unique in the current Issue.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594429 = newJObject()
  var query_594430 = newJObject()
  add(path_594429, "resourceGroupName", newJString(resourceGroupName))
  add(query_594430, "api-version", newJString(apiVersion))
  add(path_594429, "apiId", newJString(apiId))
  add(path_594429, "issueId", newJString(issueId))
  add(path_594429, "subscriptionId", newJString(subscriptionId))
  add(path_594429, "commentId", newJString(commentId))
  add(path_594429, "serviceName", newJString(serviceName))
  result = call_594428.call(path_594429, query_594430, nil, nil, nil)

var apiIssuCommentHead* = Call_ApiIssuCommentHead_594417(
    name: "apiIssuCommentHead", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/issues/{issueId}/comments/{commentId}",
    validator: validate_ApiIssuCommentHead_594418, base: "",
    url: url_ApiIssuCommentHead_594419, schemes: {Scheme.Https})
type
  Call_ApiIssueCommentGet_594371 = ref object of OpenApiRestCall_593425
proc url_ApiIssueCommentGet_594373(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "issueId" in path, "`issueId` is a required path parameter"
  assert "commentId" in path, "`commentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/issues/"),
               (kind: VariableSegment, value: "issueId"),
               (kind: ConstantSegment, value: "/comments/"),
               (kind: VariableSegment, value: "commentId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiIssueCommentGet_594372(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets the details of the issue Comment for an API specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   issueId: JString (required)
  ##          : Issue identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   commentId: JString (required)
  ##            : Comment identifier within an Issue. Must be unique in the current Issue.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594374 = path.getOrDefault("resourceGroupName")
  valid_594374 = validateParameter(valid_594374, JString, required = true,
                                 default = nil)
  if valid_594374 != nil:
    section.add "resourceGroupName", valid_594374
  var valid_594375 = path.getOrDefault("apiId")
  valid_594375 = validateParameter(valid_594375, JString, required = true,
                                 default = nil)
  if valid_594375 != nil:
    section.add "apiId", valid_594375
  var valid_594376 = path.getOrDefault("issueId")
  valid_594376 = validateParameter(valid_594376, JString, required = true,
                                 default = nil)
  if valid_594376 != nil:
    section.add "issueId", valid_594376
  var valid_594377 = path.getOrDefault("subscriptionId")
  valid_594377 = validateParameter(valid_594377, JString, required = true,
                                 default = nil)
  if valid_594377 != nil:
    section.add "subscriptionId", valid_594377
  var valid_594378 = path.getOrDefault("commentId")
  valid_594378 = validateParameter(valid_594378, JString, required = true,
                                 default = nil)
  if valid_594378 != nil:
    section.add "commentId", valid_594378
  var valid_594379 = path.getOrDefault("serviceName")
  valid_594379 = validateParameter(valid_594379, JString, required = true,
                                 default = nil)
  if valid_594379 != nil:
    section.add "serviceName", valid_594379
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594380 = query.getOrDefault("api-version")
  valid_594380 = validateParameter(valid_594380, JString, required = true,
                                 default = nil)
  if valid_594380 != nil:
    section.add "api-version", valid_594380
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594381: Call_ApiIssueCommentGet_594371; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the issue Comment for an API specified by its identifier.
  ## 
  let valid = call_594381.validator(path, query, header, formData, body)
  let scheme = call_594381.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594381.url(scheme.get, call_594381.host, call_594381.base,
                         call_594381.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594381, url, valid)

proc call*(call_594382: Call_ApiIssueCommentGet_594371; resourceGroupName: string;
          apiVersion: string; apiId: string; issueId: string; subscriptionId: string;
          commentId: string; serviceName: string): Recallable =
  ## apiIssueCommentGet
  ## Gets the details of the issue Comment for an API specified by its identifier.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   issueId: string (required)
  ##          : Issue identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   commentId: string (required)
  ##            : Comment identifier within an Issue. Must be unique in the current Issue.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594383 = newJObject()
  var query_594384 = newJObject()
  add(path_594383, "resourceGroupName", newJString(resourceGroupName))
  add(query_594384, "api-version", newJString(apiVersion))
  add(path_594383, "apiId", newJString(apiId))
  add(path_594383, "issueId", newJString(issueId))
  add(path_594383, "subscriptionId", newJString(subscriptionId))
  add(path_594383, "commentId", newJString(commentId))
  add(path_594383, "serviceName", newJString(serviceName))
  result = call_594382.call(path_594383, query_594384, nil, nil, nil)

var apiIssueCommentGet* = Call_ApiIssueCommentGet_594371(
    name: "apiIssueCommentGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/issues/{issueId}/comments/{commentId}",
    validator: validate_ApiIssueCommentGet_594372, base: "",
    url: url_ApiIssueCommentGet_594373, schemes: {Scheme.Https})
type
  Call_ApiIssueCommentDelete_594402 = ref object of OpenApiRestCall_593425
proc url_ApiIssueCommentDelete_594404(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "issueId" in path, "`issueId` is a required path parameter"
  assert "commentId" in path, "`commentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/issues/"),
               (kind: VariableSegment, value: "issueId"),
               (kind: ConstantSegment, value: "/comments/"),
               (kind: VariableSegment, value: "commentId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiIssueCommentDelete_594403(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified comment from an Issue.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   issueId: JString (required)
  ##          : Issue identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   commentId: JString (required)
  ##            : Comment identifier within an Issue. Must be unique in the current Issue.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594405 = path.getOrDefault("resourceGroupName")
  valid_594405 = validateParameter(valid_594405, JString, required = true,
                                 default = nil)
  if valid_594405 != nil:
    section.add "resourceGroupName", valid_594405
  var valid_594406 = path.getOrDefault("apiId")
  valid_594406 = validateParameter(valid_594406, JString, required = true,
                                 default = nil)
  if valid_594406 != nil:
    section.add "apiId", valid_594406
  var valid_594407 = path.getOrDefault("issueId")
  valid_594407 = validateParameter(valid_594407, JString, required = true,
                                 default = nil)
  if valid_594407 != nil:
    section.add "issueId", valid_594407
  var valid_594408 = path.getOrDefault("subscriptionId")
  valid_594408 = validateParameter(valid_594408, JString, required = true,
                                 default = nil)
  if valid_594408 != nil:
    section.add "subscriptionId", valid_594408
  var valid_594409 = path.getOrDefault("commentId")
  valid_594409 = validateParameter(valid_594409, JString, required = true,
                                 default = nil)
  if valid_594409 != nil:
    section.add "commentId", valid_594409
  var valid_594410 = path.getOrDefault("serviceName")
  valid_594410 = validateParameter(valid_594410, JString, required = true,
                                 default = nil)
  if valid_594410 != nil:
    section.add "serviceName", valid_594410
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594411 = query.getOrDefault("api-version")
  valid_594411 = validateParameter(valid_594411, JString, required = true,
                                 default = nil)
  if valid_594411 != nil:
    section.add "api-version", valid_594411
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Issue Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_594412 = header.getOrDefault("If-Match")
  valid_594412 = validateParameter(valid_594412, JString, required = true,
                                 default = nil)
  if valid_594412 != nil:
    section.add "If-Match", valid_594412
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594413: Call_ApiIssueCommentDelete_594402; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified comment from an Issue.
  ## 
  let valid = call_594413.validator(path, query, header, formData, body)
  let scheme = call_594413.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594413.url(scheme.get, call_594413.host, call_594413.base,
                         call_594413.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594413, url, valid)

proc call*(call_594414: Call_ApiIssueCommentDelete_594402;
          resourceGroupName: string; apiVersion: string; apiId: string;
          issueId: string; subscriptionId: string; commentId: string;
          serviceName: string): Recallable =
  ## apiIssueCommentDelete
  ## Deletes the specified comment from an Issue.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   issueId: string (required)
  ##          : Issue identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   commentId: string (required)
  ##            : Comment identifier within an Issue. Must be unique in the current Issue.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594415 = newJObject()
  var query_594416 = newJObject()
  add(path_594415, "resourceGroupName", newJString(resourceGroupName))
  add(query_594416, "api-version", newJString(apiVersion))
  add(path_594415, "apiId", newJString(apiId))
  add(path_594415, "issueId", newJString(issueId))
  add(path_594415, "subscriptionId", newJString(subscriptionId))
  add(path_594415, "commentId", newJString(commentId))
  add(path_594415, "serviceName", newJString(serviceName))
  result = call_594414.call(path_594415, query_594416, nil, nil, nil)

var apiIssueCommentDelete* = Call_ApiIssueCommentDelete_594402(
    name: "apiIssueCommentDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/issues/{issueId}/comments/{commentId}",
    validator: validate_ApiIssueCommentDelete_594403, base: "",
    url: url_ApiIssueCommentDelete_594404, schemes: {Scheme.Https})
type
  Call_ApiOperationListByApi_594431 = ref object of OpenApiRestCall_593425
proc url_ApiOperationListByApi_594433(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/operations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiOperationListByApi_594432(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists a collection of the operations for the specified API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594434 = path.getOrDefault("resourceGroupName")
  valid_594434 = validateParameter(valid_594434, JString, required = true,
                                 default = nil)
  if valid_594434 != nil:
    section.add "resourceGroupName", valid_594434
  var valid_594435 = path.getOrDefault("apiId")
  valid_594435 = validateParameter(valid_594435, JString, required = true,
                                 default = nil)
  if valid_594435 != nil:
    section.add "apiId", valid_594435
  var valid_594436 = path.getOrDefault("subscriptionId")
  valid_594436 = validateParameter(valid_594436, JString, required = true,
                                 default = nil)
  if valid_594436 != nil:
    section.add "subscriptionId", valid_594436
  var valid_594437 = path.getOrDefault("serviceName")
  valid_594437 = validateParameter(valid_594437, JString, required = true,
                                 default = nil)
  if valid_594437 != nil:
    section.add "serviceName", valid_594437
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : Number of records to return.
  ##   $skip: JInt
  ##        : Number of records to skip.
  ##   $filter: JString
  ##          : | Field       | Supported operators    | Supported functions               |
  ## |-------------|------------------------|-----------------------------------|
  ## | name        | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  ## | method      | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  ## | description | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  ## | urlTemplate | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594438 = query.getOrDefault("api-version")
  valid_594438 = validateParameter(valid_594438, JString, required = true,
                                 default = nil)
  if valid_594438 != nil:
    section.add "api-version", valid_594438
  var valid_594439 = query.getOrDefault("$top")
  valid_594439 = validateParameter(valid_594439, JInt, required = false, default = nil)
  if valid_594439 != nil:
    section.add "$top", valid_594439
  var valid_594440 = query.getOrDefault("$skip")
  valid_594440 = validateParameter(valid_594440, JInt, required = false, default = nil)
  if valid_594440 != nil:
    section.add "$skip", valid_594440
  var valid_594441 = query.getOrDefault("$filter")
  valid_594441 = validateParameter(valid_594441, JString, required = false,
                                 default = nil)
  if valid_594441 != nil:
    section.add "$filter", valid_594441
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594442: Call_ApiOperationListByApi_594431; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a collection of the operations for the specified API.
  ## 
  let valid = call_594442.validator(path, query, header, formData, body)
  let scheme = call_594442.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594442.url(scheme.get, call_594442.host, call_594442.base,
                         call_594442.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594442, url, valid)

proc call*(call_594443: Call_ApiOperationListByApi_594431;
          resourceGroupName: string; apiVersion: string; apiId: string;
          subscriptionId: string; serviceName: string; Top: int = 0; Skip: int = 0;
          Filter: string = ""): Recallable =
  ## apiOperationListByApi
  ## Lists a collection of the operations for the specified API.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : Number of records to return.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   Filter: string
  ##         : | Field       | Supported operators    | Supported functions               |
  ## |-------------|------------------------|-----------------------------------|
  ## | name        | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  ## | method      | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  ## | description | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  ## | urlTemplate | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  var path_594444 = newJObject()
  var query_594445 = newJObject()
  add(path_594444, "resourceGroupName", newJString(resourceGroupName))
  add(query_594445, "api-version", newJString(apiVersion))
  add(path_594444, "apiId", newJString(apiId))
  add(path_594444, "subscriptionId", newJString(subscriptionId))
  add(query_594445, "$top", newJInt(Top))
  add(query_594445, "$skip", newJInt(Skip))
  add(path_594444, "serviceName", newJString(serviceName))
  add(query_594445, "$filter", newJString(Filter))
  result = call_594443.call(path_594444, query_594445, nil, nil, nil)

var apiOperationListByApi* = Call_ApiOperationListByApi_594431(
    name: "apiOperationListByApi", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/operations",
    validator: validate_ApiOperationListByApi_594432, base: "",
    url: url_ApiOperationListByApi_594433, schemes: {Scheme.Https})
type
  Call_ApiOperationCreateOrUpdate_594459 = ref object of OpenApiRestCall_593425
proc url_ApiOperationCreateOrUpdate_594461(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "operationId" in path, "`operationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/operations/"),
               (kind: VariableSegment, value: "operationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiOperationCreateOrUpdate_594460(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new operation in the API or updates an existing one.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   operationId: JString (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594462 = path.getOrDefault("resourceGroupName")
  valid_594462 = validateParameter(valid_594462, JString, required = true,
                                 default = nil)
  if valid_594462 != nil:
    section.add "resourceGroupName", valid_594462
  var valid_594463 = path.getOrDefault("apiId")
  valid_594463 = validateParameter(valid_594463, JString, required = true,
                                 default = nil)
  if valid_594463 != nil:
    section.add "apiId", valid_594463
  var valid_594464 = path.getOrDefault("subscriptionId")
  valid_594464 = validateParameter(valid_594464, JString, required = true,
                                 default = nil)
  if valid_594464 != nil:
    section.add "subscriptionId", valid_594464
  var valid_594465 = path.getOrDefault("serviceName")
  valid_594465 = validateParameter(valid_594465, JString, required = true,
                                 default = nil)
  if valid_594465 != nil:
    section.add "serviceName", valid_594465
  var valid_594466 = path.getOrDefault("operationId")
  valid_594466 = validateParameter(valid_594466, JString, required = true,
                                 default = nil)
  if valid_594466 != nil:
    section.add "operationId", valid_594466
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594467 = query.getOrDefault("api-version")
  valid_594467 = validateParameter(valid_594467, JString, required = true,
                                 default = nil)
  if valid_594467 != nil:
    section.add "api-version", valid_594467
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

proc call*(call_594469: Call_ApiOperationCreateOrUpdate_594459; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new operation in the API or updates an existing one.
  ## 
  let valid = call_594469.validator(path, query, header, formData, body)
  let scheme = call_594469.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594469.url(scheme.get, call_594469.host, call_594469.base,
                         call_594469.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594469, url, valid)

proc call*(call_594470: Call_ApiOperationCreateOrUpdate_594459;
          resourceGroupName: string; apiVersion: string; apiId: string;
          subscriptionId: string; parameters: JsonNode; serviceName: string;
          operationId: string): Recallable =
  ## apiOperationCreateOrUpdate
  ## Creates a new operation in the API or updates an existing one.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Create parameters.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   operationId: string (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  var path_594471 = newJObject()
  var query_594472 = newJObject()
  var body_594473 = newJObject()
  add(path_594471, "resourceGroupName", newJString(resourceGroupName))
  add(query_594472, "api-version", newJString(apiVersion))
  add(path_594471, "apiId", newJString(apiId))
  add(path_594471, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594473 = parameters
  add(path_594471, "serviceName", newJString(serviceName))
  add(path_594471, "operationId", newJString(operationId))
  result = call_594470.call(path_594471, query_594472, nil, nil, body_594473)

var apiOperationCreateOrUpdate* = Call_ApiOperationCreateOrUpdate_594459(
    name: "apiOperationCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/operations/{operationId}",
    validator: validate_ApiOperationCreateOrUpdate_594460, base: "",
    url: url_ApiOperationCreateOrUpdate_594461, schemes: {Scheme.Https})
type
  Call_ApiOperationGetEntityTag_594488 = ref object of OpenApiRestCall_593425
proc url_ApiOperationGetEntityTag_594490(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "operationId" in path, "`operationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/operations/"),
               (kind: VariableSegment, value: "operationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiOperationGetEntityTag_594489(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the entity state (Etag) version of the API operation specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   operationId: JString (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594491 = path.getOrDefault("resourceGroupName")
  valid_594491 = validateParameter(valid_594491, JString, required = true,
                                 default = nil)
  if valid_594491 != nil:
    section.add "resourceGroupName", valid_594491
  var valid_594492 = path.getOrDefault("apiId")
  valid_594492 = validateParameter(valid_594492, JString, required = true,
                                 default = nil)
  if valid_594492 != nil:
    section.add "apiId", valid_594492
  var valid_594493 = path.getOrDefault("subscriptionId")
  valid_594493 = validateParameter(valid_594493, JString, required = true,
                                 default = nil)
  if valid_594493 != nil:
    section.add "subscriptionId", valid_594493
  var valid_594494 = path.getOrDefault("serviceName")
  valid_594494 = validateParameter(valid_594494, JString, required = true,
                                 default = nil)
  if valid_594494 != nil:
    section.add "serviceName", valid_594494
  var valid_594495 = path.getOrDefault("operationId")
  valid_594495 = validateParameter(valid_594495, JString, required = true,
                                 default = nil)
  if valid_594495 != nil:
    section.add "operationId", valid_594495
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594496 = query.getOrDefault("api-version")
  valid_594496 = validateParameter(valid_594496, JString, required = true,
                                 default = nil)
  if valid_594496 != nil:
    section.add "api-version", valid_594496
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594497: Call_ApiOperationGetEntityTag_594488; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the entity state (Etag) version of the API operation specified by its identifier.
  ## 
  let valid = call_594497.validator(path, query, header, formData, body)
  let scheme = call_594497.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594497.url(scheme.get, call_594497.host, call_594497.base,
                         call_594497.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594497, url, valid)

proc call*(call_594498: Call_ApiOperationGetEntityTag_594488;
          resourceGroupName: string; apiVersion: string; apiId: string;
          subscriptionId: string; serviceName: string; operationId: string): Recallable =
  ## apiOperationGetEntityTag
  ## Gets the entity state (Etag) version of the API operation specified by its identifier.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   operationId: string (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  var path_594499 = newJObject()
  var query_594500 = newJObject()
  add(path_594499, "resourceGroupName", newJString(resourceGroupName))
  add(query_594500, "api-version", newJString(apiVersion))
  add(path_594499, "apiId", newJString(apiId))
  add(path_594499, "subscriptionId", newJString(subscriptionId))
  add(path_594499, "serviceName", newJString(serviceName))
  add(path_594499, "operationId", newJString(operationId))
  result = call_594498.call(path_594499, query_594500, nil, nil, nil)

var apiOperationGetEntityTag* = Call_ApiOperationGetEntityTag_594488(
    name: "apiOperationGetEntityTag", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/operations/{operationId}",
    validator: validate_ApiOperationGetEntityTag_594489, base: "",
    url: url_ApiOperationGetEntityTag_594490, schemes: {Scheme.Https})
type
  Call_ApiOperationGet_594446 = ref object of OpenApiRestCall_593425
proc url_ApiOperationGet_594448(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "operationId" in path, "`operationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/operations/"),
               (kind: VariableSegment, value: "operationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiOperationGet_594447(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Gets the details of the API Operation specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   operationId: JString (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594449 = path.getOrDefault("resourceGroupName")
  valid_594449 = validateParameter(valid_594449, JString, required = true,
                                 default = nil)
  if valid_594449 != nil:
    section.add "resourceGroupName", valid_594449
  var valid_594450 = path.getOrDefault("apiId")
  valid_594450 = validateParameter(valid_594450, JString, required = true,
                                 default = nil)
  if valid_594450 != nil:
    section.add "apiId", valid_594450
  var valid_594451 = path.getOrDefault("subscriptionId")
  valid_594451 = validateParameter(valid_594451, JString, required = true,
                                 default = nil)
  if valid_594451 != nil:
    section.add "subscriptionId", valid_594451
  var valid_594452 = path.getOrDefault("serviceName")
  valid_594452 = validateParameter(valid_594452, JString, required = true,
                                 default = nil)
  if valid_594452 != nil:
    section.add "serviceName", valid_594452
  var valid_594453 = path.getOrDefault("operationId")
  valid_594453 = validateParameter(valid_594453, JString, required = true,
                                 default = nil)
  if valid_594453 != nil:
    section.add "operationId", valid_594453
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594454 = query.getOrDefault("api-version")
  valid_594454 = validateParameter(valid_594454, JString, required = true,
                                 default = nil)
  if valid_594454 != nil:
    section.add "api-version", valid_594454
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594455: Call_ApiOperationGet_594446; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the API Operation specified by its identifier.
  ## 
  let valid = call_594455.validator(path, query, header, formData, body)
  let scheme = call_594455.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594455.url(scheme.get, call_594455.host, call_594455.base,
                         call_594455.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594455, url, valid)

proc call*(call_594456: Call_ApiOperationGet_594446; resourceGroupName: string;
          apiVersion: string; apiId: string; subscriptionId: string;
          serviceName: string; operationId: string): Recallable =
  ## apiOperationGet
  ## Gets the details of the API Operation specified by its identifier.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   operationId: string (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  var path_594457 = newJObject()
  var query_594458 = newJObject()
  add(path_594457, "resourceGroupName", newJString(resourceGroupName))
  add(query_594458, "api-version", newJString(apiVersion))
  add(path_594457, "apiId", newJString(apiId))
  add(path_594457, "subscriptionId", newJString(subscriptionId))
  add(path_594457, "serviceName", newJString(serviceName))
  add(path_594457, "operationId", newJString(operationId))
  result = call_594456.call(path_594457, query_594458, nil, nil, nil)

var apiOperationGet* = Call_ApiOperationGet_594446(name: "apiOperationGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/operations/{operationId}",
    validator: validate_ApiOperationGet_594447, base: "", url: url_ApiOperationGet_594448,
    schemes: {Scheme.Https})
type
  Call_ApiOperationUpdate_594501 = ref object of OpenApiRestCall_593425
proc url_ApiOperationUpdate_594503(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "operationId" in path, "`operationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/operations/"),
               (kind: VariableSegment, value: "operationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiOperationUpdate_594502(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Updates the details of the operation in the API specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   operationId: JString (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594504 = path.getOrDefault("resourceGroupName")
  valid_594504 = validateParameter(valid_594504, JString, required = true,
                                 default = nil)
  if valid_594504 != nil:
    section.add "resourceGroupName", valid_594504
  var valid_594505 = path.getOrDefault("apiId")
  valid_594505 = validateParameter(valid_594505, JString, required = true,
                                 default = nil)
  if valid_594505 != nil:
    section.add "apiId", valid_594505
  var valid_594506 = path.getOrDefault("subscriptionId")
  valid_594506 = validateParameter(valid_594506, JString, required = true,
                                 default = nil)
  if valid_594506 != nil:
    section.add "subscriptionId", valid_594506
  var valid_594507 = path.getOrDefault("serviceName")
  valid_594507 = validateParameter(valid_594507, JString, required = true,
                                 default = nil)
  if valid_594507 != nil:
    section.add "serviceName", valid_594507
  var valid_594508 = path.getOrDefault("operationId")
  valid_594508 = validateParameter(valid_594508, JString, required = true,
                                 default = nil)
  if valid_594508 != nil:
    section.add "operationId", valid_594508
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594509 = query.getOrDefault("api-version")
  valid_594509 = validateParameter(valid_594509, JString, required = true,
                                 default = nil)
  if valid_594509 != nil:
    section.add "api-version", valid_594509
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the API Operation Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_594510 = header.getOrDefault("If-Match")
  valid_594510 = validateParameter(valid_594510, JString, required = true,
                                 default = nil)
  if valid_594510 != nil:
    section.add "If-Match", valid_594510
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : API Operation Update parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594512: Call_ApiOperationUpdate_594501; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the details of the operation in the API specified by its identifier.
  ## 
  let valid = call_594512.validator(path, query, header, formData, body)
  let scheme = call_594512.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594512.url(scheme.get, call_594512.host, call_594512.base,
                         call_594512.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594512, url, valid)

proc call*(call_594513: Call_ApiOperationUpdate_594501; resourceGroupName: string;
          apiVersion: string; apiId: string; subscriptionId: string;
          parameters: JsonNode; serviceName: string; operationId: string): Recallable =
  ## apiOperationUpdate
  ## Updates the details of the operation in the API specified by its identifier.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : API Operation Update parameters.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   operationId: string (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  var path_594514 = newJObject()
  var query_594515 = newJObject()
  var body_594516 = newJObject()
  add(path_594514, "resourceGroupName", newJString(resourceGroupName))
  add(query_594515, "api-version", newJString(apiVersion))
  add(path_594514, "apiId", newJString(apiId))
  add(path_594514, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594516 = parameters
  add(path_594514, "serviceName", newJString(serviceName))
  add(path_594514, "operationId", newJString(operationId))
  result = call_594513.call(path_594514, query_594515, nil, nil, body_594516)

var apiOperationUpdate* = Call_ApiOperationUpdate_594501(
    name: "apiOperationUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/operations/{operationId}",
    validator: validate_ApiOperationUpdate_594502, base: "",
    url: url_ApiOperationUpdate_594503, schemes: {Scheme.Https})
type
  Call_ApiOperationDelete_594474 = ref object of OpenApiRestCall_593425
proc url_ApiOperationDelete_594476(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "operationId" in path, "`operationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/operations/"),
               (kind: VariableSegment, value: "operationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiOperationDelete_594475(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Deletes the specified operation in the API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   operationId: JString (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594477 = path.getOrDefault("resourceGroupName")
  valid_594477 = validateParameter(valid_594477, JString, required = true,
                                 default = nil)
  if valid_594477 != nil:
    section.add "resourceGroupName", valid_594477
  var valid_594478 = path.getOrDefault("apiId")
  valid_594478 = validateParameter(valid_594478, JString, required = true,
                                 default = nil)
  if valid_594478 != nil:
    section.add "apiId", valid_594478
  var valid_594479 = path.getOrDefault("subscriptionId")
  valid_594479 = validateParameter(valid_594479, JString, required = true,
                                 default = nil)
  if valid_594479 != nil:
    section.add "subscriptionId", valid_594479
  var valid_594480 = path.getOrDefault("serviceName")
  valid_594480 = validateParameter(valid_594480, JString, required = true,
                                 default = nil)
  if valid_594480 != nil:
    section.add "serviceName", valid_594480
  var valid_594481 = path.getOrDefault("operationId")
  valid_594481 = validateParameter(valid_594481, JString, required = true,
                                 default = nil)
  if valid_594481 != nil:
    section.add "operationId", valid_594481
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594482 = query.getOrDefault("api-version")
  valid_594482 = validateParameter(valid_594482, JString, required = true,
                                 default = nil)
  if valid_594482 != nil:
    section.add "api-version", valid_594482
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the API Operation Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_594483 = header.getOrDefault("If-Match")
  valid_594483 = validateParameter(valid_594483, JString, required = true,
                                 default = nil)
  if valid_594483 != nil:
    section.add "If-Match", valid_594483
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594484: Call_ApiOperationDelete_594474; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified operation in the API.
  ## 
  let valid = call_594484.validator(path, query, header, formData, body)
  let scheme = call_594484.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594484.url(scheme.get, call_594484.host, call_594484.base,
                         call_594484.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594484, url, valid)

proc call*(call_594485: Call_ApiOperationDelete_594474; resourceGroupName: string;
          apiVersion: string; apiId: string; subscriptionId: string;
          serviceName: string; operationId: string): Recallable =
  ## apiOperationDelete
  ## Deletes the specified operation in the API.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   operationId: string (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  var path_594486 = newJObject()
  var query_594487 = newJObject()
  add(path_594486, "resourceGroupName", newJString(resourceGroupName))
  add(query_594487, "api-version", newJString(apiVersion))
  add(path_594486, "apiId", newJString(apiId))
  add(path_594486, "subscriptionId", newJString(subscriptionId))
  add(path_594486, "serviceName", newJString(serviceName))
  add(path_594486, "operationId", newJString(operationId))
  result = call_594485.call(path_594486, query_594487, nil, nil, nil)

var apiOperationDelete* = Call_ApiOperationDelete_594474(
    name: "apiOperationDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/operations/{operationId}",
    validator: validate_ApiOperationDelete_594475, base: "",
    url: url_ApiOperationDelete_594476, schemes: {Scheme.Https})
type
  Call_ApiOperationPolicyListByOperation_594517 = ref object of OpenApiRestCall_593425
proc url_ApiOperationPolicyListByOperation_594519(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "operationId" in path, "`operationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/operations/"),
               (kind: VariableSegment, value: "operationId"),
               (kind: ConstantSegment, value: "/policies")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiOperationPolicyListByOperation_594518(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the list of policy configuration at the API Operation level.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   operationId: JString (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594520 = path.getOrDefault("resourceGroupName")
  valid_594520 = validateParameter(valid_594520, JString, required = true,
                                 default = nil)
  if valid_594520 != nil:
    section.add "resourceGroupName", valid_594520
  var valid_594521 = path.getOrDefault("apiId")
  valid_594521 = validateParameter(valid_594521, JString, required = true,
                                 default = nil)
  if valid_594521 != nil:
    section.add "apiId", valid_594521
  var valid_594522 = path.getOrDefault("subscriptionId")
  valid_594522 = validateParameter(valid_594522, JString, required = true,
                                 default = nil)
  if valid_594522 != nil:
    section.add "subscriptionId", valid_594522
  var valid_594523 = path.getOrDefault("serviceName")
  valid_594523 = validateParameter(valid_594523, JString, required = true,
                                 default = nil)
  if valid_594523 != nil:
    section.add "serviceName", valid_594523
  var valid_594524 = path.getOrDefault("operationId")
  valid_594524 = validateParameter(valid_594524, JString, required = true,
                                 default = nil)
  if valid_594524 != nil:
    section.add "operationId", valid_594524
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594525 = query.getOrDefault("api-version")
  valid_594525 = validateParameter(valid_594525, JString, required = true,
                                 default = nil)
  if valid_594525 != nil:
    section.add "api-version", valid_594525
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594526: Call_ApiOperationPolicyListByOperation_594517;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the list of policy configuration at the API Operation level.
  ## 
  let valid = call_594526.validator(path, query, header, formData, body)
  let scheme = call_594526.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594526.url(scheme.get, call_594526.host, call_594526.base,
                         call_594526.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594526, url, valid)

proc call*(call_594527: Call_ApiOperationPolicyListByOperation_594517;
          resourceGroupName: string; apiVersion: string; apiId: string;
          subscriptionId: string; serviceName: string; operationId: string): Recallable =
  ## apiOperationPolicyListByOperation
  ## Get the list of policy configuration at the API Operation level.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   operationId: string (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  var path_594528 = newJObject()
  var query_594529 = newJObject()
  add(path_594528, "resourceGroupName", newJString(resourceGroupName))
  add(query_594529, "api-version", newJString(apiVersion))
  add(path_594528, "apiId", newJString(apiId))
  add(path_594528, "subscriptionId", newJString(subscriptionId))
  add(path_594528, "serviceName", newJString(serviceName))
  add(path_594528, "operationId", newJString(operationId))
  result = call_594527.call(path_594528, query_594529, nil, nil, nil)

var apiOperationPolicyListByOperation* = Call_ApiOperationPolicyListByOperation_594517(
    name: "apiOperationPolicyListByOperation", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/operations/{operationId}/policies",
    validator: validate_ApiOperationPolicyListByOperation_594518, base: "",
    url: url_ApiOperationPolicyListByOperation_594519, schemes: {Scheme.Https})
type
  Call_ApiOperationPolicyCreateOrUpdate_594544 = ref object of OpenApiRestCall_593425
proc url_ApiOperationPolicyCreateOrUpdate_594546(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "operationId" in path, "`operationId` is a required path parameter"
  assert "policyId" in path, "`policyId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/operations/"),
               (kind: VariableSegment, value: "operationId"),
               (kind: ConstantSegment, value: "/policies/"),
               (kind: VariableSegment, value: "policyId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiOperationPolicyCreateOrUpdate_594545(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates policy configuration for the API Operation level.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   policyId: JString (required)
  ##           : The identifier of the Policy.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   operationId: JString (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594547 = path.getOrDefault("resourceGroupName")
  valid_594547 = validateParameter(valid_594547, JString, required = true,
                                 default = nil)
  if valid_594547 != nil:
    section.add "resourceGroupName", valid_594547
  var valid_594548 = path.getOrDefault("apiId")
  valid_594548 = validateParameter(valid_594548, JString, required = true,
                                 default = nil)
  if valid_594548 != nil:
    section.add "apiId", valid_594548
  var valid_594549 = path.getOrDefault("subscriptionId")
  valid_594549 = validateParameter(valid_594549, JString, required = true,
                                 default = nil)
  if valid_594549 != nil:
    section.add "subscriptionId", valid_594549
  var valid_594550 = path.getOrDefault("policyId")
  valid_594550 = validateParameter(valid_594550, JString, required = true,
                                 default = newJString("policy"))
  if valid_594550 != nil:
    section.add "policyId", valid_594550
  var valid_594551 = path.getOrDefault("serviceName")
  valid_594551 = validateParameter(valid_594551, JString, required = true,
                                 default = nil)
  if valid_594551 != nil:
    section.add "serviceName", valid_594551
  var valid_594552 = path.getOrDefault("operationId")
  valid_594552 = validateParameter(valid_594552, JString, required = true,
                                 default = nil)
  if valid_594552 != nil:
    section.add "operationId", valid_594552
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594553 = query.getOrDefault("api-version")
  valid_594553 = validateParameter(valid_594553, JString, required = true,
                                 default = nil)
  if valid_594553 != nil:
    section.add "api-version", valid_594553
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : The entity state (Etag) version of the Api Operation policy to update. A value of "*" can be used for If-Match to unconditionally apply the operation.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_594554 = header.getOrDefault("If-Match")
  valid_594554 = validateParameter(valid_594554, JString, required = true,
                                 default = nil)
  if valid_594554 != nil:
    section.add "If-Match", valid_594554
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The policy contents to apply.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594556: Call_ApiOperationPolicyCreateOrUpdate_594544;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates policy configuration for the API Operation level.
  ## 
  let valid = call_594556.validator(path, query, header, formData, body)
  let scheme = call_594556.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594556.url(scheme.get, call_594556.host, call_594556.base,
                         call_594556.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594556, url, valid)

proc call*(call_594557: Call_ApiOperationPolicyCreateOrUpdate_594544;
          resourceGroupName: string; apiVersion: string; apiId: string;
          subscriptionId: string; parameters: JsonNode; serviceName: string;
          operationId: string; policyId: string = "policy"): Recallable =
  ## apiOperationPolicyCreateOrUpdate
  ## Creates or updates policy configuration for the API Operation level.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   policyId: string (required)
  ##           : The identifier of the Policy.
  ##   parameters: JObject (required)
  ##             : The policy contents to apply.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   operationId: string (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  var path_594558 = newJObject()
  var query_594559 = newJObject()
  var body_594560 = newJObject()
  add(path_594558, "resourceGroupName", newJString(resourceGroupName))
  add(query_594559, "api-version", newJString(apiVersion))
  add(path_594558, "apiId", newJString(apiId))
  add(path_594558, "subscriptionId", newJString(subscriptionId))
  add(path_594558, "policyId", newJString(policyId))
  if parameters != nil:
    body_594560 = parameters
  add(path_594558, "serviceName", newJString(serviceName))
  add(path_594558, "operationId", newJString(operationId))
  result = call_594557.call(path_594558, query_594559, nil, nil, body_594560)

var apiOperationPolicyCreateOrUpdate* = Call_ApiOperationPolicyCreateOrUpdate_594544(
    name: "apiOperationPolicyCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/operations/{operationId}/policies/{policyId}",
    validator: validate_ApiOperationPolicyCreateOrUpdate_594545, base: "",
    url: url_ApiOperationPolicyCreateOrUpdate_594546, schemes: {Scheme.Https})
type
  Call_ApiOperationPolicyGetEntityTag_594576 = ref object of OpenApiRestCall_593425
proc url_ApiOperationPolicyGetEntityTag_594578(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "operationId" in path, "`operationId` is a required path parameter"
  assert "policyId" in path, "`policyId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/operations/"),
               (kind: VariableSegment, value: "operationId"),
               (kind: ConstantSegment, value: "/policies/"),
               (kind: VariableSegment, value: "policyId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiOperationPolicyGetEntityTag_594577(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the entity state (Etag) version of the API operation policy specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   policyId: JString (required)
  ##           : The identifier of the Policy.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   operationId: JString (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594579 = path.getOrDefault("resourceGroupName")
  valid_594579 = validateParameter(valid_594579, JString, required = true,
                                 default = nil)
  if valid_594579 != nil:
    section.add "resourceGroupName", valid_594579
  var valid_594580 = path.getOrDefault("apiId")
  valid_594580 = validateParameter(valid_594580, JString, required = true,
                                 default = nil)
  if valid_594580 != nil:
    section.add "apiId", valid_594580
  var valid_594581 = path.getOrDefault("subscriptionId")
  valid_594581 = validateParameter(valid_594581, JString, required = true,
                                 default = nil)
  if valid_594581 != nil:
    section.add "subscriptionId", valid_594581
  var valid_594582 = path.getOrDefault("policyId")
  valid_594582 = validateParameter(valid_594582, JString, required = true,
                                 default = newJString("policy"))
  if valid_594582 != nil:
    section.add "policyId", valid_594582
  var valid_594583 = path.getOrDefault("serviceName")
  valid_594583 = validateParameter(valid_594583, JString, required = true,
                                 default = nil)
  if valid_594583 != nil:
    section.add "serviceName", valid_594583
  var valid_594584 = path.getOrDefault("operationId")
  valid_594584 = validateParameter(valid_594584, JString, required = true,
                                 default = nil)
  if valid_594584 != nil:
    section.add "operationId", valid_594584
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594585 = query.getOrDefault("api-version")
  valid_594585 = validateParameter(valid_594585, JString, required = true,
                                 default = nil)
  if valid_594585 != nil:
    section.add "api-version", valid_594585
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594586: Call_ApiOperationPolicyGetEntityTag_594576; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the entity state (Etag) version of the API operation policy specified by its identifier.
  ## 
  let valid = call_594586.validator(path, query, header, formData, body)
  let scheme = call_594586.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594586.url(scheme.get, call_594586.host, call_594586.base,
                         call_594586.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594586, url, valid)

proc call*(call_594587: Call_ApiOperationPolicyGetEntityTag_594576;
          resourceGroupName: string; apiVersion: string; apiId: string;
          subscriptionId: string; serviceName: string; operationId: string;
          policyId: string = "policy"): Recallable =
  ## apiOperationPolicyGetEntityTag
  ## Gets the entity state (Etag) version of the API operation policy specified by its identifier.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   policyId: string (required)
  ##           : The identifier of the Policy.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   operationId: string (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  var path_594588 = newJObject()
  var query_594589 = newJObject()
  add(path_594588, "resourceGroupName", newJString(resourceGroupName))
  add(query_594589, "api-version", newJString(apiVersion))
  add(path_594588, "apiId", newJString(apiId))
  add(path_594588, "subscriptionId", newJString(subscriptionId))
  add(path_594588, "policyId", newJString(policyId))
  add(path_594588, "serviceName", newJString(serviceName))
  add(path_594588, "operationId", newJString(operationId))
  result = call_594587.call(path_594588, query_594589, nil, nil, nil)

var apiOperationPolicyGetEntityTag* = Call_ApiOperationPolicyGetEntityTag_594576(
    name: "apiOperationPolicyGetEntityTag", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/operations/{operationId}/policies/{policyId}",
    validator: validate_ApiOperationPolicyGetEntityTag_594577, base: "",
    url: url_ApiOperationPolicyGetEntityTag_594578, schemes: {Scheme.Https})
type
  Call_ApiOperationPolicyGet_594530 = ref object of OpenApiRestCall_593425
proc url_ApiOperationPolicyGet_594532(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "operationId" in path, "`operationId` is a required path parameter"
  assert "policyId" in path, "`policyId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/operations/"),
               (kind: VariableSegment, value: "operationId"),
               (kind: ConstantSegment, value: "/policies/"),
               (kind: VariableSegment, value: "policyId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiOperationPolicyGet_594531(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the policy configuration at the API Operation level.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   policyId: JString (required)
  ##           : The identifier of the Policy.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   operationId: JString (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594533 = path.getOrDefault("resourceGroupName")
  valid_594533 = validateParameter(valid_594533, JString, required = true,
                                 default = nil)
  if valid_594533 != nil:
    section.add "resourceGroupName", valid_594533
  var valid_594534 = path.getOrDefault("apiId")
  valid_594534 = validateParameter(valid_594534, JString, required = true,
                                 default = nil)
  if valid_594534 != nil:
    section.add "apiId", valid_594534
  var valid_594535 = path.getOrDefault("subscriptionId")
  valid_594535 = validateParameter(valid_594535, JString, required = true,
                                 default = nil)
  if valid_594535 != nil:
    section.add "subscriptionId", valid_594535
  var valid_594536 = path.getOrDefault("policyId")
  valid_594536 = validateParameter(valid_594536, JString, required = true,
                                 default = newJString("policy"))
  if valid_594536 != nil:
    section.add "policyId", valid_594536
  var valid_594537 = path.getOrDefault("serviceName")
  valid_594537 = validateParameter(valid_594537, JString, required = true,
                                 default = nil)
  if valid_594537 != nil:
    section.add "serviceName", valid_594537
  var valid_594538 = path.getOrDefault("operationId")
  valid_594538 = validateParameter(valid_594538, JString, required = true,
                                 default = nil)
  if valid_594538 != nil:
    section.add "operationId", valid_594538
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594539 = query.getOrDefault("api-version")
  valid_594539 = validateParameter(valid_594539, JString, required = true,
                                 default = nil)
  if valid_594539 != nil:
    section.add "api-version", valid_594539
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594540: Call_ApiOperationPolicyGet_594530; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the policy configuration at the API Operation level.
  ## 
  let valid = call_594540.validator(path, query, header, formData, body)
  let scheme = call_594540.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594540.url(scheme.get, call_594540.host, call_594540.base,
                         call_594540.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594540, url, valid)

proc call*(call_594541: Call_ApiOperationPolicyGet_594530;
          resourceGroupName: string; apiVersion: string; apiId: string;
          subscriptionId: string; serviceName: string; operationId: string;
          policyId: string = "policy"): Recallable =
  ## apiOperationPolicyGet
  ## Get the policy configuration at the API Operation level.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   policyId: string (required)
  ##           : The identifier of the Policy.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   operationId: string (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  var path_594542 = newJObject()
  var query_594543 = newJObject()
  add(path_594542, "resourceGroupName", newJString(resourceGroupName))
  add(query_594543, "api-version", newJString(apiVersion))
  add(path_594542, "apiId", newJString(apiId))
  add(path_594542, "subscriptionId", newJString(subscriptionId))
  add(path_594542, "policyId", newJString(policyId))
  add(path_594542, "serviceName", newJString(serviceName))
  add(path_594542, "operationId", newJString(operationId))
  result = call_594541.call(path_594542, query_594543, nil, nil, nil)

var apiOperationPolicyGet* = Call_ApiOperationPolicyGet_594530(
    name: "apiOperationPolicyGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/operations/{operationId}/policies/{policyId}",
    validator: validate_ApiOperationPolicyGet_594531, base: "",
    url: url_ApiOperationPolicyGet_594532, schemes: {Scheme.Https})
type
  Call_ApiOperationPolicyDelete_594561 = ref object of OpenApiRestCall_593425
proc url_ApiOperationPolicyDelete_594563(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "operationId" in path, "`operationId` is a required path parameter"
  assert "policyId" in path, "`policyId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/operations/"),
               (kind: VariableSegment, value: "operationId"),
               (kind: ConstantSegment, value: "/policies/"),
               (kind: VariableSegment, value: "policyId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiOperationPolicyDelete_594562(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the policy configuration at the Api Operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   policyId: JString (required)
  ##           : The identifier of the Policy.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   operationId: JString (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594564 = path.getOrDefault("resourceGroupName")
  valid_594564 = validateParameter(valid_594564, JString, required = true,
                                 default = nil)
  if valid_594564 != nil:
    section.add "resourceGroupName", valid_594564
  var valid_594565 = path.getOrDefault("apiId")
  valid_594565 = validateParameter(valid_594565, JString, required = true,
                                 default = nil)
  if valid_594565 != nil:
    section.add "apiId", valid_594565
  var valid_594566 = path.getOrDefault("subscriptionId")
  valid_594566 = validateParameter(valid_594566, JString, required = true,
                                 default = nil)
  if valid_594566 != nil:
    section.add "subscriptionId", valid_594566
  var valid_594567 = path.getOrDefault("policyId")
  valid_594567 = validateParameter(valid_594567, JString, required = true,
                                 default = newJString("policy"))
  if valid_594567 != nil:
    section.add "policyId", valid_594567
  var valid_594568 = path.getOrDefault("serviceName")
  valid_594568 = validateParameter(valid_594568, JString, required = true,
                                 default = nil)
  if valid_594568 != nil:
    section.add "serviceName", valid_594568
  var valid_594569 = path.getOrDefault("operationId")
  valid_594569 = validateParameter(valid_594569, JString, required = true,
                                 default = nil)
  if valid_594569 != nil:
    section.add "operationId", valid_594569
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594570 = query.getOrDefault("api-version")
  valid_594570 = validateParameter(valid_594570, JString, required = true,
                                 default = nil)
  if valid_594570 != nil:
    section.add "api-version", valid_594570
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : The entity state (Etag) version of the Api Operation Policy to delete. A value of "*" can be used for If-Match to unconditionally apply the operation.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_594571 = header.getOrDefault("If-Match")
  valid_594571 = validateParameter(valid_594571, JString, required = true,
                                 default = nil)
  if valid_594571 != nil:
    section.add "If-Match", valid_594571
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594572: Call_ApiOperationPolicyDelete_594561; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the policy configuration at the Api Operation.
  ## 
  let valid = call_594572.validator(path, query, header, formData, body)
  let scheme = call_594572.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594572.url(scheme.get, call_594572.host, call_594572.base,
                         call_594572.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594572, url, valid)

proc call*(call_594573: Call_ApiOperationPolicyDelete_594561;
          resourceGroupName: string; apiVersion: string; apiId: string;
          subscriptionId: string; serviceName: string; operationId: string;
          policyId: string = "policy"): Recallable =
  ## apiOperationPolicyDelete
  ## Deletes the policy configuration at the Api Operation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   policyId: string (required)
  ##           : The identifier of the Policy.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   operationId: string (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  var path_594574 = newJObject()
  var query_594575 = newJObject()
  add(path_594574, "resourceGroupName", newJString(resourceGroupName))
  add(query_594575, "api-version", newJString(apiVersion))
  add(path_594574, "apiId", newJString(apiId))
  add(path_594574, "subscriptionId", newJString(subscriptionId))
  add(path_594574, "policyId", newJString(policyId))
  add(path_594574, "serviceName", newJString(serviceName))
  add(path_594574, "operationId", newJString(operationId))
  result = call_594573.call(path_594574, query_594575, nil, nil, nil)

var apiOperationPolicyDelete* = Call_ApiOperationPolicyDelete_594561(
    name: "apiOperationPolicyDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/operations/{operationId}/policies/{policyId}",
    validator: validate_ApiOperationPolicyDelete_594562, base: "",
    url: url_ApiOperationPolicyDelete_594563, schemes: {Scheme.Https})
type
  Call_ApiPolicyListByApi_594590 = ref object of OpenApiRestCall_593425
proc url_ApiPolicyListByApi_594592(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/policies")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiPolicyListByApi_594591(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Get the policy configuration at the API level.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594593 = path.getOrDefault("resourceGroupName")
  valid_594593 = validateParameter(valid_594593, JString, required = true,
                                 default = nil)
  if valid_594593 != nil:
    section.add "resourceGroupName", valid_594593
  var valid_594594 = path.getOrDefault("apiId")
  valid_594594 = validateParameter(valid_594594, JString, required = true,
                                 default = nil)
  if valid_594594 != nil:
    section.add "apiId", valid_594594
  var valid_594595 = path.getOrDefault("subscriptionId")
  valid_594595 = validateParameter(valid_594595, JString, required = true,
                                 default = nil)
  if valid_594595 != nil:
    section.add "subscriptionId", valid_594595
  var valid_594596 = path.getOrDefault("serviceName")
  valid_594596 = validateParameter(valid_594596, JString, required = true,
                                 default = nil)
  if valid_594596 != nil:
    section.add "serviceName", valid_594596
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594597 = query.getOrDefault("api-version")
  valid_594597 = validateParameter(valid_594597, JString, required = true,
                                 default = nil)
  if valid_594597 != nil:
    section.add "api-version", valid_594597
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594598: Call_ApiPolicyListByApi_594590; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the policy configuration at the API level.
  ## 
  let valid = call_594598.validator(path, query, header, formData, body)
  let scheme = call_594598.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594598.url(scheme.get, call_594598.host, call_594598.base,
                         call_594598.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594598, url, valid)

proc call*(call_594599: Call_ApiPolicyListByApi_594590; resourceGroupName: string;
          apiVersion: string; apiId: string; subscriptionId: string;
          serviceName: string): Recallable =
  ## apiPolicyListByApi
  ## Get the policy configuration at the API level.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594600 = newJObject()
  var query_594601 = newJObject()
  add(path_594600, "resourceGroupName", newJString(resourceGroupName))
  add(query_594601, "api-version", newJString(apiVersion))
  add(path_594600, "apiId", newJString(apiId))
  add(path_594600, "subscriptionId", newJString(subscriptionId))
  add(path_594600, "serviceName", newJString(serviceName))
  result = call_594599.call(path_594600, query_594601, nil, nil, nil)

var apiPolicyListByApi* = Call_ApiPolicyListByApi_594590(
    name: "apiPolicyListByApi", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/policies",
    validator: validate_ApiPolicyListByApi_594591, base: "",
    url: url_ApiPolicyListByApi_594592, schemes: {Scheme.Https})
type
  Call_ApiPolicyCreateOrUpdate_594615 = ref object of OpenApiRestCall_593425
proc url_ApiPolicyCreateOrUpdate_594617(protocol: Scheme; host: string; base: string;
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
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "policyId" in path, "`policyId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/policies/"),
               (kind: VariableSegment, value: "policyId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiPolicyCreateOrUpdate_594616(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates policy configuration for the API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   policyId: JString (required)
  ##           : The identifier of the Policy.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594618 = path.getOrDefault("resourceGroupName")
  valid_594618 = validateParameter(valid_594618, JString, required = true,
                                 default = nil)
  if valid_594618 != nil:
    section.add "resourceGroupName", valid_594618
  var valid_594619 = path.getOrDefault("apiId")
  valid_594619 = validateParameter(valid_594619, JString, required = true,
                                 default = nil)
  if valid_594619 != nil:
    section.add "apiId", valid_594619
  var valid_594620 = path.getOrDefault("subscriptionId")
  valid_594620 = validateParameter(valid_594620, JString, required = true,
                                 default = nil)
  if valid_594620 != nil:
    section.add "subscriptionId", valid_594620
  var valid_594621 = path.getOrDefault("policyId")
  valid_594621 = validateParameter(valid_594621, JString, required = true,
                                 default = newJString("policy"))
  if valid_594621 != nil:
    section.add "policyId", valid_594621
  var valid_594622 = path.getOrDefault("serviceName")
  valid_594622 = validateParameter(valid_594622, JString, required = true,
                                 default = nil)
  if valid_594622 != nil:
    section.add "serviceName", valid_594622
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594623 = query.getOrDefault("api-version")
  valid_594623 = validateParameter(valid_594623, JString, required = true,
                                 default = nil)
  if valid_594623 != nil:
    section.add "api-version", valid_594623
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : The entity state (Etag) version of the Api Policy to update. A value of "*" can be used for If-Match to unconditionally apply the operation.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_594624 = header.getOrDefault("If-Match")
  valid_594624 = validateParameter(valid_594624, JString, required = true,
                                 default = nil)
  if valid_594624 != nil:
    section.add "If-Match", valid_594624
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The policy contents to apply.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594626: Call_ApiPolicyCreateOrUpdate_594615; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates policy configuration for the API.
  ## 
  let valid = call_594626.validator(path, query, header, formData, body)
  let scheme = call_594626.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594626.url(scheme.get, call_594626.host, call_594626.base,
                         call_594626.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594626, url, valid)

proc call*(call_594627: Call_ApiPolicyCreateOrUpdate_594615;
          resourceGroupName: string; apiVersion: string; apiId: string;
          subscriptionId: string; parameters: JsonNode; serviceName: string;
          policyId: string = "policy"): Recallable =
  ## apiPolicyCreateOrUpdate
  ## Creates or updates policy configuration for the API.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   policyId: string (required)
  ##           : The identifier of the Policy.
  ##   parameters: JObject (required)
  ##             : The policy contents to apply.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594628 = newJObject()
  var query_594629 = newJObject()
  var body_594630 = newJObject()
  add(path_594628, "resourceGroupName", newJString(resourceGroupName))
  add(query_594629, "api-version", newJString(apiVersion))
  add(path_594628, "apiId", newJString(apiId))
  add(path_594628, "subscriptionId", newJString(subscriptionId))
  add(path_594628, "policyId", newJString(policyId))
  if parameters != nil:
    body_594630 = parameters
  add(path_594628, "serviceName", newJString(serviceName))
  result = call_594627.call(path_594628, query_594629, nil, nil, body_594630)

var apiPolicyCreateOrUpdate* = Call_ApiPolicyCreateOrUpdate_594615(
    name: "apiPolicyCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/policies/{policyId}",
    validator: validate_ApiPolicyCreateOrUpdate_594616, base: "",
    url: url_ApiPolicyCreateOrUpdate_594617, schemes: {Scheme.Https})
type
  Call_ApiPolicyGetEntityTag_594645 = ref object of OpenApiRestCall_593425
proc url_ApiPolicyGetEntityTag_594647(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "policyId" in path, "`policyId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/policies/"),
               (kind: VariableSegment, value: "policyId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiPolicyGetEntityTag_594646(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the entity state (Etag) version of the API policy specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   policyId: JString (required)
  ##           : The identifier of the Policy.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594648 = path.getOrDefault("resourceGroupName")
  valid_594648 = validateParameter(valid_594648, JString, required = true,
                                 default = nil)
  if valid_594648 != nil:
    section.add "resourceGroupName", valid_594648
  var valid_594649 = path.getOrDefault("apiId")
  valid_594649 = validateParameter(valid_594649, JString, required = true,
                                 default = nil)
  if valid_594649 != nil:
    section.add "apiId", valid_594649
  var valid_594650 = path.getOrDefault("subscriptionId")
  valid_594650 = validateParameter(valid_594650, JString, required = true,
                                 default = nil)
  if valid_594650 != nil:
    section.add "subscriptionId", valid_594650
  var valid_594651 = path.getOrDefault("policyId")
  valid_594651 = validateParameter(valid_594651, JString, required = true,
                                 default = newJString("policy"))
  if valid_594651 != nil:
    section.add "policyId", valid_594651
  var valid_594652 = path.getOrDefault("serviceName")
  valid_594652 = validateParameter(valid_594652, JString, required = true,
                                 default = nil)
  if valid_594652 != nil:
    section.add "serviceName", valid_594652
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594653 = query.getOrDefault("api-version")
  valid_594653 = validateParameter(valid_594653, JString, required = true,
                                 default = nil)
  if valid_594653 != nil:
    section.add "api-version", valid_594653
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594654: Call_ApiPolicyGetEntityTag_594645; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the entity state (Etag) version of the API policy specified by its identifier.
  ## 
  let valid = call_594654.validator(path, query, header, formData, body)
  let scheme = call_594654.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594654.url(scheme.get, call_594654.host, call_594654.base,
                         call_594654.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594654, url, valid)

proc call*(call_594655: Call_ApiPolicyGetEntityTag_594645;
          resourceGroupName: string; apiVersion: string; apiId: string;
          subscriptionId: string; serviceName: string; policyId: string = "policy"): Recallable =
  ## apiPolicyGetEntityTag
  ## Gets the entity state (Etag) version of the API policy specified by its identifier.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   policyId: string (required)
  ##           : The identifier of the Policy.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594656 = newJObject()
  var query_594657 = newJObject()
  add(path_594656, "resourceGroupName", newJString(resourceGroupName))
  add(query_594657, "api-version", newJString(apiVersion))
  add(path_594656, "apiId", newJString(apiId))
  add(path_594656, "subscriptionId", newJString(subscriptionId))
  add(path_594656, "policyId", newJString(policyId))
  add(path_594656, "serviceName", newJString(serviceName))
  result = call_594655.call(path_594656, query_594657, nil, nil, nil)

var apiPolicyGetEntityTag* = Call_ApiPolicyGetEntityTag_594645(
    name: "apiPolicyGetEntityTag", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/policies/{policyId}",
    validator: validate_ApiPolicyGetEntityTag_594646, base: "",
    url: url_ApiPolicyGetEntityTag_594647, schemes: {Scheme.Https})
type
  Call_ApiPolicyGet_594602 = ref object of OpenApiRestCall_593425
proc url_ApiPolicyGet_594604(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "policyId" in path, "`policyId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/policies/"),
               (kind: VariableSegment, value: "policyId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiPolicyGet_594603(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the policy configuration at the API level.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   policyId: JString (required)
  ##           : The identifier of the Policy.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594605 = path.getOrDefault("resourceGroupName")
  valid_594605 = validateParameter(valid_594605, JString, required = true,
                                 default = nil)
  if valid_594605 != nil:
    section.add "resourceGroupName", valid_594605
  var valid_594606 = path.getOrDefault("apiId")
  valid_594606 = validateParameter(valid_594606, JString, required = true,
                                 default = nil)
  if valid_594606 != nil:
    section.add "apiId", valid_594606
  var valid_594607 = path.getOrDefault("subscriptionId")
  valid_594607 = validateParameter(valid_594607, JString, required = true,
                                 default = nil)
  if valid_594607 != nil:
    section.add "subscriptionId", valid_594607
  var valid_594608 = path.getOrDefault("policyId")
  valid_594608 = validateParameter(valid_594608, JString, required = true,
                                 default = newJString("policy"))
  if valid_594608 != nil:
    section.add "policyId", valid_594608
  var valid_594609 = path.getOrDefault("serviceName")
  valid_594609 = validateParameter(valid_594609, JString, required = true,
                                 default = nil)
  if valid_594609 != nil:
    section.add "serviceName", valid_594609
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594610 = query.getOrDefault("api-version")
  valid_594610 = validateParameter(valid_594610, JString, required = true,
                                 default = nil)
  if valid_594610 != nil:
    section.add "api-version", valid_594610
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594611: Call_ApiPolicyGet_594602; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the policy configuration at the API level.
  ## 
  let valid = call_594611.validator(path, query, header, formData, body)
  let scheme = call_594611.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594611.url(scheme.get, call_594611.host, call_594611.base,
                         call_594611.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594611, url, valid)

proc call*(call_594612: Call_ApiPolicyGet_594602; resourceGroupName: string;
          apiVersion: string; apiId: string; subscriptionId: string;
          serviceName: string; policyId: string = "policy"): Recallable =
  ## apiPolicyGet
  ## Get the policy configuration at the API level.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   policyId: string (required)
  ##           : The identifier of the Policy.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594613 = newJObject()
  var query_594614 = newJObject()
  add(path_594613, "resourceGroupName", newJString(resourceGroupName))
  add(query_594614, "api-version", newJString(apiVersion))
  add(path_594613, "apiId", newJString(apiId))
  add(path_594613, "subscriptionId", newJString(subscriptionId))
  add(path_594613, "policyId", newJString(policyId))
  add(path_594613, "serviceName", newJString(serviceName))
  result = call_594612.call(path_594613, query_594614, nil, nil, nil)

var apiPolicyGet* = Call_ApiPolicyGet_594602(name: "apiPolicyGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/policies/{policyId}",
    validator: validate_ApiPolicyGet_594603, base: "", url: url_ApiPolicyGet_594604,
    schemes: {Scheme.Https})
type
  Call_ApiPolicyDelete_594631 = ref object of OpenApiRestCall_593425
proc url_ApiPolicyDelete_594633(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "policyId" in path, "`policyId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/policies/"),
               (kind: VariableSegment, value: "policyId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiPolicyDelete_594632(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Deletes the policy configuration at the Api.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   policyId: JString (required)
  ##           : The identifier of the Policy.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594634 = path.getOrDefault("resourceGroupName")
  valid_594634 = validateParameter(valid_594634, JString, required = true,
                                 default = nil)
  if valid_594634 != nil:
    section.add "resourceGroupName", valid_594634
  var valid_594635 = path.getOrDefault("apiId")
  valid_594635 = validateParameter(valid_594635, JString, required = true,
                                 default = nil)
  if valid_594635 != nil:
    section.add "apiId", valid_594635
  var valid_594636 = path.getOrDefault("subscriptionId")
  valid_594636 = validateParameter(valid_594636, JString, required = true,
                                 default = nil)
  if valid_594636 != nil:
    section.add "subscriptionId", valid_594636
  var valid_594637 = path.getOrDefault("policyId")
  valid_594637 = validateParameter(valid_594637, JString, required = true,
                                 default = newJString("policy"))
  if valid_594637 != nil:
    section.add "policyId", valid_594637
  var valid_594638 = path.getOrDefault("serviceName")
  valid_594638 = validateParameter(valid_594638, JString, required = true,
                                 default = nil)
  if valid_594638 != nil:
    section.add "serviceName", valid_594638
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594639 = query.getOrDefault("api-version")
  valid_594639 = validateParameter(valid_594639, JString, required = true,
                                 default = nil)
  if valid_594639 != nil:
    section.add "api-version", valid_594639
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : The entity state (Etag) version of the Api policy to update. A value of "*" can be used for If-Match to unconditionally apply the operation.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_594640 = header.getOrDefault("If-Match")
  valid_594640 = validateParameter(valid_594640, JString, required = true,
                                 default = nil)
  if valid_594640 != nil:
    section.add "If-Match", valid_594640
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594641: Call_ApiPolicyDelete_594631; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the policy configuration at the Api.
  ## 
  let valid = call_594641.validator(path, query, header, formData, body)
  let scheme = call_594641.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594641.url(scheme.get, call_594641.host, call_594641.base,
                         call_594641.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594641, url, valid)

proc call*(call_594642: Call_ApiPolicyDelete_594631; resourceGroupName: string;
          apiVersion: string; apiId: string; subscriptionId: string;
          serviceName: string; policyId: string = "policy"): Recallable =
  ## apiPolicyDelete
  ## Deletes the policy configuration at the Api.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   policyId: string (required)
  ##           : The identifier of the Policy.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594643 = newJObject()
  var query_594644 = newJObject()
  add(path_594643, "resourceGroupName", newJString(resourceGroupName))
  add(query_594644, "api-version", newJString(apiVersion))
  add(path_594643, "apiId", newJString(apiId))
  add(path_594643, "subscriptionId", newJString(subscriptionId))
  add(path_594643, "policyId", newJString(policyId))
  add(path_594643, "serviceName", newJString(serviceName))
  result = call_594642.call(path_594643, query_594644, nil, nil, nil)

var apiPolicyDelete* = Call_ApiPolicyDelete_594631(name: "apiPolicyDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/policies/{policyId}",
    validator: validate_ApiPolicyDelete_594632, base: "", url: url_ApiPolicyDelete_594633,
    schemes: {Scheme.Https})
type
  Call_ApiProductListByApis_594658 = ref object of OpenApiRestCall_593425
proc url_ApiProductListByApis_594660(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/products")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiProductListByApis_594659(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all Products, which the API is part of.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594661 = path.getOrDefault("resourceGroupName")
  valid_594661 = validateParameter(valid_594661, JString, required = true,
                                 default = nil)
  if valid_594661 != nil:
    section.add "resourceGroupName", valid_594661
  var valid_594662 = path.getOrDefault("apiId")
  valid_594662 = validateParameter(valid_594662, JString, required = true,
                                 default = nil)
  if valid_594662 != nil:
    section.add "apiId", valid_594662
  var valid_594663 = path.getOrDefault("subscriptionId")
  valid_594663 = validateParameter(valid_594663, JString, required = true,
                                 default = nil)
  if valid_594663 != nil:
    section.add "subscriptionId", valid_594663
  var valid_594664 = path.getOrDefault("serviceName")
  valid_594664 = validateParameter(valid_594664, JString, required = true,
                                 default = nil)
  if valid_594664 != nil:
    section.add "serviceName", valid_594664
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
  ## | name  | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594665 = query.getOrDefault("api-version")
  valid_594665 = validateParameter(valid_594665, JString, required = true,
                                 default = nil)
  if valid_594665 != nil:
    section.add "api-version", valid_594665
  var valid_594666 = query.getOrDefault("$top")
  valid_594666 = validateParameter(valid_594666, JInt, required = false, default = nil)
  if valid_594666 != nil:
    section.add "$top", valid_594666
  var valid_594667 = query.getOrDefault("$skip")
  valid_594667 = validateParameter(valid_594667, JInt, required = false, default = nil)
  if valid_594667 != nil:
    section.add "$skip", valid_594667
  var valid_594668 = query.getOrDefault("$filter")
  valid_594668 = validateParameter(valid_594668, JString, required = false,
                                 default = nil)
  if valid_594668 != nil:
    section.add "$filter", valid_594668
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594669: Call_ApiProductListByApis_594658; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all Products, which the API is part of.
  ## 
  let valid = call_594669.validator(path, query, header, formData, body)
  let scheme = call_594669.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594669.url(scheme.get, call_594669.host, call_594669.base,
                         call_594669.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594669, url, valid)

proc call*(call_594670: Call_ApiProductListByApis_594658;
          resourceGroupName: string; apiVersion: string; apiId: string;
          subscriptionId: string; serviceName: string; Top: int = 0; Skip: int = 0;
          Filter: string = ""): Recallable =
  ## apiProductListByApis
  ## Lists all Products, which the API is part of.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
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
  ## | name  | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  var path_594671 = newJObject()
  var query_594672 = newJObject()
  add(path_594671, "resourceGroupName", newJString(resourceGroupName))
  add(query_594672, "api-version", newJString(apiVersion))
  add(path_594671, "apiId", newJString(apiId))
  add(path_594671, "subscriptionId", newJString(subscriptionId))
  add(query_594672, "$top", newJInt(Top))
  add(query_594672, "$skip", newJInt(Skip))
  add(path_594671, "serviceName", newJString(serviceName))
  add(query_594672, "$filter", newJString(Filter))
  result = call_594670.call(path_594671, query_594672, nil, nil, nil)

var apiProductListByApis* = Call_ApiProductListByApis_594658(
    name: "apiProductListByApis", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/products",
    validator: validate_ApiProductListByApis_594659, base: "",
    url: url_ApiProductListByApis_594660, schemes: {Scheme.Https})
type
  Call_ApiReleaseList_594673 = ref object of OpenApiRestCall_593425
proc url_ApiReleaseList_594675(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/releases")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiReleaseList_594674(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists all releases of an API. An API release is created when making an API Revision current. Releases are also used to rollback to previous revisions. Results will be paged and can be constrained by the $top and $skip parameters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594676 = path.getOrDefault("resourceGroupName")
  valid_594676 = validateParameter(valid_594676, JString, required = true,
                                 default = nil)
  if valid_594676 != nil:
    section.add "resourceGroupName", valid_594676
  var valid_594677 = path.getOrDefault("apiId")
  valid_594677 = validateParameter(valid_594677, JString, required = true,
                                 default = nil)
  if valid_594677 != nil:
    section.add "apiId", valid_594677
  var valid_594678 = path.getOrDefault("subscriptionId")
  valid_594678 = validateParameter(valid_594678, JString, required = true,
                                 default = nil)
  if valid_594678 != nil:
    section.add "subscriptionId", valid_594678
  var valid_594679 = path.getOrDefault("serviceName")
  valid_594679 = validateParameter(valid_594679, JString, required = true,
                                 default = nil)
  if valid_594679 != nil:
    section.add "serviceName", valid_594679
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
  ## | name  | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## |notes|ge le eq ne gt lt|substringof contains startswith endswith|
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594680 = query.getOrDefault("api-version")
  valid_594680 = validateParameter(valid_594680, JString, required = true,
                                 default = nil)
  if valid_594680 != nil:
    section.add "api-version", valid_594680
  var valid_594681 = query.getOrDefault("$top")
  valid_594681 = validateParameter(valid_594681, JInt, required = false, default = nil)
  if valid_594681 != nil:
    section.add "$top", valid_594681
  var valid_594682 = query.getOrDefault("$skip")
  valid_594682 = validateParameter(valid_594682, JInt, required = false, default = nil)
  if valid_594682 != nil:
    section.add "$skip", valid_594682
  var valid_594683 = query.getOrDefault("$filter")
  valid_594683 = validateParameter(valid_594683, JString, required = false,
                                 default = nil)
  if valid_594683 != nil:
    section.add "$filter", valid_594683
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594684: Call_ApiReleaseList_594673; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all releases of an API. An API release is created when making an API Revision current. Releases are also used to rollback to previous revisions. Results will be paged and can be constrained by the $top and $skip parameters.
  ## 
  let valid = call_594684.validator(path, query, header, formData, body)
  let scheme = call_594684.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594684.url(scheme.get, call_594684.host, call_594684.base,
                         call_594684.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594684, url, valid)

proc call*(call_594685: Call_ApiReleaseList_594673; resourceGroupName: string;
          apiVersion: string; apiId: string; subscriptionId: string;
          serviceName: string; Top: int = 0; Skip: int = 0; Filter: string = ""): Recallable =
  ## apiReleaseList
  ## Lists all releases of an API. An API release is created when making an API Revision current. Releases are also used to rollback to previous revisions. Results will be paged and can be constrained by the $top and $skip parameters.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
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
  ## | name  | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## |notes|ge le eq ne gt lt|substringof contains startswith endswith|
  var path_594686 = newJObject()
  var query_594687 = newJObject()
  add(path_594686, "resourceGroupName", newJString(resourceGroupName))
  add(query_594687, "api-version", newJString(apiVersion))
  add(path_594686, "apiId", newJString(apiId))
  add(path_594686, "subscriptionId", newJString(subscriptionId))
  add(query_594687, "$top", newJInt(Top))
  add(query_594687, "$skip", newJInt(Skip))
  add(path_594686, "serviceName", newJString(serviceName))
  add(query_594687, "$filter", newJString(Filter))
  result = call_594685.call(path_594686, query_594687, nil, nil, nil)

var apiReleaseList* = Call_ApiReleaseList_594673(name: "apiReleaseList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/releases",
    validator: validate_ApiReleaseList_594674, base: "", url: url_ApiReleaseList_594675,
    schemes: {Scheme.Https})
type
  Call_ApiReleaseCreate_594701 = ref object of OpenApiRestCall_593425
proc url_ApiReleaseCreate_594703(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "releaseId" in path, "`releaseId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/releases/"),
               (kind: VariableSegment, value: "releaseId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiReleaseCreate_594702(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Creates a new Release for the API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   releaseId: JString (required)
  ##            : Release identifier within an API. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594704 = path.getOrDefault("resourceGroupName")
  valid_594704 = validateParameter(valid_594704, JString, required = true,
                                 default = nil)
  if valid_594704 != nil:
    section.add "resourceGroupName", valid_594704
  var valid_594705 = path.getOrDefault("apiId")
  valid_594705 = validateParameter(valid_594705, JString, required = true,
                                 default = nil)
  if valid_594705 != nil:
    section.add "apiId", valid_594705
  var valid_594706 = path.getOrDefault("subscriptionId")
  valid_594706 = validateParameter(valid_594706, JString, required = true,
                                 default = nil)
  if valid_594706 != nil:
    section.add "subscriptionId", valid_594706
  var valid_594707 = path.getOrDefault("releaseId")
  valid_594707 = validateParameter(valid_594707, JString, required = true,
                                 default = nil)
  if valid_594707 != nil:
    section.add "releaseId", valid_594707
  var valid_594708 = path.getOrDefault("serviceName")
  valid_594708 = validateParameter(valid_594708, JString, required = true,
                                 default = nil)
  if valid_594708 != nil:
    section.add "serviceName", valid_594708
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594709 = query.getOrDefault("api-version")
  valid_594709 = validateParameter(valid_594709, JString, required = true,
                                 default = nil)
  if valid_594709 != nil:
    section.add "api-version", valid_594709
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

proc call*(call_594711: Call_ApiReleaseCreate_594701; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new Release for the API.
  ## 
  let valid = call_594711.validator(path, query, header, formData, body)
  let scheme = call_594711.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594711.url(scheme.get, call_594711.host, call_594711.base,
                         call_594711.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594711, url, valid)

proc call*(call_594712: Call_ApiReleaseCreate_594701; resourceGroupName: string;
          apiVersion: string; apiId: string; subscriptionId: string;
          releaseId: string; parameters: JsonNode; serviceName: string): Recallable =
  ## apiReleaseCreate
  ## Creates a new Release for the API.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   releaseId: string (required)
  ##            : Release identifier within an API. Must be unique in the current API Management service instance.
  ##   parameters: JObject (required)
  ##             : Create parameters.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594713 = newJObject()
  var query_594714 = newJObject()
  var body_594715 = newJObject()
  add(path_594713, "resourceGroupName", newJString(resourceGroupName))
  add(query_594714, "api-version", newJString(apiVersion))
  add(path_594713, "apiId", newJString(apiId))
  add(path_594713, "subscriptionId", newJString(subscriptionId))
  add(path_594713, "releaseId", newJString(releaseId))
  if parameters != nil:
    body_594715 = parameters
  add(path_594713, "serviceName", newJString(serviceName))
  result = call_594712.call(path_594713, query_594714, nil, nil, body_594715)

var apiReleaseCreate* = Call_ApiReleaseCreate_594701(name: "apiReleaseCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/releases/{releaseId}",
    validator: validate_ApiReleaseCreate_594702, base: "",
    url: url_ApiReleaseCreate_594703, schemes: {Scheme.Https})
type
  Call_ApiReleaseGet_594688 = ref object of OpenApiRestCall_593425
proc url_ApiReleaseGet_594690(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "releaseId" in path, "`releaseId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/releases/"),
               (kind: VariableSegment, value: "releaseId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiReleaseGet_594689(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the details of an API release.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   releaseId: JString (required)
  ##            : Release identifier within an API. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594691 = path.getOrDefault("resourceGroupName")
  valid_594691 = validateParameter(valid_594691, JString, required = true,
                                 default = nil)
  if valid_594691 != nil:
    section.add "resourceGroupName", valid_594691
  var valid_594692 = path.getOrDefault("apiId")
  valid_594692 = validateParameter(valid_594692, JString, required = true,
                                 default = nil)
  if valid_594692 != nil:
    section.add "apiId", valid_594692
  var valid_594693 = path.getOrDefault("subscriptionId")
  valid_594693 = validateParameter(valid_594693, JString, required = true,
                                 default = nil)
  if valid_594693 != nil:
    section.add "subscriptionId", valid_594693
  var valid_594694 = path.getOrDefault("releaseId")
  valid_594694 = validateParameter(valid_594694, JString, required = true,
                                 default = nil)
  if valid_594694 != nil:
    section.add "releaseId", valid_594694
  var valid_594695 = path.getOrDefault("serviceName")
  valid_594695 = validateParameter(valid_594695, JString, required = true,
                                 default = nil)
  if valid_594695 != nil:
    section.add "serviceName", valid_594695
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594696 = query.getOrDefault("api-version")
  valid_594696 = validateParameter(valid_594696, JString, required = true,
                                 default = nil)
  if valid_594696 != nil:
    section.add "api-version", valid_594696
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594697: Call_ApiReleaseGet_594688; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the details of an API release.
  ## 
  let valid = call_594697.validator(path, query, header, formData, body)
  let scheme = call_594697.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594697.url(scheme.get, call_594697.host, call_594697.base,
                         call_594697.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594697, url, valid)

proc call*(call_594698: Call_ApiReleaseGet_594688; resourceGroupName: string;
          apiVersion: string; apiId: string; subscriptionId: string;
          releaseId: string; serviceName: string): Recallable =
  ## apiReleaseGet
  ## Returns the details of an API release.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   releaseId: string (required)
  ##            : Release identifier within an API. Must be unique in the current API Management service instance.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594699 = newJObject()
  var query_594700 = newJObject()
  add(path_594699, "resourceGroupName", newJString(resourceGroupName))
  add(query_594700, "api-version", newJString(apiVersion))
  add(path_594699, "apiId", newJString(apiId))
  add(path_594699, "subscriptionId", newJString(subscriptionId))
  add(path_594699, "releaseId", newJString(releaseId))
  add(path_594699, "serviceName", newJString(serviceName))
  result = call_594698.call(path_594699, query_594700, nil, nil, nil)

var apiReleaseGet* = Call_ApiReleaseGet_594688(name: "apiReleaseGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/releases/{releaseId}",
    validator: validate_ApiReleaseGet_594689, base: "", url: url_ApiReleaseGet_594690,
    schemes: {Scheme.Https})
type
  Call_ApiReleaseUpdate_594730 = ref object of OpenApiRestCall_593425
proc url_ApiReleaseUpdate_594732(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "releaseId" in path, "`releaseId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/releases/"),
               (kind: VariableSegment, value: "releaseId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiReleaseUpdate_594731(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Updates the details of the release of the API specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   releaseId: JString (required)
  ##            : Release identifier within an API. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594733 = path.getOrDefault("resourceGroupName")
  valid_594733 = validateParameter(valid_594733, JString, required = true,
                                 default = nil)
  if valid_594733 != nil:
    section.add "resourceGroupName", valid_594733
  var valid_594734 = path.getOrDefault("apiId")
  valid_594734 = validateParameter(valid_594734, JString, required = true,
                                 default = nil)
  if valid_594734 != nil:
    section.add "apiId", valid_594734
  var valid_594735 = path.getOrDefault("subscriptionId")
  valid_594735 = validateParameter(valid_594735, JString, required = true,
                                 default = nil)
  if valid_594735 != nil:
    section.add "subscriptionId", valid_594735
  var valid_594736 = path.getOrDefault("releaseId")
  valid_594736 = validateParameter(valid_594736, JString, required = true,
                                 default = nil)
  if valid_594736 != nil:
    section.add "releaseId", valid_594736
  var valid_594737 = path.getOrDefault("serviceName")
  valid_594737 = validateParameter(valid_594737, JString, required = true,
                                 default = nil)
  if valid_594737 != nil:
    section.add "serviceName", valid_594737
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594738 = query.getOrDefault("api-version")
  valid_594738 = validateParameter(valid_594738, JString, required = true,
                                 default = nil)
  if valid_594738 != nil:
    section.add "api-version", valid_594738
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_594739 = header.getOrDefault("If-Match")
  valid_594739 = validateParameter(valid_594739, JString, required = true,
                                 default = nil)
  if valid_594739 != nil:
    section.add "If-Match", valid_594739
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : API Release Update parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594741: Call_ApiReleaseUpdate_594730; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the details of the release of the API specified by its identifier.
  ## 
  let valid = call_594741.validator(path, query, header, formData, body)
  let scheme = call_594741.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594741.url(scheme.get, call_594741.host, call_594741.base,
                         call_594741.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594741, url, valid)

proc call*(call_594742: Call_ApiReleaseUpdate_594730; resourceGroupName: string;
          apiVersion: string; apiId: string; subscriptionId: string;
          releaseId: string; parameters: JsonNode; serviceName: string): Recallable =
  ## apiReleaseUpdate
  ## Updates the details of the release of the API specified by its identifier.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   releaseId: string (required)
  ##            : Release identifier within an API. Must be unique in the current API Management service instance.
  ##   parameters: JObject (required)
  ##             : API Release Update parameters.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594743 = newJObject()
  var query_594744 = newJObject()
  var body_594745 = newJObject()
  add(path_594743, "resourceGroupName", newJString(resourceGroupName))
  add(query_594744, "api-version", newJString(apiVersion))
  add(path_594743, "apiId", newJString(apiId))
  add(path_594743, "subscriptionId", newJString(subscriptionId))
  add(path_594743, "releaseId", newJString(releaseId))
  if parameters != nil:
    body_594745 = parameters
  add(path_594743, "serviceName", newJString(serviceName))
  result = call_594742.call(path_594743, query_594744, nil, nil, body_594745)

var apiReleaseUpdate* = Call_ApiReleaseUpdate_594730(name: "apiReleaseUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/releases/{releaseId}",
    validator: validate_ApiReleaseUpdate_594731, base: "",
    url: url_ApiReleaseUpdate_594732, schemes: {Scheme.Https})
type
  Call_ApiReleaseDelete_594716 = ref object of OpenApiRestCall_593425
proc url_ApiReleaseDelete_594718(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "releaseId" in path, "`releaseId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/releases/"),
               (kind: VariableSegment, value: "releaseId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiReleaseDelete_594717(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Deletes the specified release in the API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   releaseId: JString (required)
  ##            : Release identifier within an API. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594719 = path.getOrDefault("resourceGroupName")
  valid_594719 = validateParameter(valid_594719, JString, required = true,
                                 default = nil)
  if valid_594719 != nil:
    section.add "resourceGroupName", valid_594719
  var valid_594720 = path.getOrDefault("apiId")
  valid_594720 = validateParameter(valid_594720, JString, required = true,
                                 default = nil)
  if valid_594720 != nil:
    section.add "apiId", valid_594720
  var valid_594721 = path.getOrDefault("subscriptionId")
  valid_594721 = validateParameter(valid_594721, JString, required = true,
                                 default = nil)
  if valid_594721 != nil:
    section.add "subscriptionId", valid_594721
  var valid_594722 = path.getOrDefault("releaseId")
  valid_594722 = validateParameter(valid_594722, JString, required = true,
                                 default = nil)
  if valid_594722 != nil:
    section.add "releaseId", valid_594722
  var valid_594723 = path.getOrDefault("serviceName")
  valid_594723 = validateParameter(valid_594723, JString, required = true,
                                 default = nil)
  if valid_594723 != nil:
    section.add "serviceName", valid_594723
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594724 = query.getOrDefault("api-version")
  valid_594724 = validateParameter(valid_594724, JString, required = true,
                                 default = nil)
  if valid_594724 != nil:
    section.add "api-version", valid_594724
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_594725 = header.getOrDefault("If-Match")
  valid_594725 = validateParameter(valid_594725, JString, required = true,
                                 default = nil)
  if valid_594725 != nil:
    section.add "If-Match", valid_594725
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594726: Call_ApiReleaseDelete_594716; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified release in the API.
  ## 
  let valid = call_594726.validator(path, query, header, formData, body)
  let scheme = call_594726.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594726.url(scheme.get, call_594726.host, call_594726.base,
                         call_594726.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594726, url, valid)

proc call*(call_594727: Call_ApiReleaseDelete_594716; resourceGroupName: string;
          apiVersion: string; apiId: string; subscriptionId: string;
          releaseId: string; serviceName: string): Recallable =
  ## apiReleaseDelete
  ## Deletes the specified release in the API.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   releaseId: string (required)
  ##            : Release identifier within an API. Must be unique in the current API Management service instance.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594728 = newJObject()
  var query_594729 = newJObject()
  add(path_594728, "resourceGroupName", newJString(resourceGroupName))
  add(query_594729, "api-version", newJString(apiVersion))
  add(path_594728, "apiId", newJString(apiId))
  add(path_594728, "subscriptionId", newJString(subscriptionId))
  add(path_594728, "releaseId", newJString(releaseId))
  add(path_594728, "serviceName", newJString(serviceName))
  result = call_594727.call(path_594728, query_594729, nil, nil, nil)

var apiReleaseDelete* = Call_ApiReleaseDelete_594716(name: "apiReleaseDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/releases/{releaseId}",
    validator: validate_ApiReleaseDelete_594717, base: "",
    url: url_ApiReleaseDelete_594718, schemes: {Scheme.Https})
type
  Call_ApiRevisionsList_594746 = ref object of OpenApiRestCall_593425
proc url_ApiRevisionsList_594748(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/revisions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiRevisionsList_594747(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Lists all revisions of an API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594749 = path.getOrDefault("resourceGroupName")
  valid_594749 = validateParameter(valid_594749, JString, required = true,
                                 default = nil)
  if valid_594749 != nil:
    section.add "resourceGroupName", valid_594749
  var valid_594750 = path.getOrDefault("apiId")
  valid_594750 = validateParameter(valid_594750, JString, required = true,
                                 default = nil)
  if valid_594750 != nil:
    section.add "apiId", valid_594750
  var valid_594751 = path.getOrDefault("subscriptionId")
  valid_594751 = validateParameter(valid_594751, JString, required = true,
                                 default = nil)
  if valid_594751 != nil:
    section.add "subscriptionId", valid_594751
  var valid_594752 = path.getOrDefault("serviceName")
  valid_594752 = validateParameter(valid_594752, JString, required = true,
                                 default = nil)
  if valid_594752 != nil:
    section.add "serviceName", valid_594752
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : Number of records to return.
  ##   $skip: JInt
  ##        : Number of records to skip.
  ##   $filter: JString
  ##          : | Field       | Supported operators    | Supported functions               |
  ## |-------------|------------------------|-----------------------------------|
  ## 
  ## |apiRevision | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## 
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594753 = query.getOrDefault("api-version")
  valid_594753 = validateParameter(valid_594753, JString, required = true,
                                 default = nil)
  if valid_594753 != nil:
    section.add "api-version", valid_594753
  var valid_594754 = query.getOrDefault("$top")
  valid_594754 = validateParameter(valid_594754, JInt, required = false, default = nil)
  if valid_594754 != nil:
    section.add "$top", valid_594754
  var valid_594755 = query.getOrDefault("$skip")
  valid_594755 = validateParameter(valid_594755, JInt, required = false, default = nil)
  if valid_594755 != nil:
    section.add "$skip", valid_594755
  var valid_594756 = query.getOrDefault("$filter")
  valid_594756 = validateParameter(valid_594756, JString, required = false,
                                 default = nil)
  if valid_594756 != nil:
    section.add "$filter", valid_594756
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594757: Call_ApiRevisionsList_594746; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all revisions of an API.
  ## 
  let valid = call_594757.validator(path, query, header, formData, body)
  let scheme = call_594757.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594757.url(scheme.get, call_594757.host, call_594757.base,
                         call_594757.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594757, url, valid)

proc call*(call_594758: Call_ApiRevisionsList_594746; resourceGroupName: string;
          apiVersion: string; apiId: string; subscriptionId: string;
          serviceName: string; Top: int = 0; Skip: int = 0; Filter: string = ""): Recallable =
  ## apiRevisionsList
  ## Lists all revisions of an API.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : Number of records to return.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   Filter: string
  ##         : | Field       | Supported operators    | Supported functions               |
  ## |-------------|------------------------|-----------------------------------|
  ## 
  ## |apiRevision | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## 
  var path_594759 = newJObject()
  var query_594760 = newJObject()
  add(path_594759, "resourceGroupName", newJString(resourceGroupName))
  add(query_594760, "api-version", newJString(apiVersion))
  add(path_594759, "apiId", newJString(apiId))
  add(path_594759, "subscriptionId", newJString(subscriptionId))
  add(query_594760, "$top", newJInt(Top))
  add(query_594760, "$skip", newJInt(Skip))
  add(path_594759, "serviceName", newJString(serviceName))
  add(query_594760, "$filter", newJString(Filter))
  result = call_594758.call(path_594759, query_594760, nil, nil, nil)

var apiRevisionsList* = Call_ApiRevisionsList_594746(name: "apiRevisionsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/revisions",
    validator: validate_ApiRevisionsList_594747, base: "",
    url: url_ApiRevisionsList_594748, schemes: {Scheme.Https})
type
  Call_ApiSchemaListByApi_594761 = ref object of OpenApiRestCall_593425
proc url_ApiSchemaListByApi_594763(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/schemas")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiSchemaListByApi_594762(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Get the schema configuration at the API level.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594764 = path.getOrDefault("resourceGroupName")
  valid_594764 = validateParameter(valid_594764, JString, required = true,
                                 default = nil)
  if valid_594764 != nil:
    section.add "resourceGroupName", valid_594764
  var valid_594765 = path.getOrDefault("apiId")
  valid_594765 = validateParameter(valid_594765, JString, required = true,
                                 default = nil)
  if valid_594765 != nil:
    section.add "apiId", valid_594765
  var valid_594766 = path.getOrDefault("subscriptionId")
  valid_594766 = validateParameter(valid_594766, JString, required = true,
                                 default = nil)
  if valid_594766 != nil:
    section.add "subscriptionId", valid_594766
  var valid_594767 = path.getOrDefault("serviceName")
  valid_594767 = validateParameter(valid_594767, JString, required = true,
                                 default = nil)
  if valid_594767 != nil:
    section.add "serviceName", valid_594767
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594768 = query.getOrDefault("api-version")
  valid_594768 = validateParameter(valid_594768, JString, required = true,
                                 default = nil)
  if valid_594768 != nil:
    section.add "api-version", valid_594768
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594769: Call_ApiSchemaListByApi_594761; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the schema configuration at the API level.
  ## 
  let valid = call_594769.validator(path, query, header, formData, body)
  let scheme = call_594769.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594769.url(scheme.get, call_594769.host, call_594769.base,
                         call_594769.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594769, url, valid)

proc call*(call_594770: Call_ApiSchemaListByApi_594761; resourceGroupName: string;
          apiVersion: string; apiId: string; subscriptionId: string;
          serviceName: string): Recallable =
  ## apiSchemaListByApi
  ## Get the schema configuration at the API level.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594771 = newJObject()
  var query_594772 = newJObject()
  add(path_594771, "resourceGroupName", newJString(resourceGroupName))
  add(query_594772, "api-version", newJString(apiVersion))
  add(path_594771, "apiId", newJString(apiId))
  add(path_594771, "subscriptionId", newJString(subscriptionId))
  add(path_594771, "serviceName", newJString(serviceName))
  result = call_594770.call(path_594771, query_594772, nil, nil, nil)

var apiSchemaListByApi* = Call_ApiSchemaListByApi_594761(
    name: "apiSchemaListByApi", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/schemas",
    validator: validate_ApiSchemaListByApi_594762, base: "",
    url: url_ApiSchemaListByApi_594763, schemes: {Scheme.Https})
type
  Call_ApiSchemaCreateOrUpdate_594786 = ref object of OpenApiRestCall_593425
proc url_ApiSchemaCreateOrUpdate_594788(protocol: Scheme; host: string; base: string;
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
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "schemaId" in path, "`schemaId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/schemas/"),
               (kind: VariableSegment, value: "schemaId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiSchemaCreateOrUpdate_594787(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates schema configuration for the API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   schemaId: JString (required)
  ##           : Schema identifier within an API. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594789 = path.getOrDefault("resourceGroupName")
  valid_594789 = validateParameter(valid_594789, JString, required = true,
                                 default = nil)
  if valid_594789 != nil:
    section.add "resourceGroupName", valid_594789
  var valid_594790 = path.getOrDefault("apiId")
  valid_594790 = validateParameter(valid_594790, JString, required = true,
                                 default = nil)
  if valid_594790 != nil:
    section.add "apiId", valid_594790
  var valid_594791 = path.getOrDefault("subscriptionId")
  valid_594791 = validateParameter(valid_594791, JString, required = true,
                                 default = nil)
  if valid_594791 != nil:
    section.add "subscriptionId", valid_594791
  var valid_594792 = path.getOrDefault("schemaId")
  valid_594792 = validateParameter(valid_594792, JString, required = true,
                                 default = nil)
  if valid_594792 != nil:
    section.add "schemaId", valid_594792
  var valid_594793 = path.getOrDefault("serviceName")
  valid_594793 = validateParameter(valid_594793, JString, required = true,
                                 default = nil)
  if valid_594793 != nil:
    section.add "serviceName", valid_594793
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594794 = query.getOrDefault("api-version")
  valid_594794 = validateParameter(valid_594794, JString, required = true,
                                 default = nil)
  if valid_594794 != nil:
    section.add "api-version", valid_594794
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : The entity state (Etag) version of the Api Schema to update. A value of "*" can be used for If-Match to unconditionally apply the operation.
  section = newJObject()
  var valid_594795 = header.getOrDefault("If-Match")
  valid_594795 = validateParameter(valid_594795, JString, required = false,
                                 default = nil)
  if valid_594795 != nil:
    section.add "If-Match", valid_594795
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The schema contents to apply.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594797: Call_ApiSchemaCreateOrUpdate_594786; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates schema configuration for the API.
  ## 
  let valid = call_594797.validator(path, query, header, formData, body)
  let scheme = call_594797.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594797.url(scheme.get, call_594797.host, call_594797.base,
                         call_594797.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594797, url, valid)

proc call*(call_594798: Call_ApiSchemaCreateOrUpdate_594786;
          resourceGroupName: string; apiVersion: string; apiId: string;
          subscriptionId: string; schemaId: string; parameters: JsonNode;
          serviceName: string): Recallable =
  ## apiSchemaCreateOrUpdate
  ## Creates or updates schema configuration for the API.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   schemaId: string (required)
  ##           : Schema identifier within an API. Must be unique in the current API Management service instance.
  ##   parameters: JObject (required)
  ##             : The schema contents to apply.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594799 = newJObject()
  var query_594800 = newJObject()
  var body_594801 = newJObject()
  add(path_594799, "resourceGroupName", newJString(resourceGroupName))
  add(query_594800, "api-version", newJString(apiVersion))
  add(path_594799, "apiId", newJString(apiId))
  add(path_594799, "subscriptionId", newJString(subscriptionId))
  add(path_594799, "schemaId", newJString(schemaId))
  if parameters != nil:
    body_594801 = parameters
  add(path_594799, "serviceName", newJString(serviceName))
  result = call_594798.call(path_594799, query_594800, nil, nil, body_594801)

var apiSchemaCreateOrUpdate* = Call_ApiSchemaCreateOrUpdate_594786(
    name: "apiSchemaCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/schemas/{schemaId}",
    validator: validate_ApiSchemaCreateOrUpdate_594787, base: "",
    url: url_ApiSchemaCreateOrUpdate_594788, schemes: {Scheme.Https})
type
  Call_ApiSchemaGetEntityTag_594816 = ref object of OpenApiRestCall_593425
proc url_ApiSchemaGetEntityTag_594818(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "schemaId" in path, "`schemaId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/schemas/"),
               (kind: VariableSegment, value: "schemaId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiSchemaGetEntityTag_594817(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the entity state (Etag) version of the schema specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   schemaId: JString (required)
  ##           : Schema identifier within an API. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594819 = path.getOrDefault("resourceGroupName")
  valid_594819 = validateParameter(valid_594819, JString, required = true,
                                 default = nil)
  if valid_594819 != nil:
    section.add "resourceGroupName", valid_594819
  var valid_594820 = path.getOrDefault("apiId")
  valid_594820 = validateParameter(valid_594820, JString, required = true,
                                 default = nil)
  if valid_594820 != nil:
    section.add "apiId", valid_594820
  var valid_594821 = path.getOrDefault("subscriptionId")
  valid_594821 = validateParameter(valid_594821, JString, required = true,
                                 default = nil)
  if valid_594821 != nil:
    section.add "subscriptionId", valid_594821
  var valid_594822 = path.getOrDefault("schemaId")
  valid_594822 = validateParameter(valid_594822, JString, required = true,
                                 default = nil)
  if valid_594822 != nil:
    section.add "schemaId", valid_594822
  var valid_594823 = path.getOrDefault("serviceName")
  valid_594823 = validateParameter(valid_594823, JString, required = true,
                                 default = nil)
  if valid_594823 != nil:
    section.add "serviceName", valid_594823
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594824 = query.getOrDefault("api-version")
  valid_594824 = validateParameter(valid_594824, JString, required = true,
                                 default = nil)
  if valid_594824 != nil:
    section.add "api-version", valid_594824
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594825: Call_ApiSchemaGetEntityTag_594816; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the entity state (Etag) version of the schema specified by its identifier.
  ## 
  let valid = call_594825.validator(path, query, header, formData, body)
  let scheme = call_594825.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594825.url(scheme.get, call_594825.host, call_594825.base,
                         call_594825.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594825, url, valid)

proc call*(call_594826: Call_ApiSchemaGetEntityTag_594816;
          resourceGroupName: string; apiVersion: string; apiId: string;
          subscriptionId: string; schemaId: string; serviceName: string): Recallable =
  ## apiSchemaGetEntityTag
  ## Gets the entity state (Etag) version of the schema specified by its identifier.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   schemaId: string (required)
  ##           : Schema identifier within an API. Must be unique in the current API Management service instance.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594827 = newJObject()
  var query_594828 = newJObject()
  add(path_594827, "resourceGroupName", newJString(resourceGroupName))
  add(query_594828, "api-version", newJString(apiVersion))
  add(path_594827, "apiId", newJString(apiId))
  add(path_594827, "subscriptionId", newJString(subscriptionId))
  add(path_594827, "schemaId", newJString(schemaId))
  add(path_594827, "serviceName", newJString(serviceName))
  result = call_594826.call(path_594827, query_594828, nil, nil, nil)

var apiSchemaGetEntityTag* = Call_ApiSchemaGetEntityTag_594816(
    name: "apiSchemaGetEntityTag", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/schemas/{schemaId}",
    validator: validate_ApiSchemaGetEntityTag_594817, base: "",
    url: url_ApiSchemaGetEntityTag_594818, schemes: {Scheme.Https})
type
  Call_ApiSchemaGet_594773 = ref object of OpenApiRestCall_593425
proc url_ApiSchemaGet_594775(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "schemaId" in path, "`schemaId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/schemas/"),
               (kind: VariableSegment, value: "schemaId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiSchemaGet_594774(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the schema configuration at the API level.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   schemaId: JString (required)
  ##           : Schema identifier within an API. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594776 = path.getOrDefault("resourceGroupName")
  valid_594776 = validateParameter(valid_594776, JString, required = true,
                                 default = nil)
  if valid_594776 != nil:
    section.add "resourceGroupName", valid_594776
  var valid_594777 = path.getOrDefault("apiId")
  valid_594777 = validateParameter(valid_594777, JString, required = true,
                                 default = nil)
  if valid_594777 != nil:
    section.add "apiId", valid_594777
  var valid_594778 = path.getOrDefault("subscriptionId")
  valid_594778 = validateParameter(valid_594778, JString, required = true,
                                 default = nil)
  if valid_594778 != nil:
    section.add "subscriptionId", valid_594778
  var valid_594779 = path.getOrDefault("schemaId")
  valid_594779 = validateParameter(valid_594779, JString, required = true,
                                 default = nil)
  if valid_594779 != nil:
    section.add "schemaId", valid_594779
  var valid_594780 = path.getOrDefault("serviceName")
  valid_594780 = validateParameter(valid_594780, JString, required = true,
                                 default = nil)
  if valid_594780 != nil:
    section.add "serviceName", valid_594780
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594781 = query.getOrDefault("api-version")
  valid_594781 = validateParameter(valid_594781, JString, required = true,
                                 default = nil)
  if valid_594781 != nil:
    section.add "api-version", valid_594781
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594782: Call_ApiSchemaGet_594773; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the schema configuration at the API level.
  ## 
  let valid = call_594782.validator(path, query, header, formData, body)
  let scheme = call_594782.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594782.url(scheme.get, call_594782.host, call_594782.base,
                         call_594782.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594782, url, valid)

proc call*(call_594783: Call_ApiSchemaGet_594773; resourceGroupName: string;
          apiVersion: string; apiId: string; subscriptionId: string; schemaId: string;
          serviceName: string): Recallable =
  ## apiSchemaGet
  ## Get the schema configuration at the API level.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   schemaId: string (required)
  ##           : Schema identifier within an API. Must be unique in the current API Management service instance.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594784 = newJObject()
  var query_594785 = newJObject()
  add(path_594784, "resourceGroupName", newJString(resourceGroupName))
  add(query_594785, "api-version", newJString(apiVersion))
  add(path_594784, "apiId", newJString(apiId))
  add(path_594784, "subscriptionId", newJString(subscriptionId))
  add(path_594784, "schemaId", newJString(schemaId))
  add(path_594784, "serviceName", newJString(serviceName))
  result = call_594783.call(path_594784, query_594785, nil, nil, nil)

var apiSchemaGet* = Call_ApiSchemaGet_594773(name: "apiSchemaGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/schemas/{schemaId}",
    validator: validate_ApiSchemaGet_594774, base: "", url: url_ApiSchemaGet_594775,
    schemes: {Scheme.Https})
type
  Call_ApiSchemaDelete_594802 = ref object of OpenApiRestCall_593425
proc url_ApiSchemaDelete_594804(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "schemaId" in path, "`schemaId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/schemas/"),
               (kind: VariableSegment, value: "schemaId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiSchemaDelete_594803(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Deletes the schema configuration at the Api.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   schemaId: JString (required)
  ##           : Schema identifier within an API. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594805 = path.getOrDefault("resourceGroupName")
  valid_594805 = validateParameter(valid_594805, JString, required = true,
                                 default = nil)
  if valid_594805 != nil:
    section.add "resourceGroupName", valid_594805
  var valid_594806 = path.getOrDefault("apiId")
  valid_594806 = validateParameter(valid_594806, JString, required = true,
                                 default = nil)
  if valid_594806 != nil:
    section.add "apiId", valid_594806
  var valid_594807 = path.getOrDefault("subscriptionId")
  valid_594807 = validateParameter(valid_594807, JString, required = true,
                                 default = nil)
  if valid_594807 != nil:
    section.add "subscriptionId", valid_594807
  var valid_594808 = path.getOrDefault("schemaId")
  valid_594808 = validateParameter(valid_594808, JString, required = true,
                                 default = nil)
  if valid_594808 != nil:
    section.add "schemaId", valid_594808
  var valid_594809 = path.getOrDefault("serviceName")
  valid_594809 = validateParameter(valid_594809, JString, required = true,
                                 default = nil)
  if valid_594809 != nil:
    section.add "serviceName", valid_594809
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594810 = query.getOrDefault("api-version")
  valid_594810 = validateParameter(valid_594810, JString, required = true,
                                 default = nil)
  if valid_594810 != nil:
    section.add "api-version", valid_594810
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : The entity state (Etag) version of the Api schema to update. A value of "*" can be used for If-Match to unconditionally apply the operation.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_594811 = header.getOrDefault("If-Match")
  valid_594811 = validateParameter(valid_594811, JString, required = true,
                                 default = nil)
  if valid_594811 != nil:
    section.add "If-Match", valid_594811
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594812: Call_ApiSchemaDelete_594802; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the schema configuration at the Api.
  ## 
  let valid = call_594812.validator(path, query, header, formData, body)
  let scheme = call_594812.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594812.url(scheme.get, call_594812.host, call_594812.base,
                         call_594812.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594812, url, valid)

proc call*(call_594813: Call_ApiSchemaDelete_594802; resourceGroupName: string;
          apiVersion: string; apiId: string; subscriptionId: string; schemaId: string;
          serviceName: string): Recallable =
  ## apiSchemaDelete
  ## Deletes the schema configuration at the Api.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   schemaId: string (required)
  ##           : Schema identifier within an API. Must be unique in the current API Management service instance.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594814 = newJObject()
  var query_594815 = newJObject()
  add(path_594814, "resourceGroupName", newJString(resourceGroupName))
  add(query_594815, "api-version", newJString(apiVersion))
  add(path_594814, "apiId", newJString(apiId))
  add(path_594814, "subscriptionId", newJString(subscriptionId))
  add(path_594814, "schemaId", newJString(schemaId))
  add(path_594814, "serviceName", newJString(serviceName))
  result = call_594813.call(path_594814, query_594815, nil, nil, nil)

var apiSchemaDelete* = Call_ApiSchemaDelete_594802(name: "apiSchemaDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/schemas/{schemaId}",
    validator: validate_ApiSchemaDelete_594803, base: "", url: url_ApiSchemaDelete_594804,
    schemes: {Scheme.Https})
type
  Call_ApiListByTags_594829 = ref object of OpenApiRestCall_593425
proc url_ApiListByTags_594831(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/apisByTags")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiListByTags_594830(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists a collection of apis associated with tags.
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
  var valid_594832 = path.getOrDefault("resourceGroupName")
  valid_594832 = validateParameter(valid_594832, JString, required = true,
                                 default = nil)
  if valid_594832 != nil:
    section.add "resourceGroupName", valid_594832
  var valid_594833 = path.getOrDefault("subscriptionId")
  valid_594833 = validateParameter(valid_594833, JString, required = true,
                                 default = nil)
  if valid_594833 != nil:
    section.add "subscriptionId", valid_594833
  var valid_594834 = path.getOrDefault("serviceName")
  valid_594834 = validateParameter(valid_594834, JString, required = true,
                                 default = nil)
  if valid_594834 != nil:
    section.add "serviceName", valid_594834
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : Number of records to return.
  ##   $skip: JInt
  ##        : Number of records to skip.
  ##   $filter: JString
  ##          : | Field       | Supported operators    | Supported functions                         |
  ## 
  ## |-------------|------------------------|---------------------------------------------|
  ## | id          | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | name        | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | aid         | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | apiRevision | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | path        | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | description | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | serviceUrl  | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | isCurrent   | eq                     | substringof, contains, startswith, endswith |
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594835 = query.getOrDefault("api-version")
  valid_594835 = validateParameter(valid_594835, JString, required = true,
                                 default = nil)
  if valid_594835 != nil:
    section.add "api-version", valid_594835
  var valid_594836 = query.getOrDefault("$top")
  valid_594836 = validateParameter(valid_594836, JInt, required = false, default = nil)
  if valid_594836 != nil:
    section.add "$top", valid_594836
  var valid_594837 = query.getOrDefault("$skip")
  valid_594837 = validateParameter(valid_594837, JInt, required = false, default = nil)
  if valid_594837 != nil:
    section.add "$skip", valid_594837
  var valid_594838 = query.getOrDefault("$filter")
  valid_594838 = validateParameter(valid_594838, JString, required = false,
                                 default = nil)
  if valid_594838 != nil:
    section.add "$filter", valid_594838
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594839: Call_ApiListByTags_594829; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a collection of apis associated with tags.
  ## 
  let valid = call_594839.validator(path, query, header, formData, body)
  let scheme = call_594839.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594839.url(scheme.get, call_594839.host, call_594839.base,
                         call_594839.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594839, url, valid)

proc call*(call_594840: Call_ApiListByTags_594829; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; serviceName: string;
          Top: int = 0; Skip: int = 0; Filter: string = ""): Recallable =
  ## apiListByTags
  ## Lists a collection of apis associated with tags.
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
  ##         : | Field       | Supported operators    | Supported functions                         |
  ## 
  ## |-------------|------------------------|---------------------------------------------|
  ## | id          | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | name        | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | aid         | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | apiRevision | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | path        | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | description | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | serviceUrl  | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | isCurrent   | eq                     | substringof, contains, startswith, endswith |
  var path_594841 = newJObject()
  var query_594842 = newJObject()
  add(path_594841, "resourceGroupName", newJString(resourceGroupName))
  add(query_594842, "api-version", newJString(apiVersion))
  add(path_594841, "subscriptionId", newJString(subscriptionId))
  add(query_594842, "$top", newJInt(Top))
  add(query_594842, "$skip", newJInt(Skip))
  add(path_594841, "serviceName", newJString(serviceName))
  add(query_594842, "$filter", newJString(Filter))
  result = call_594840.call(path_594841, query_594842, nil, nil, nil)

var apiListByTags* = Call_ApiListByTags_594829(name: "apiListByTags",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apisByTags",
    validator: validate_ApiListByTags_594830, base: "", url: url_ApiListByTags_594831,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
