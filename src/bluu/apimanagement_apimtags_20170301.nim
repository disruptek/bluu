
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: ApiManagementClient
## version: 2017-03-01
## termsOfService: (not provided)
## license: (not provided)
## 
## Use these REST APIs for performing operations on Tag entity in your Azure API Management deployment. Tags can be assigned to APIs, Operations and Products.
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
  macServiceName = "apimanagement-apimtags"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_TagListByOperation_593647 = ref object of OpenApiRestCall_593425
proc url_TagListByOperation_593649(protocol: Scheme; host: string; base: string;
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
               (kind: VariableSegment, value: "operationId"),
               (kind: ConstantSegment, value: "/tags")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagListByOperation_593648(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Lists all Tags associated with the Operation.
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
  var valid_593810 = path.getOrDefault("resourceGroupName")
  valid_593810 = validateParameter(valid_593810, JString, required = true,
                                 default = nil)
  if valid_593810 != nil:
    section.add "resourceGroupName", valid_593810
  var valid_593811 = path.getOrDefault("apiId")
  valid_593811 = validateParameter(valid_593811, JString, required = true,
                                 default = nil)
  if valid_593811 != nil:
    section.add "apiId", valid_593811
  var valid_593812 = path.getOrDefault("subscriptionId")
  valid_593812 = validateParameter(valid_593812, JString, required = true,
                                 default = nil)
  if valid_593812 != nil:
    section.add "subscriptionId", valid_593812
  var valid_593813 = path.getOrDefault("serviceName")
  valid_593813 = validateParameter(valid_593813, JString, required = true,
                                 default = nil)
  if valid_593813 != nil:
    section.add "serviceName", valid_593813
  var valid_593814 = path.getOrDefault("operationId")
  valid_593814 = validateParameter(valid_593814, JString, required = true,
                                 default = nil)
  if valid_593814 != nil:
    section.add "operationId", valid_593814
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
  ## | method     | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | description | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | urlTemplate | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593815 = query.getOrDefault("api-version")
  valid_593815 = validateParameter(valid_593815, JString, required = true,
                                 default = nil)
  if valid_593815 != nil:
    section.add "api-version", valid_593815
  var valid_593816 = query.getOrDefault("$top")
  valid_593816 = validateParameter(valid_593816, JInt, required = false, default = nil)
  if valid_593816 != nil:
    section.add "$top", valid_593816
  var valid_593817 = query.getOrDefault("$skip")
  valid_593817 = validateParameter(valid_593817, JInt, required = false, default = nil)
  if valid_593817 != nil:
    section.add "$skip", valid_593817
  var valid_593818 = query.getOrDefault("$filter")
  valid_593818 = validateParameter(valid_593818, JString, required = false,
                                 default = nil)
  if valid_593818 != nil:
    section.add "$filter", valid_593818
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593845: Call_TagListByOperation_593647; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all Tags associated with the Operation.
  ## 
  let valid = call_593845.validator(path, query, header, formData, body)
  let scheme = call_593845.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593845.url(scheme.get, call_593845.host, call_593845.base,
                         call_593845.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593845, url, valid)

proc call*(call_593916: Call_TagListByOperation_593647; resourceGroupName: string;
          apiVersion: string; apiId: string; subscriptionId: string;
          serviceName: string; operationId: string; Top: int = 0; Skip: int = 0;
          Filter: string = ""): Recallable =
  ## tagListByOperation
  ## Lists all Tags associated with the Operation.
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
  ##   operationId: string (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  ##   Filter: string
  ##         : | Field       | Supported operators    | Supported functions                         |
  ## 
  ## |-------------|------------------------|---------------------------------------------|
  ## | id          | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | name        | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | method     | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | description | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | urlTemplate | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  var path_593917 = newJObject()
  var query_593919 = newJObject()
  add(path_593917, "resourceGroupName", newJString(resourceGroupName))
  add(query_593919, "api-version", newJString(apiVersion))
  add(path_593917, "apiId", newJString(apiId))
  add(path_593917, "subscriptionId", newJString(subscriptionId))
  add(query_593919, "$top", newJInt(Top))
  add(query_593919, "$skip", newJInt(Skip))
  add(path_593917, "serviceName", newJString(serviceName))
  add(path_593917, "operationId", newJString(operationId))
  add(query_593919, "$filter", newJString(Filter))
  result = call_593916.call(path_593917, query_593919, nil, nil, nil)

var tagListByOperation* = Call_TagListByOperation_593647(
    name: "tagListByOperation", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/operations/{operationId}/tags",
    validator: validate_TagListByOperation_593648, base: "",
    url: url_TagListByOperation_593649, schemes: {Scheme.Https})
type
  Call_TagAssignToOperation_593981 = ref object of OpenApiRestCall_593425
proc url_TagAssignToOperation_593983(protocol: Scheme; host: string; base: string;
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
  assert "tagId" in path, "`tagId` is a required path parameter"
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
               (kind: ConstantSegment, value: "/tags/"),
               (kind: VariableSegment, value: "tagId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagAssignToOperation_593982(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Assign tag to the Operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tagId: JString (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
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
  assert path != nil, "path argument is necessary due to required `tagId` field"
  var valid_593984 = path.getOrDefault("tagId")
  valid_593984 = validateParameter(valid_593984, JString, required = true,
                                 default = nil)
  if valid_593984 != nil:
    section.add "tagId", valid_593984
  var valid_593985 = path.getOrDefault("resourceGroupName")
  valid_593985 = validateParameter(valid_593985, JString, required = true,
                                 default = nil)
  if valid_593985 != nil:
    section.add "resourceGroupName", valid_593985
  var valid_593986 = path.getOrDefault("apiId")
  valid_593986 = validateParameter(valid_593986, JString, required = true,
                                 default = nil)
  if valid_593986 != nil:
    section.add "apiId", valid_593986
  var valid_593987 = path.getOrDefault("subscriptionId")
  valid_593987 = validateParameter(valid_593987, JString, required = true,
                                 default = nil)
  if valid_593987 != nil:
    section.add "subscriptionId", valid_593987
  var valid_593988 = path.getOrDefault("serviceName")
  valid_593988 = validateParameter(valid_593988, JString, required = true,
                                 default = nil)
  if valid_593988 != nil:
    section.add "serviceName", valid_593988
  var valid_593989 = path.getOrDefault("operationId")
  valid_593989 = validateParameter(valid_593989, JString, required = true,
                                 default = nil)
  if valid_593989 != nil:
    section.add "operationId", valid_593989
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593990 = query.getOrDefault("api-version")
  valid_593990 = validateParameter(valid_593990, JString, required = true,
                                 default = nil)
  if valid_593990 != nil:
    section.add "api-version", valid_593990
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : The entity state (Etag) version of the Tag to update. A value of "*" can be used for If-Match to unconditionally apply the operation.
  section = newJObject()
  var valid_593991 = header.getOrDefault("If-Match")
  valid_593991 = validateParameter(valid_593991, JString, required = false,
                                 default = nil)
  if valid_593991 != nil:
    section.add "If-Match", valid_593991
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593992: Call_TagAssignToOperation_593981; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Assign tag to the Operation.
  ## 
  let valid = call_593992.validator(path, query, header, formData, body)
  let scheme = call_593992.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593992.url(scheme.get, call_593992.host, call_593992.base,
                         call_593992.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593992, url, valid)

proc call*(call_593993: Call_TagAssignToOperation_593981; tagId: string;
          resourceGroupName: string; apiVersion: string; apiId: string;
          subscriptionId: string; serviceName: string; operationId: string): Recallable =
  ## tagAssignToOperation
  ## Assign tag to the Operation.
  ##   tagId: string (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
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
  var path_593994 = newJObject()
  var query_593995 = newJObject()
  add(path_593994, "tagId", newJString(tagId))
  add(path_593994, "resourceGroupName", newJString(resourceGroupName))
  add(query_593995, "api-version", newJString(apiVersion))
  add(path_593994, "apiId", newJString(apiId))
  add(path_593994, "subscriptionId", newJString(subscriptionId))
  add(path_593994, "serviceName", newJString(serviceName))
  add(path_593994, "operationId", newJString(operationId))
  result = call_593993.call(path_593994, query_593995, nil, nil, nil)

var tagAssignToOperation* = Call_TagAssignToOperation_593981(
    name: "tagAssignToOperation", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/operations/{operationId}/tags/{tagId}",
    validator: validate_TagAssignToOperation_593982, base: "",
    url: url_TagAssignToOperation_593983, schemes: {Scheme.Https})
type
  Call_TagGetEntityStateByOperation_594011 = ref object of OpenApiRestCall_593425
proc url_TagGetEntityStateByOperation_594013(protocol: Scheme; host: string;
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
  assert "tagId" in path, "`tagId` is a required path parameter"
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
               (kind: ConstantSegment, value: "/tags/"),
               (kind: VariableSegment, value: "tagId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagGetEntityStateByOperation_594012(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the entity state version of the tag specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tagId: JString (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
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
  assert path != nil, "path argument is necessary due to required `tagId` field"
  var valid_594014 = path.getOrDefault("tagId")
  valid_594014 = validateParameter(valid_594014, JString, required = true,
                                 default = nil)
  if valid_594014 != nil:
    section.add "tagId", valid_594014
  var valid_594015 = path.getOrDefault("resourceGroupName")
  valid_594015 = validateParameter(valid_594015, JString, required = true,
                                 default = nil)
  if valid_594015 != nil:
    section.add "resourceGroupName", valid_594015
  var valid_594016 = path.getOrDefault("apiId")
  valid_594016 = validateParameter(valid_594016, JString, required = true,
                                 default = nil)
  if valid_594016 != nil:
    section.add "apiId", valid_594016
  var valid_594017 = path.getOrDefault("subscriptionId")
  valid_594017 = validateParameter(valid_594017, JString, required = true,
                                 default = nil)
  if valid_594017 != nil:
    section.add "subscriptionId", valid_594017
  var valid_594018 = path.getOrDefault("serviceName")
  valid_594018 = validateParameter(valid_594018, JString, required = true,
                                 default = nil)
  if valid_594018 != nil:
    section.add "serviceName", valid_594018
  var valid_594019 = path.getOrDefault("operationId")
  valid_594019 = validateParameter(valid_594019, JString, required = true,
                                 default = nil)
  if valid_594019 != nil:
    section.add "operationId", valid_594019
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594020 = query.getOrDefault("api-version")
  valid_594020 = validateParameter(valid_594020, JString, required = true,
                                 default = nil)
  if valid_594020 != nil:
    section.add "api-version", valid_594020
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594021: Call_TagGetEntityStateByOperation_594011; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the entity state version of the tag specified by its identifier.
  ## 
  let valid = call_594021.validator(path, query, header, formData, body)
  let scheme = call_594021.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594021.url(scheme.get, call_594021.host, call_594021.base,
                         call_594021.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594021, url, valid)

proc call*(call_594022: Call_TagGetEntityStateByOperation_594011; tagId: string;
          resourceGroupName: string; apiVersion: string; apiId: string;
          subscriptionId: string; serviceName: string; operationId: string): Recallable =
  ## tagGetEntityStateByOperation
  ## Gets the entity state version of the tag specified by its identifier.
  ##   tagId: string (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
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
  var path_594023 = newJObject()
  var query_594024 = newJObject()
  add(path_594023, "tagId", newJString(tagId))
  add(path_594023, "resourceGroupName", newJString(resourceGroupName))
  add(query_594024, "api-version", newJString(apiVersion))
  add(path_594023, "apiId", newJString(apiId))
  add(path_594023, "subscriptionId", newJString(subscriptionId))
  add(path_594023, "serviceName", newJString(serviceName))
  add(path_594023, "operationId", newJString(operationId))
  result = call_594022.call(path_594023, query_594024, nil, nil, nil)

var tagGetEntityStateByOperation* = Call_TagGetEntityStateByOperation_594011(
    name: "tagGetEntityStateByOperation", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/operations/{operationId}/tags/{tagId}",
    validator: validate_TagGetEntityStateByOperation_594012, base: "",
    url: url_TagGetEntityStateByOperation_594013, schemes: {Scheme.Https})
type
  Call_TagGetByOperation_593958 = ref object of OpenApiRestCall_593425
proc url_TagGetByOperation_593960(protocol: Scheme; host: string; base: string;
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
  assert "tagId" in path, "`tagId` is a required path parameter"
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
               (kind: ConstantSegment, value: "/tags/"),
               (kind: VariableSegment, value: "tagId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagGetByOperation_593959(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Get tag associated with the Operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tagId: JString (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
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
  assert path != nil, "path argument is necessary due to required `tagId` field"
  var valid_593970 = path.getOrDefault("tagId")
  valid_593970 = validateParameter(valid_593970, JString, required = true,
                                 default = nil)
  if valid_593970 != nil:
    section.add "tagId", valid_593970
  var valid_593971 = path.getOrDefault("resourceGroupName")
  valid_593971 = validateParameter(valid_593971, JString, required = true,
                                 default = nil)
  if valid_593971 != nil:
    section.add "resourceGroupName", valid_593971
  var valid_593972 = path.getOrDefault("apiId")
  valid_593972 = validateParameter(valid_593972, JString, required = true,
                                 default = nil)
  if valid_593972 != nil:
    section.add "apiId", valid_593972
  var valid_593973 = path.getOrDefault("subscriptionId")
  valid_593973 = validateParameter(valid_593973, JString, required = true,
                                 default = nil)
  if valid_593973 != nil:
    section.add "subscriptionId", valid_593973
  var valid_593974 = path.getOrDefault("serviceName")
  valid_593974 = validateParameter(valid_593974, JString, required = true,
                                 default = nil)
  if valid_593974 != nil:
    section.add "serviceName", valid_593974
  var valid_593975 = path.getOrDefault("operationId")
  valid_593975 = validateParameter(valid_593975, JString, required = true,
                                 default = nil)
  if valid_593975 != nil:
    section.add "operationId", valid_593975
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593976 = query.getOrDefault("api-version")
  valid_593976 = validateParameter(valid_593976, JString, required = true,
                                 default = nil)
  if valid_593976 != nil:
    section.add "api-version", valid_593976
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593977: Call_TagGetByOperation_593958; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get tag associated with the Operation.
  ## 
  let valid = call_593977.validator(path, query, header, formData, body)
  let scheme = call_593977.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593977.url(scheme.get, call_593977.host, call_593977.base,
                         call_593977.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593977, url, valid)

proc call*(call_593978: Call_TagGetByOperation_593958; tagId: string;
          resourceGroupName: string; apiVersion: string; apiId: string;
          subscriptionId: string; serviceName: string; operationId: string): Recallable =
  ## tagGetByOperation
  ## Get tag associated with the Operation.
  ##   tagId: string (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
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
  var path_593979 = newJObject()
  var query_593980 = newJObject()
  add(path_593979, "tagId", newJString(tagId))
  add(path_593979, "resourceGroupName", newJString(resourceGroupName))
  add(query_593980, "api-version", newJString(apiVersion))
  add(path_593979, "apiId", newJString(apiId))
  add(path_593979, "subscriptionId", newJString(subscriptionId))
  add(path_593979, "serviceName", newJString(serviceName))
  add(path_593979, "operationId", newJString(operationId))
  result = call_593978.call(path_593979, query_593980, nil, nil, nil)

var tagGetByOperation* = Call_TagGetByOperation_593958(name: "tagGetByOperation",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/operations/{operationId}/tags/{tagId}",
    validator: validate_TagGetByOperation_593959, base: "",
    url: url_TagGetByOperation_593960, schemes: {Scheme.Https})
type
  Call_TagDetachFromOperation_593996 = ref object of OpenApiRestCall_593425
proc url_TagDetachFromOperation_593998(protocol: Scheme; host: string; base: string;
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
  assert "tagId" in path, "`tagId` is a required path parameter"
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
               (kind: ConstantSegment, value: "/tags/"),
               (kind: VariableSegment, value: "tagId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagDetachFromOperation_593997(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Detach the tag from the Operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tagId: JString (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
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
  assert path != nil, "path argument is necessary due to required `tagId` field"
  var valid_593999 = path.getOrDefault("tagId")
  valid_593999 = validateParameter(valid_593999, JString, required = true,
                                 default = nil)
  if valid_593999 != nil:
    section.add "tagId", valid_593999
  var valid_594000 = path.getOrDefault("resourceGroupName")
  valid_594000 = validateParameter(valid_594000, JString, required = true,
                                 default = nil)
  if valid_594000 != nil:
    section.add "resourceGroupName", valid_594000
  var valid_594001 = path.getOrDefault("apiId")
  valid_594001 = validateParameter(valid_594001, JString, required = true,
                                 default = nil)
  if valid_594001 != nil:
    section.add "apiId", valid_594001
  var valid_594002 = path.getOrDefault("subscriptionId")
  valid_594002 = validateParameter(valid_594002, JString, required = true,
                                 default = nil)
  if valid_594002 != nil:
    section.add "subscriptionId", valid_594002
  var valid_594003 = path.getOrDefault("serviceName")
  valid_594003 = validateParameter(valid_594003, JString, required = true,
                                 default = nil)
  if valid_594003 != nil:
    section.add "serviceName", valid_594003
  var valid_594004 = path.getOrDefault("operationId")
  valid_594004 = validateParameter(valid_594004, JString, required = true,
                                 default = nil)
  if valid_594004 != nil:
    section.add "operationId", valid_594004
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594005 = query.getOrDefault("api-version")
  valid_594005 = validateParameter(valid_594005, JString, required = true,
                                 default = nil)
  if valid_594005 != nil:
    section.add "api-version", valid_594005
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : The entity state (Etag) version of the Api schema to update. A value of "*" can be used for If-Match to unconditionally apply the operation.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_594006 = header.getOrDefault("If-Match")
  valid_594006 = validateParameter(valid_594006, JString, required = true,
                                 default = nil)
  if valid_594006 != nil:
    section.add "If-Match", valid_594006
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594007: Call_TagDetachFromOperation_593996; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Detach the tag from the Operation.
  ## 
  let valid = call_594007.validator(path, query, header, formData, body)
  let scheme = call_594007.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594007.url(scheme.get, call_594007.host, call_594007.base,
                         call_594007.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594007, url, valid)

proc call*(call_594008: Call_TagDetachFromOperation_593996; tagId: string;
          resourceGroupName: string; apiVersion: string; apiId: string;
          subscriptionId: string; serviceName: string; operationId: string): Recallable =
  ## tagDetachFromOperation
  ## Detach the tag from the Operation.
  ##   tagId: string (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
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
  var path_594009 = newJObject()
  var query_594010 = newJObject()
  add(path_594009, "tagId", newJString(tagId))
  add(path_594009, "resourceGroupName", newJString(resourceGroupName))
  add(query_594010, "api-version", newJString(apiVersion))
  add(path_594009, "apiId", newJString(apiId))
  add(path_594009, "subscriptionId", newJString(subscriptionId))
  add(path_594009, "serviceName", newJString(serviceName))
  add(path_594009, "operationId", newJString(operationId))
  result = call_594008.call(path_594009, query_594010, nil, nil, nil)

var tagDetachFromOperation* = Call_TagDetachFromOperation_593996(
    name: "tagDetachFromOperation", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/operations/{operationId}/tags/{tagId}",
    validator: validate_TagDetachFromOperation_593997, base: "",
    url: url_TagDetachFromOperation_593998, schemes: {Scheme.Https})
type
  Call_OperationListByTags_594025 = ref object of OpenApiRestCall_593425
proc url_OperationListByTags_594027(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/operationsByTags")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_OperationListByTags_594026(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Lists a collection of operations associated with tags.
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
  var valid_594028 = path.getOrDefault("resourceGroupName")
  valid_594028 = validateParameter(valid_594028, JString, required = true,
                                 default = nil)
  if valid_594028 != nil:
    section.add "resourceGroupName", valid_594028
  var valid_594029 = path.getOrDefault("apiId")
  valid_594029 = validateParameter(valid_594029, JString, required = true,
                                 default = nil)
  if valid_594029 != nil:
    section.add "apiId", valid_594029
  var valid_594030 = path.getOrDefault("subscriptionId")
  valid_594030 = validateParameter(valid_594030, JString, required = true,
                                 default = nil)
  if valid_594030 != nil:
    section.add "subscriptionId", valid_594030
  var valid_594031 = path.getOrDefault("serviceName")
  valid_594031 = validateParameter(valid_594031, JString, required = true,
                                 default = nil)
  if valid_594031 != nil:
    section.add "serviceName", valid_594031
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
  ## | apiName     | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | description | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | method      | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | urlTemplate | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594032 = query.getOrDefault("api-version")
  valid_594032 = validateParameter(valid_594032, JString, required = true,
                                 default = nil)
  if valid_594032 != nil:
    section.add "api-version", valid_594032
  var valid_594033 = query.getOrDefault("$top")
  valid_594033 = validateParameter(valid_594033, JInt, required = false, default = nil)
  if valid_594033 != nil:
    section.add "$top", valid_594033
  var valid_594034 = query.getOrDefault("$skip")
  valid_594034 = validateParameter(valid_594034, JInt, required = false, default = nil)
  if valid_594034 != nil:
    section.add "$skip", valid_594034
  var valid_594035 = query.getOrDefault("$filter")
  valid_594035 = validateParameter(valid_594035, JString, required = false,
                                 default = nil)
  if valid_594035 != nil:
    section.add "$filter", valid_594035
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594036: Call_OperationListByTags_594025; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a collection of operations associated with tags.
  ## 
  let valid = call_594036.validator(path, query, header, formData, body)
  let scheme = call_594036.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594036.url(scheme.get, call_594036.host, call_594036.base,
                         call_594036.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594036, url, valid)

proc call*(call_594037: Call_OperationListByTags_594025; resourceGroupName: string;
          apiVersion: string; apiId: string; subscriptionId: string;
          serviceName: string; Top: int = 0; Skip: int = 0; Filter: string = ""): Recallable =
  ## operationListByTags
  ## Lists a collection of operations associated with tags.
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
  ##         : | Field       | Supported operators    | Supported functions                         |
  ## 
  ## |-------------|------------------------|---------------------------------------------|
  ## | id          | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | name        | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | apiName     | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | description | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | method      | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | urlTemplate | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  var path_594038 = newJObject()
  var query_594039 = newJObject()
  add(path_594038, "resourceGroupName", newJString(resourceGroupName))
  add(query_594039, "api-version", newJString(apiVersion))
  add(path_594038, "apiId", newJString(apiId))
  add(path_594038, "subscriptionId", newJString(subscriptionId))
  add(query_594039, "$top", newJInt(Top))
  add(query_594039, "$skip", newJInt(Skip))
  add(path_594038, "serviceName", newJString(serviceName))
  add(query_594039, "$filter", newJString(Filter))
  result = call_594037.call(path_594038, query_594039, nil, nil, nil)

var operationListByTags* = Call_OperationListByTags_594025(
    name: "operationListByTags", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/operationsByTags",
    validator: validate_OperationListByTags_594026, base: "",
    url: url_OperationListByTags_594027, schemes: {Scheme.Https})
type
  Call_TagDescriptionListByApi_594040 = ref object of OpenApiRestCall_593425
proc url_TagDescriptionListByApi_594042(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/tagDescriptions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagDescriptionListByApi_594041(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all Tags descriptions in scope of API. Model similar to swagger - tagDescription is defined on API level but tag may be assigned to the Operations
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
  var valid_594043 = path.getOrDefault("resourceGroupName")
  valid_594043 = validateParameter(valid_594043, JString, required = true,
                                 default = nil)
  if valid_594043 != nil:
    section.add "resourceGroupName", valid_594043
  var valid_594044 = path.getOrDefault("apiId")
  valid_594044 = validateParameter(valid_594044, JString, required = true,
                                 default = nil)
  if valid_594044 != nil:
    section.add "apiId", valid_594044
  var valid_594045 = path.getOrDefault("subscriptionId")
  valid_594045 = validateParameter(valid_594045, JString, required = true,
                                 default = nil)
  if valid_594045 != nil:
    section.add "subscriptionId", valid_594045
  var valid_594046 = path.getOrDefault("serviceName")
  valid_594046 = validateParameter(valid_594046, JString, required = true,
                                 default = nil)
  if valid_594046 != nil:
    section.add "serviceName", valid_594046
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
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594047 = query.getOrDefault("api-version")
  valid_594047 = validateParameter(valid_594047, JString, required = true,
                                 default = nil)
  if valid_594047 != nil:
    section.add "api-version", valid_594047
  var valid_594048 = query.getOrDefault("$top")
  valid_594048 = validateParameter(valid_594048, JInt, required = false, default = nil)
  if valid_594048 != nil:
    section.add "$top", valid_594048
  var valid_594049 = query.getOrDefault("$skip")
  valid_594049 = validateParameter(valid_594049, JInt, required = false, default = nil)
  if valid_594049 != nil:
    section.add "$skip", valid_594049
  var valid_594050 = query.getOrDefault("$filter")
  valid_594050 = validateParameter(valid_594050, JString, required = false,
                                 default = nil)
  if valid_594050 != nil:
    section.add "$filter", valid_594050
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594051: Call_TagDescriptionListByApi_594040; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all Tags descriptions in scope of API. Model similar to swagger - tagDescription is defined on API level but tag may be assigned to the Operations
  ## 
  let valid = call_594051.validator(path, query, header, formData, body)
  let scheme = call_594051.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594051.url(scheme.get, call_594051.host, call_594051.base,
                         call_594051.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594051, url, valid)

proc call*(call_594052: Call_TagDescriptionListByApi_594040;
          resourceGroupName: string; apiVersion: string; apiId: string;
          subscriptionId: string; serviceName: string; Top: int = 0; Skip: int = 0;
          Filter: string = ""): Recallable =
  ## tagDescriptionListByApi
  ## Lists all Tags descriptions in scope of API. Model similar to swagger - tagDescription is defined on API level but tag may be assigned to the Operations
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
  ##         : | Field       | Supported operators    | Supported functions                         |
  ## 
  ## |-------------|------------------------|---------------------------------------------|
  ## | id          | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | name        | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  var path_594053 = newJObject()
  var query_594054 = newJObject()
  add(path_594053, "resourceGroupName", newJString(resourceGroupName))
  add(query_594054, "api-version", newJString(apiVersion))
  add(path_594053, "apiId", newJString(apiId))
  add(path_594053, "subscriptionId", newJString(subscriptionId))
  add(query_594054, "$top", newJInt(Top))
  add(query_594054, "$skip", newJInt(Skip))
  add(path_594053, "serviceName", newJString(serviceName))
  add(query_594054, "$filter", newJString(Filter))
  result = call_594052.call(path_594053, query_594054, nil, nil, nil)

var tagDescriptionListByApi* = Call_TagDescriptionListByApi_594040(
    name: "tagDescriptionListByApi", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/tagDescriptions",
    validator: validate_TagDescriptionListByApi_594041, base: "",
    url: url_TagDescriptionListByApi_594042, schemes: {Scheme.Https})
type
  Call_TagDescriptionCreateOrUpdate_594068 = ref object of OpenApiRestCall_593425
proc url_TagDescriptionCreateOrUpdate_594070(protocol: Scheme; host: string;
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
  assert "tagId" in path, "`tagId` is a required path parameter"
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
               (kind: ConstantSegment, value: "/tagDescriptions/"),
               (kind: VariableSegment, value: "tagId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagDescriptionCreateOrUpdate_594069(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create/Update tag description in scope of the Api.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tagId: JString (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tagId` field"
  var valid_594088 = path.getOrDefault("tagId")
  valid_594088 = validateParameter(valid_594088, JString, required = true,
                                 default = nil)
  if valid_594088 != nil:
    section.add "tagId", valid_594088
  var valid_594089 = path.getOrDefault("resourceGroupName")
  valid_594089 = validateParameter(valid_594089, JString, required = true,
                                 default = nil)
  if valid_594089 != nil:
    section.add "resourceGroupName", valid_594089
  var valid_594090 = path.getOrDefault("apiId")
  valid_594090 = validateParameter(valid_594090, JString, required = true,
                                 default = nil)
  if valid_594090 != nil:
    section.add "apiId", valid_594090
  var valid_594091 = path.getOrDefault("subscriptionId")
  valid_594091 = validateParameter(valid_594091, JString, required = true,
                                 default = nil)
  if valid_594091 != nil:
    section.add "subscriptionId", valid_594091
  var valid_594092 = path.getOrDefault("serviceName")
  valid_594092 = validateParameter(valid_594092, JString, required = true,
                                 default = nil)
  if valid_594092 != nil:
    section.add "serviceName", valid_594092
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594093 = query.getOrDefault("api-version")
  valid_594093 = validateParameter(valid_594093, JString, required = true,
                                 default = nil)
  if valid_594093 != nil:
    section.add "api-version", valid_594093
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : The entity state (Etag) version of the Tag to update. A value of "*" can be used for If-Match to unconditionally apply the operation.
  section = newJObject()
  var valid_594094 = header.getOrDefault("If-Match")
  valid_594094 = validateParameter(valid_594094, JString, required = false,
                                 default = nil)
  if valid_594094 != nil:
    section.add "If-Match", valid_594094
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

proc call*(call_594096: Call_TagDescriptionCreateOrUpdate_594068; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create/Update tag description in scope of the Api.
  ## 
  let valid = call_594096.validator(path, query, header, formData, body)
  let scheme = call_594096.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594096.url(scheme.get, call_594096.host, call_594096.base,
                         call_594096.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594096, url, valid)

proc call*(call_594097: Call_TagDescriptionCreateOrUpdate_594068; tagId: string;
          resourceGroupName: string; apiVersion: string; apiId: string;
          subscriptionId: string; parameters: JsonNode; serviceName: string): Recallable =
  ## tagDescriptionCreateOrUpdate
  ## Create/Update tag description in scope of the Api.
  ##   tagId: string (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Create parameters.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594098 = newJObject()
  var query_594099 = newJObject()
  var body_594100 = newJObject()
  add(path_594098, "tagId", newJString(tagId))
  add(path_594098, "resourceGroupName", newJString(resourceGroupName))
  add(query_594099, "api-version", newJString(apiVersion))
  add(path_594098, "apiId", newJString(apiId))
  add(path_594098, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594100 = parameters
  add(path_594098, "serviceName", newJString(serviceName))
  result = call_594097.call(path_594098, query_594099, nil, nil, body_594100)

var tagDescriptionCreateOrUpdate* = Call_TagDescriptionCreateOrUpdate_594068(
    name: "tagDescriptionCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/tagDescriptions/{tagId}",
    validator: validate_TagDescriptionCreateOrUpdate_594069, base: "",
    url: url_TagDescriptionCreateOrUpdate_594070, schemes: {Scheme.Https})
type
  Call_TagDescriptionGetEntityState_594115 = ref object of OpenApiRestCall_593425
proc url_TagDescriptionGetEntityState_594117(protocol: Scheme; host: string;
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
  assert "tagId" in path, "`tagId` is a required path parameter"
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
               (kind: ConstantSegment, value: "/tagDescriptions/"),
               (kind: VariableSegment, value: "tagId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagDescriptionGetEntityState_594116(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the entity state version of the tag specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tagId: JString (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tagId` field"
  var valid_594118 = path.getOrDefault("tagId")
  valid_594118 = validateParameter(valid_594118, JString, required = true,
                                 default = nil)
  if valid_594118 != nil:
    section.add "tagId", valid_594118
  var valid_594119 = path.getOrDefault("resourceGroupName")
  valid_594119 = validateParameter(valid_594119, JString, required = true,
                                 default = nil)
  if valid_594119 != nil:
    section.add "resourceGroupName", valid_594119
  var valid_594120 = path.getOrDefault("apiId")
  valid_594120 = validateParameter(valid_594120, JString, required = true,
                                 default = nil)
  if valid_594120 != nil:
    section.add "apiId", valid_594120
  var valid_594121 = path.getOrDefault("subscriptionId")
  valid_594121 = validateParameter(valid_594121, JString, required = true,
                                 default = nil)
  if valid_594121 != nil:
    section.add "subscriptionId", valid_594121
  var valid_594122 = path.getOrDefault("serviceName")
  valid_594122 = validateParameter(valid_594122, JString, required = true,
                                 default = nil)
  if valid_594122 != nil:
    section.add "serviceName", valid_594122
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594123 = query.getOrDefault("api-version")
  valid_594123 = validateParameter(valid_594123, JString, required = true,
                                 default = nil)
  if valid_594123 != nil:
    section.add "api-version", valid_594123
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594124: Call_TagDescriptionGetEntityState_594115; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the entity state version of the tag specified by its identifier.
  ## 
  let valid = call_594124.validator(path, query, header, formData, body)
  let scheme = call_594124.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594124.url(scheme.get, call_594124.host, call_594124.base,
                         call_594124.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594124, url, valid)

proc call*(call_594125: Call_TagDescriptionGetEntityState_594115; tagId: string;
          resourceGroupName: string; apiVersion: string; apiId: string;
          subscriptionId: string; serviceName: string): Recallable =
  ## tagDescriptionGetEntityState
  ## Gets the entity state version of the tag specified by its identifier.
  ##   tagId: string (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
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
  var path_594126 = newJObject()
  var query_594127 = newJObject()
  add(path_594126, "tagId", newJString(tagId))
  add(path_594126, "resourceGroupName", newJString(resourceGroupName))
  add(query_594127, "api-version", newJString(apiVersion))
  add(path_594126, "apiId", newJString(apiId))
  add(path_594126, "subscriptionId", newJString(subscriptionId))
  add(path_594126, "serviceName", newJString(serviceName))
  result = call_594125.call(path_594126, query_594127, nil, nil, nil)

var tagDescriptionGetEntityState* = Call_TagDescriptionGetEntityState_594115(
    name: "tagDescriptionGetEntityState", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/tagDescriptions/{tagId}",
    validator: validate_TagDescriptionGetEntityState_594116, base: "",
    url: url_TagDescriptionGetEntityState_594117, schemes: {Scheme.Https})
type
  Call_TagDescriptionGet_594055 = ref object of OpenApiRestCall_593425
proc url_TagDescriptionGet_594057(protocol: Scheme; host: string; base: string;
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
  assert "tagId" in path, "`tagId` is a required path parameter"
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
               (kind: ConstantSegment, value: "/tagDescriptions/"),
               (kind: VariableSegment, value: "tagId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagDescriptionGet_594056(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Get tag associated with the API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tagId: JString (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tagId` field"
  var valid_594058 = path.getOrDefault("tagId")
  valid_594058 = validateParameter(valid_594058, JString, required = true,
                                 default = nil)
  if valid_594058 != nil:
    section.add "tagId", valid_594058
  var valid_594059 = path.getOrDefault("resourceGroupName")
  valid_594059 = validateParameter(valid_594059, JString, required = true,
                                 default = nil)
  if valid_594059 != nil:
    section.add "resourceGroupName", valid_594059
  var valid_594060 = path.getOrDefault("apiId")
  valid_594060 = validateParameter(valid_594060, JString, required = true,
                                 default = nil)
  if valid_594060 != nil:
    section.add "apiId", valid_594060
  var valid_594061 = path.getOrDefault("subscriptionId")
  valid_594061 = validateParameter(valid_594061, JString, required = true,
                                 default = nil)
  if valid_594061 != nil:
    section.add "subscriptionId", valid_594061
  var valid_594062 = path.getOrDefault("serviceName")
  valid_594062 = validateParameter(valid_594062, JString, required = true,
                                 default = nil)
  if valid_594062 != nil:
    section.add "serviceName", valid_594062
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594063 = query.getOrDefault("api-version")
  valid_594063 = validateParameter(valid_594063, JString, required = true,
                                 default = nil)
  if valid_594063 != nil:
    section.add "api-version", valid_594063
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594064: Call_TagDescriptionGet_594055; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get tag associated with the API.
  ## 
  let valid = call_594064.validator(path, query, header, formData, body)
  let scheme = call_594064.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594064.url(scheme.get, call_594064.host, call_594064.base,
                         call_594064.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594064, url, valid)

proc call*(call_594065: Call_TagDescriptionGet_594055; tagId: string;
          resourceGroupName: string; apiVersion: string; apiId: string;
          subscriptionId: string; serviceName: string): Recallable =
  ## tagDescriptionGet
  ## Get tag associated with the API.
  ##   tagId: string (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
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
  var path_594066 = newJObject()
  var query_594067 = newJObject()
  add(path_594066, "tagId", newJString(tagId))
  add(path_594066, "resourceGroupName", newJString(resourceGroupName))
  add(query_594067, "api-version", newJString(apiVersion))
  add(path_594066, "apiId", newJString(apiId))
  add(path_594066, "subscriptionId", newJString(subscriptionId))
  add(path_594066, "serviceName", newJString(serviceName))
  result = call_594065.call(path_594066, query_594067, nil, nil, nil)

var tagDescriptionGet* = Call_TagDescriptionGet_594055(name: "tagDescriptionGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/tagDescriptions/{tagId}",
    validator: validate_TagDescriptionGet_594056, base: "",
    url: url_TagDescriptionGet_594057, schemes: {Scheme.Https})
type
  Call_TagDescriptionDelete_594101 = ref object of OpenApiRestCall_593425
proc url_TagDescriptionDelete_594103(protocol: Scheme; host: string; base: string;
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
  assert "tagId" in path, "`tagId` is a required path parameter"
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
               (kind: ConstantSegment, value: "/tagDescriptions/"),
               (kind: VariableSegment, value: "tagId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagDescriptionDelete_594102(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete tag description for the Api.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tagId: JString (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tagId` field"
  var valid_594104 = path.getOrDefault("tagId")
  valid_594104 = validateParameter(valid_594104, JString, required = true,
                                 default = nil)
  if valid_594104 != nil:
    section.add "tagId", valid_594104
  var valid_594105 = path.getOrDefault("resourceGroupName")
  valid_594105 = validateParameter(valid_594105, JString, required = true,
                                 default = nil)
  if valid_594105 != nil:
    section.add "resourceGroupName", valid_594105
  var valid_594106 = path.getOrDefault("apiId")
  valid_594106 = validateParameter(valid_594106, JString, required = true,
                                 default = nil)
  if valid_594106 != nil:
    section.add "apiId", valid_594106
  var valid_594107 = path.getOrDefault("subscriptionId")
  valid_594107 = validateParameter(valid_594107, JString, required = true,
                                 default = nil)
  if valid_594107 != nil:
    section.add "subscriptionId", valid_594107
  var valid_594108 = path.getOrDefault("serviceName")
  valid_594108 = validateParameter(valid_594108, JString, required = true,
                                 default = nil)
  if valid_594108 != nil:
    section.add "serviceName", valid_594108
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594109 = query.getOrDefault("api-version")
  valid_594109 = validateParameter(valid_594109, JString, required = true,
                                 default = nil)
  if valid_594109 != nil:
    section.add "api-version", valid_594109
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : The entity state (Etag) version of the Api schema to update. A value of "*" can be used for If-Match to unconditionally apply the operation.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_594110 = header.getOrDefault("If-Match")
  valid_594110 = validateParameter(valid_594110, JString, required = true,
                                 default = nil)
  if valid_594110 != nil:
    section.add "If-Match", valid_594110
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594111: Call_TagDescriptionDelete_594101; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete tag description for the Api.
  ## 
  let valid = call_594111.validator(path, query, header, formData, body)
  let scheme = call_594111.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594111.url(scheme.get, call_594111.host, call_594111.base,
                         call_594111.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594111, url, valid)

proc call*(call_594112: Call_TagDescriptionDelete_594101; tagId: string;
          resourceGroupName: string; apiVersion: string; apiId: string;
          subscriptionId: string; serviceName: string): Recallable =
  ## tagDescriptionDelete
  ## Delete tag description for the Api.
  ##   tagId: string (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
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
  var path_594113 = newJObject()
  var query_594114 = newJObject()
  add(path_594113, "tagId", newJString(tagId))
  add(path_594113, "resourceGroupName", newJString(resourceGroupName))
  add(query_594114, "api-version", newJString(apiVersion))
  add(path_594113, "apiId", newJString(apiId))
  add(path_594113, "subscriptionId", newJString(subscriptionId))
  add(path_594113, "serviceName", newJString(serviceName))
  result = call_594112.call(path_594113, query_594114, nil, nil, nil)

var tagDescriptionDelete* = Call_TagDescriptionDelete_594101(
    name: "tagDescriptionDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/tagDescriptions/{tagId}",
    validator: validate_TagDescriptionDelete_594102, base: "",
    url: url_TagDescriptionDelete_594103, schemes: {Scheme.Https})
type
  Call_TagListByApi_594128 = ref object of OpenApiRestCall_593425
proc url_TagListByApi_594130(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/tags")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagListByApi_594129(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all Tags associated with the API.
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
  var valid_594131 = path.getOrDefault("resourceGroupName")
  valid_594131 = validateParameter(valid_594131, JString, required = true,
                                 default = nil)
  if valid_594131 != nil:
    section.add "resourceGroupName", valid_594131
  var valid_594132 = path.getOrDefault("apiId")
  valid_594132 = validateParameter(valid_594132, JString, required = true,
                                 default = nil)
  if valid_594132 != nil:
    section.add "apiId", valid_594132
  var valid_594133 = path.getOrDefault("subscriptionId")
  valid_594133 = validateParameter(valid_594133, JString, required = true,
                                 default = nil)
  if valid_594133 != nil:
    section.add "subscriptionId", valid_594133
  var valid_594134 = path.getOrDefault("serviceName")
  valid_594134 = validateParameter(valid_594134, JString, required = true,
                                 default = nil)
  if valid_594134 != nil:
    section.add "serviceName", valid_594134
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
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594135 = query.getOrDefault("api-version")
  valid_594135 = validateParameter(valid_594135, JString, required = true,
                                 default = nil)
  if valid_594135 != nil:
    section.add "api-version", valid_594135
  var valid_594136 = query.getOrDefault("$top")
  valid_594136 = validateParameter(valid_594136, JInt, required = false, default = nil)
  if valid_594136 != nil:
    section.add "$top", valid_594136
  var valid_594137 = query.getOrDefault("$skip")
  valid_594137 = validateParameter(valid_594137, JInt, required = false, default = nil)
  if valid_594137 != nil:
    section.add "$skip", valid_594137
  var valid_594138 = query.getOrDefault("$filter")
  valid_594138 = validateParameter(valid_594138, JString, required = false,
                                 default = nil)
  if valid_594138 != nil:
    section.add "$filter", valid_594138
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594139: Call_TagListByApi_594128; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all Tags associated with the API.
  ## 
  let valid = call_594139.validator(path, query, header, formData, body)
  let scheme = call_594139.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594139.url(scheme.get, call_594139.host, call_594139.base,
                         call_594139.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594139, url, valid)

proc call*(call_594140: Call_TagListByApi_594128; resourceGroupName: string;
          apiVersion: string; apiId: string; subscriptionId: string;
          serviceName: string; Top: int = 0; Skip: int = 0; Filter: string = ""): Recallable =
  ## tagListByApi
  ## Lists all Tags associated with the API.
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
  ##         : | Field       | Supported operators    | Supported functions                         |
  ## 
  ## |-------------|------------------------|---------------------------------------------|
  ## | id          | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | name        | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  var path_594141 = newJObject()
  var query_594142 = newJObject()
  add(path_594141, "resourceGroupName", newJString(resourceGroupName))
  add(query_594142, "api-version", newJString(apiVersion))
  add(path_594141, "apiId", newJString(apiId))
  add(path_594141, "subscriptionId", newJString(subscriptionId))
  add(query_594142, "$top", newJInt(Top))
  add(query_594142, "$skip", newJInt(Skip))
  add(path_594141, "serviceName", newJString(serviceName))
  add(query_594142, "$filter", newJString(Filter))
  result = call_594140.call(path_594141, query_594142, nil, nil, nil)

var tagListByApi* = Call_TagListByApi_594128(name: "tagListByApi",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/tags",
    validator: validate_TagListByApi_594129, base: "", url: url_TagListByApi_594130,
    schemes: {Scheme.Https})
type
  Call_TagAssignToApi_594156 = ref object of OpenApiRestCall_593425
proc url_TagAssignToApi_594158(protocol: Scheme; host: string; base: string;
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
  assert "tagId" in path, "`tagId` is a required path parameter"
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
               (kind: ConstantSegment, value: "/tags/"),
               (kind: VariableSegment, value: "tagId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagAssignToApi_594157(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Assign tag to the Api.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tagId: JString (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tagId` field"
  var valid_594159 = path.getOrDefault("tagId")
  valid_594159 = validateParameter(valid_594159, JString, required = true,
                                 default = nil)
  if valid_594159 != nil:
    section.add "tagId", valid_594159
  var valid_594160 = path.getOrDefault("resourceGroupName")
  valid_594160 = validateParameter(valid_594160, JString, required = true,
                                 default = nil)
  if valid_594160 != nil:
    section.add "resourceGroupName", valid_594160
  var valid_594161 = path.getOrDefault("apiId")
  valid_594161 = validateParameter(valid_594161, JString, required = true,
                                 default = nil)
  if valid_594161 != nil:
    section.add "apiId", valid_594161
  var valid_594162 = path.getOrDefault("subscriptionId")
  valid_594162 = validateParameter(valid_594162, JString, required = true,
                                 default = nil)
  if valid_594162 != nil:
    section.add "subscriptionId", valid_594162
  var valid_594163 = path.getOrDefault("serviceName")
  valid_594163 = validateParameter(valid_594163, JString, required = true,
                                 default = nil)
  if valid_594163 != nil:
    section.add "serviceName", valid_594163
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594164 = query.getOrDefault("api-version")
  valid_594164 = validateParameter(valid_594164, JString, required = true,
                                 default = nil)
  if valid_594164 != nil:
    section.add "api-version", valid_594164
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : The entity state (Etag) version of the Tag to update. A value of "*" can be used for If-Match to unconditionally apply the operation.
  section = newJObject()
  var valid_594165 = header.getOrDefault("If-Match")
  valid_594165 = validateParameter(valid_594165, JString, required = false,
                                 default = nil)
  if valid_594165 != nil:
    section.add "If-Match", valid_594165
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594166: Call_TagAssignToApi_594156; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Assign tag to the Api.
  ## 
  let valid = call_594166.validator(path, query, header, formData, body)
  let scheme = call_594166.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594166.url(scheme.get, call_594166.host, call_594166.base,
                         call_594166.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594166, url, valid)

proc call*(call_594167: Call_TagAssignToApi_594156; tagId: string;
          resourceGroupName: string; apiVersion: string; apiId: string;
          subscriptionId: string; serviceName: string): Recallable =
  ## tagAssignToApi
  ## Assign tag to the Api.
  ##   tagId: string (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
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
  var path_594168 = newJObject()
  var query_594169 = newJObject()
  add(path_594168, "tagId", newJString(tagId))
  add(path_594168, "resourceGroupName", newJString(resourceGroupName))
  add(query_594169, "api-version", newJString(apiVersion))
  add(path_594168, "apiId", newJString(apiId))
  add(path_594168, "subscriptionId", newJString(subscriptionId))
  add(path_594168, "serviceName", newJString(serviceName))
  result = call_594167.call(path_594168, query_594169, nil, nil, nil)

var tagAssignToApi* = Call_TagAssignToApi_594156(name: "tagAssignToApi",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/tags/{tagId}",
    validator: validate_TagAssignToApi_594157, base: "", url: url_TagAssignToApi_594158,
    schemes: {Scheme.Https})
type
  Call_TagGetEntityStateByApi_594184 = ref object of OpenApiRestCall_593425
proc url_TagGetEntityStateByApi_594186(protocol: Scheme; host: string; base: string;
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
  assert "tagId" in path, "`tagId` is a required path parameter"
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
               (kind: ConstantSegment, value: "/tags/"),
               (kind: VariableSegment, value: "tagId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagGetEntityStateByApi_594185(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the entity state version of the tag specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tagId: JString (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tagId` field"
  var valid_594187 = path.getOrDefault("tagId")
  valid_594187 = validateParameter(valid_594187, JString, required = true,
                                 default = nil)
  if valid_594187 != nil:
    section.add "tagId", valid_594187
  var valid_594188 = path.getOrDefault("resourceGroupName")
  valid_594188 = validateParameter(valid_594188, JString, required = true,
                                 default = nil)
  if valid_594188 != nil:
    section.add "resourceGroupName", valid_594188
  var valid_594189 = path.getOrDefault("apiId")
  valid_594189 = validateParameter(valid_594189, JString, required = true,
                                 default = nil)
  if valid_594189 != nil:
    section.add "apiId", valid_594189
  var valid_594190 = path.getOrDefault("subscriptionId")
  valid_594190 = validateParameter(valid_594190, JString, required = true,
                                 default = nil)
  if valid_594190 != nil:
    section.add "subscriptionId", valid_594190
  var valid_594191 = path.getOrDefault("serviceName")
  valid_594191 = validateParameter(valid_594191, JString, required = true,
                                 default = nil)
  if valid_594191 != nil:
    section.add "serviceName", valid_594191
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594192 = query.getOrDefault("api-version")
  valid_594192 = validateParameter(valid_594192, JString, required = true,
                                 default = nil)
  if valid_594192 != nil:
    section.add "api-version", valid_594192
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594193: Call_TagGetEntityStateByApi_594184; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the entity state version of the tag specified by its identifier.
  ## 
  let valid = call_594193.validator(path, query, header, formData, body)
  let scheme = call_594193.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594193.url(scheme.get, call_594193.host, call_594193.base,
                         call_594193.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594193, url, valid)

proc call*(call_594194: Call_TagGetEntityStateByApi_594184; tagId: string;
          resourceGroupName: string; apiVersion: string; apiId: string;
          subscriptionId: string; serviceName: string): Recallable =
  ## tagGetEntityStateByApi
  ## Gets the entity state version of the tag specified by its identifier.
  ##   tagId: string (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
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
  var path_594195 = newJObject()
  var query_594196 = newJObject()
  add(path_594195, "tagId", newJString(tagId))
  add(path_594195, "resourceGroupName", newJString(resourceGroupName))
  add(query_594196, "api-version", newJString(apiVersion))
  add(path_594195, "apiId", newJString(apiId))
  add(path_594195, "subscriptionId", newJString(subscriptionId))
  add(path_594195, "serviceName", newJString(serviceName))
  result = call_594194.call(path_594195, query_594196, nil, nil, nil)

var tagGetEntityStateByApi* = Call_TagGetEntityStateByApi_594184(
    name: "tagGetEntityStateByApi", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/tags/{tagId}",
    validator: validate_TagGetEntityStateByApi_594185, base: "",
    url: url_TagGetEntityStateByApi_594186, schemes: {Scheme.Https})
type
  Call_TagGetByApi_594143 = ref object of OpenApiRestCall_593425
proc url_TagGetByApi_594145(protocol: Scheme; host: string; base: string;
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
  assert "tagId" in path, "`tagId` is a required path parameter"
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
               (kind: ConstantSegment, value: "/tags/"),
               (kind: VariableSegment, value: "tagId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagGetByApi_594144(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Get tag associated with the API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tagId: JString (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tagId` field"
  var valid_594146 = path.getOrDefault("tagId")
  valid_594146 = validateParameter(valid_594146, JString, required = true,
                                 default = nil)
  if valid_594146 != nil:
    section.add "tagId", valid_594146
  var valid_594147 = path.getOrDefault("resourceGroupName")
  valid_594147 = validateParameter(valid_594147, JString, required = true,
                                 default = nil)
  if valid_594147 != nil:
    section.add "resourceGroupName", valid_594147
  var valid_594148 = path.getOrDefault("apiId")
  valid_594148 = validateParameter(valid_594148, JString, required = true,
                                 default = nil)
  if valid_594148 != nil:
    section.add "apiId", valid_594148
  var valid_594149 = path.getOrDefault("subscriptionId")
  valid_594149 = validateParameter(valid_594149, JString, required = true,
                                 default = nil)
  if valid_594149 != nil:
    section.add "subscriptionId", valid_594149
  var valid_594150 = path.getOrDefault("serviceName")
  valid_594150 = validateParameter(valid_594150, JString, required = true,
                                 default = nil)
  if valid_594150 != nil:
    section.add "serviceName", valid_594150
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594151 = query.getOrDefault("api-version")
  valid_594151 = validateParameter(valid_594151, JString, required = true,
                                 default = nil)
  if valid_594151 != nil:
    section.add "api-version", valid_594151
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594152: Call_TagGetByApi_594143; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get tag associated with the API.
  ## 
  let valid = call_594152.validator(path, query, header, formData, body)
  let scheme = call_594152.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594152.url(scheme.get, call_594152.host, call_594152.base,
                         call_594152.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594152, url, valid)

proc call*(call_594153: Call_TagGetByApi_594143; tagId: string;
          resourceGroupName: string; apiVersion: string; apiId: string;
          subscriptionId: string; serviceName: string): Recallable =
  ## tagGetByApi
  ## Get tag associated with the API.
  ##   tagId: string (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
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
  var path_594154 = newJObject()
  var query_594155 = newJObject()
  add(path_594154, "tagId", newJString(tagId))
  add(path_594154, "resourceGroupName", newJString(resourceGroupName))
  add(query_594155, "api-version", newJString(apiVersion))
  add(path_594154, "apiId", newJString(apiId))
  add(path_594154, "subscriptionId", newJString(subscriptionId))
  add(path_594154, "serviceName", newJString(serviceName))
  result = call_594153.call(path_594154, query_594155, nil, nil, nil)

var tagGetByApi* = Call_TagGetByApi_594143(name: "tagGetByApi",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/tags/{tagId}",
                                        validator: validate_TagGetByApi_594144,
                                        base: "", url: url_TagGetByApi_594145,
                                        schemes: {Scheme.Https})
type
  Call_TagDetachFromApi_594170 = ref object of OpenApiRestCall_593425
proc url_TagDetachFromApi_594172(protocol: Scheme; host: string; base: string;
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
  assert "tagId" in path, "`tagId` is a required path parameter"
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
               (kind: ConstantSegment, value: "/tags/"),
               (kind: VariableSegment, value: "tagId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagDetachFromApi_594171(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Detach the tag from the Api.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tagId: JString (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tagId` field"
  var valid_594173 = path.getOrDefault("tagId")
  valid_594173 = validateParameter(valid_594173, JString, required = true,
                                 default = nil)
  if valid_594173 != nil:
    section.add "tagId", valid_594173
  var valid_594174 = path.getOrDefault("resourceGroupName")
  valid_594174 = validateParameter(valid_594174, JString, required = true,
                                 default = nil)
  if valid_594174 != nil:
    section.add "resourceGroupName", valid_594174
  var valid_594175 = path.getOrDefault("apiId")
  valid_594175 = validateParameter(valid_594175, JString, required = true,
                                 default = nil)
  if valid_594175 != nil:
    section.add "apiId", valid_594175
  var valid_594176 = path.getOrDefault("subscriptionId")
  valid_594176 = validateParameter(valid_594176, JString, required = true,
                                 default = nil)
  if valid_594176 != nil:
    section.add "subscriptionId", valid_594176
  var valid_594177 = path.getOrDefault("serviceName")
  valid_594177 = validateParameter(valid_594177, JString, required = true,
                                 default = nil)
  if valid_594177 != nil:
    section.add "serviceName", valid_594177
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594178 = query.getOrDefault("api-version")
  valid_594178 = validateParameter(valid_594178, JString, required = true,
                                 default = nil)
  if valid_594178 != nil:
    section.add "api-version", valid_594178
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : The entity state (Etag) version of the Api schema to update. A value of "*" can be used for If-Match to unconditionally apply the operation.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_594179 = header.getOrDefault("If-Match")
  valid_594179 = validateParameter(valid_594179, JString, required = true,
                                 default = nil)
  if valid_594179 != nil:
    section.add "If-Match", valid_594179
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594180: Call_TagDetachFromApi_594170; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Detach the tag from the Api.
  ## 
  let valid = call_594180.validator(path, query, header, formData, body)
  let scheme = call_594180.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594180.url(scheme.get, call_594180.host, call_594180.base,
                         call_594180.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594180, url, valid)

proc call*(call_594181: Call_TagDetachFromApi_594170; tagId: string;
          resourceGroupName: string; apiVersion: string; apiId: string;
          subscriptionId: string; serviceName: string): Recallable =
  ## tagDetachFromApi
  ## Detach the tag from the Api.
  ##   tagId: string (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
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
  var path_594182 = newJObject()
  var query_594183 = newJObject()
  add(path_594182, "tagId", newJString(tagId))
  add(path_594182, "resourceGroupName", newJString(resourceGroupName))
  add(query_594183, "api-version", newJString(apiVersion))
  add(path_594182, "apiId", newJString(apiId))
  add(path_594182, "subscriptionId", newJString(subscriptionId))
  add(path_594182, "serviceName", newJString(serviceName))
  result = call_594181.call(path_594182, query_594183, nil, nil, nil)

var tagDetachFromApi* = Call_TagDetachFromApi_594170(name: "tagDetachFromApi",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/tags/{tagId}",
    validator: validate_TagDetachFromApi_594171, base: "",
    url: url_TagDetachFromApi_594172, schemes: {Scheme.Https})
type
  Call_TagListByProduct_594197 = ref object of OpenApiRestCall_593425
proc url_TagListByProduct_594199(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "productId" in path, "`productId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/products/"),
               (kind: VariableSegment, value: "productId"),
               (kind: ConstantSegment, value: "/tags")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagListByProduct_594198(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Lists all Tags associated with the Product.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   productId: JString (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594200 = path.getOrDefault("resourceGroupName")
  valid_594200 = validateParameter(valid_594200, JString, required = true,
                                 default = nil)
  if valid_594200 != nil:
    section.add "resourceGroupName", valid_594200
  var valid_594201 = path.getOrDefault("subscriptionId")
  valid_594201 = validateParameter(valid_594201, JString, required = true,
                                 default = nil)
  if valid_594201 != nil:
    section.add "subscriptionId", valid_594201
  var valid_594202 = path.getOrDefault("productId")
  valid_594202 = validateParameter(valid_594202, JString, required = true,
                                 default = nil)
  if valid_594202 != nil:
    section.add "productId", valid_594202
  var valid_594203 = path.getOrDefault("serviceName")
  valid_594203 = validateParameter(valid_594203, JString, required = true,
                                 default = nil)
  if valid_594203 != nil:
    section.add "serviceName", valid_594203
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
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594204 = query.getOrDefault("api-version")
  valid_594204 = validateParameter(valid_594204, JString, required = true,
                                 default = nil)
  if valid_594204 != nil:
    section.add "api-version", valid_594204
  var valid_594205 = query.getOrDefault("$top")
  valid_594205 = validateParameter(valid_594205, JInt, required = false, default = nil)
  if valid_594205 != nil:
    section.add "$top", valid_594205
  var valid_594206 = query.getOrDefault("$skip")
  valid_594206 = validateParameter(valid_594206, JInt, required = false, default = nil)
  if valid_594206 != nil:
    section.add "$skip", valid_594206
  var valid_594207 = query.getOrDefault("$filter")
  valid_594207 = validateParameter(valid_594207, JString, required = false,
                                 default = nil)
  if valid_594207 != nil:
    section.add "$filter", valid_594207
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594208: Call_TagListByProduct_594197; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all Tags associated with the Product.
  ## 
  let valid = call_594208.validator(path, query, header, formData, body)
  let scheme = call_594208.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594208.url(scheme.get, call_594208.host, call_594208.base,
                         call_594208.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594208, url, valid)

proc call*(call_594209: Call_TagListByProduct_594197; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; productId: string;
          serviceName: string; Top: int = 0; Skip: int = 0; Filter: string = ""): Recallable =
  ## tagListByProduct
  ## Lists all Tags associated with the Product.
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
  ##   productId: string (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   Filter: string
  ##         : | Field       | Supported operators    | Supported functions                         |
  ## 
  ## |-------------|------------------------|---------------------------------------------|
  ## | id          | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | name        | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  var path_594210 = newJObject()
  var query_594211 = newJObject()
  add(path_594210, "resourceGroupName", newJString(resourceGroupName))
  add(query_594211, "api-version", newJString(apiVersion))
  add(path_594210, "subscriptionId", newJString(subscriptionId))
  add(query_594211, "$top", newJInt(Top))
  add(query_594211, "$skip", newJInt(Skip))
  add(path_594210, "productId", newJString(productId))
  add(path_594210, "serviceName", newJString(serviceName))
  add(query_594211, "$filter", newJString(Filter))
  result = call_594209.call(path_594210, query_594211, nil, nil, nil)

var tagListByProduct* = Call_TagListByProduct_594197(name: "tagListByProduct",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/tags",
    validator: validate_TagListByProduct_594198, base: "",
    url: url_TagListByProduct_594199, schemes: {Scheme.Https})
type
  Call_TagAssignToProduct_594225 = ref object of OpenApiRestCall_593425
proc url_TagAssignToProduct_594227(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "productId" in path, "`productId` is a required path parameter"
  assert "tagId" in path, "`tagId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/products/"),
               (kind: VariableSegment, value: "productId"),
               (kind: ConstantSegment, value: "/tags/"),
               (kind: VariableSegment, value: "tagId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagAssignToProduct_594226(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Assign tag to the Product.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tagId: JString (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   productId: JString (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tagId` field"
  var valid_594228 = path.getOrDefault("tagId")
  valid_594228 = validateParameter(valid_594228, JString, required = true,
                                 default = nil)
  if valid_594228 != nil:
    section.add "tagId", valid_594228
  var valid_594229 = path.getOrDefault("resourceGroupName")
  valid_594229 = validateParameter(valid_594229, JString, required = true,
                                 default = nil)
  if valid_594229 != nil:
    section.add "resourceGroupName", valid_594229
  var valid_594230 = path.getOrDefault("subscriptionId")
  valid_594230 = validateParameter(valid_594230, JString, required = true,
                                 default = nil)
  if valid_594230 != nil:
    section.add "subscriptionId", valid_594230
  var valid_594231 = path.getOrDefault("productId")
  valid_594231 = validateParameter(valid_594231, JString, required = true,
                                 default = nil)
  if valid_594231 != nil:
    section.add "productId", valid_594231
  var valid_594232 = path.getOrDefault("serviceName")
  valid_594232 = validateParameter(valid_594232, JString, required = true,
                                 default = nil)
  if valid_594232 != nil:
    section.add "serviceName", valid_594232
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594233 = query.getOrDefault("api-version")
  valid_594233 = validateParameter(valid_594233, JString, required = true,
                                 default = nil)
  if valid_594233 != nil:
    section.add "api-version", valid_594233
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : The entity state (Etag) version of the Tag to update. A value of "*" can be used for If-Match to unconditionally apply the operation.
  section = newJObject()
  var valid_594234 = header.getOrDefault("If-Match")
  valid_594234 = validateParameter(valid_594234, JString, required = false,
                                 default = nil)
  if valid_594234 != nil:
    section.add "If-Match", valid_594234
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594235: Call_TagAssignToProduct_594225; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Assign tag to the Product.
  ## 
  let valid = call_594235.validator(path, query, header, formData, body)
  let scheme = call_594235.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594235.url(scheme.get, call_594235.host, call_594235.base,
                         call_594235.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594235, url, valid)

proc call*(call_594236: Call_TagAssignToProduct_594225; tagId: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          productId: string; serviceName: string): Recallable =
  ## tagAssignToProduct
  ## Assign tag to the Product.
  ##   tagId: string (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   productId: string (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594237 = newJObject()
  var query_594238 = newJObject()
  add(path_594237, "tagId", newJString(tagId))
  add(path_594237, "resourceGroupName", newJString(resourceGroupName))
  add(query_594238, "api-version", newJString(apiVersion))
  add(path_594237, "subscriptionId", newJString(subscriptionId))
  add(path_594237, "productId", newJString(productId))
  add(path_594237, "serviceName", newJString(serviceName))
  result = call_594236.call(path_594237, query_594238, nil, nil, nil)

var tagAssignToProduct* = Call_TagAssignToProduct_594225(
    name: "tagAssignToProduct", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/tags/{tagId}",
    validator: validate_TagAssignToProduct_594226, base: "",
    url: url_TagAssignToProduct_594227, schemes: {Scheme.Https})
type
  Call_TagGetEntityStateByProduct_594253 = ref object of OpenApiRestCall_593425
proc url_TagGetEntityStateByProduct_594255(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "productId" in path, "`productId` is a required path parameter"
  assert "tagId" in path, "`tagId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/products/"),
               (kind: VariableSegment, value: "productId"),
               (kind: ConstantSegment, value: "/tags/"),
               (kind: VariableSegment, value: "tagId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagGetEntityStateByProduct_594254(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the entity state version of the tag specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tagId: JString (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   productId: JString (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tagId` field"
  var valid_594256 = path.getOrDefault("tagId")
  valid_594256 = validateParameter(valid_594256, JString, required = true,
                                 default = nil)
  if valid_594256 != nil:
    section.add "tagId", valid_594256
  var valid_594257 = path.getOrDefault("resourceGroupName")
  valid_594257 = validateParameter(valid_594257, JString, required = true,
                                 default = nil)
  if valid_594257 != nil:
    section.add "resourceGroupName", valid_594257
  var valid_594258 = path.getOrDefault("subscriptionId")
  valid_594258 = validateParameter(valid_594258, JString, required = true,
                                 default = nil)
  if valid_594258 != nil:
    section.add "subscriptionId", valid_594258
  var valid_594259 = path.getOrDefault("productId")
  valid_594259 = validateParameter(valid_594259, JString, required = true,
                                 default = nil)
  if valid_594259 != nil:
    section.add "productId", valid_594259
  var valid_594260 = path.getOrDefault("serviceName")
  valid_594260 = validateParameter(valid_594260, JString, required = true,
                                 default = nil)
  if valid_594260 != nil:
    section.add "serviceName", valid_594260
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594261 = query.getOrDefault("api-version")
  valid_594261 = validateParameter(valid_594261, JString, required = true,
                                 default = nil)
  if valid_594261 != nil:
    section.add "api-version", valid_594261
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594262: Call_TagGetEntityStateByProduct_594253; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the entity state version of the tag specified by its identifier.
  ## 
  let valid = call_594262.validator(path, query, header, formData, body)
  let scheme = call_594262.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594262.url(scheme.get, call_594262.host, call_594262.base,
                         call_594262.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594262, url, valid)

proc call*(call_594263: Call_TagGetEntityStateByProduct_594253; tagId: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          productId: string; serviceName: string): Recallable =
  ## tagGetEntityStateByProduct
  ## Gets the entity state version of the tag specified by its identifier.
  ##   tagId: string (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   productId: string (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594264 = newJObject()
  var query_594265 = newJObject()
  add(path_594264, "tagId", newJString(tagId))
  add(path_594264, "resourceGroupName", newJString(resourceGroupName))
  add(query_594265, "api-version", newJString(apiVersion))
  add(path_594264, "subscriptionId", newJString(subscriptionId))
  add(path_594264, "productId", newJString(productId))
  add(path_594264, "serviceName", newJString(serviceName))
  result = call_594263.call(path_594264, query_594265, nil, nil, nil)

var tagGetEntityStateByProduct* = Call_TagGetEntityStateByProduct_594253(
    name: "tagGetEntityStateByProduct", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/tags/{tagId}",
    validator: validate_TagGetEntityStateByProduct_594254, base: "",
    url: url_TagGetEntityStateByProduct_594255, schemes: {Scheme.Https})
type
  Call_TagGetByProduct_594212 = ref object of OpenApiRestCall_593425
proc url_TagGetByProduct_594214(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "productId" in path, "`productId` is a required path parameter"
  assert "tagId" in path, "`tagId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/products/"),
               (kind: VariableSegment, value: "productId"),
               (kind: ConstantSegment, value: "/tags/"),
               (kind: VariableSegment, value: "tagId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagGetByProduct_594213(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Get tag associated with the Product.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tagId: JString (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   productId: JString (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tagId` field"
  var valid_594215 = path.getOrDefault("tagId")
  valid_594215 = validateParameter(valid_594215, JString, required = true,
                                 default = nil)
  if valid_594215 != nil:
    section.add "tagId", valid_594215
  var valid_594216 = path.getOrDefault("resourceGroupName")
  valid_594216 = validateParameter(valid_594216, JString, required = true,
                                 default = nil)
  if valid_594216 != nil:
    section.add "resourceGroupName", valid_594216
  var valid_594217 = path.getOrDefault("subscriptionId")
  valid_594217 = validateParameter(valid_594217, JString, required = true,
                                 default = nil)
  if valid_594217 != nil:
    section.add "subscriptionId", valid_594217
  var valid_594218 = path.getOrDefault("productId")
  valid_594218 = validateParameter(valid_594218, JString, required = true,
                                 default = nil)
  if valid_594218 != nil:
    section.add "productId", valid_594218
  var valid_594219 = path.getOrDefault("serviceName")
  valid_594219 = validateParameter(valid_594219, JString, required = true,
                                 default = nil)
  if valid_594219 != nil:
    section.add "serviceName", valid_594219
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594220 = query.getOrDefault("api-version")
  valid_594220 = validateParameter(valid_594220, JString, required = true,
                                 default = nil)
  if valid_594220 != nil:
    section.add "api-version", valid_594220
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594221: Call_TagGetByProduct_594212; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get tag associated with the Product.
  ## 
  let valid = call_594221.validator(path, query, header, formData, body)
  let scheme = call_594221.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594221.url(scheme.get, call_594221.host, call_594221.base,
                         call_594221.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594221, url, valid)

proc call*(call_594222: Call_TagGetByProduct_594212; tagId: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          productId: string; serviceName: string): Recallable =
  ## tagGetByProduct
  ## Get tag associated with the Product.
  ##   tagId: string (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   productId: string (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594223 = newJObject()
  var query_594224 = newJObject()
  add(path_594223, "tagId", newJString(tagId))
  add(path_594223, "resourceGroupName", newJString(resourceGroupName))
  add(query_594224, "api-version", newJString(apiVersion))
  add(path_594223, "subscriptionId", newJString(subscriptionId))
  add(path_594223, "productId", newJString(productId))
  add(path_594223, "serviceName", newJString(serviceName))
  result = call_594222.call(path_594223, query_594224, nil, nil, nil)

var tagGetByProduct* = Call_TagGetByProduct_594212(name: "tagGetByProduct",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/tags/{tagId}",
    validator: validate_TagGetByProduct_594213, base: "", url: url_TagGetByProduct_594214,
    schemes: {Scheme.Https})
type
  Call_TagDetachFromProduct_594239 = ref object of OpenApiRestCall_593425
proc url_TagDetachFromProduct_594241(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "productId" in path, "`productId` is a required path parameter"
  assert "tagId" in path, "`tagId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/products/"),
               (kind: VariableSegment, value: "productId"),
               (kind: ConstantSegment, value: "/tags/"),
               (kind: VariableSegment, value: "tagId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagDetachFromProduct_594240(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Detach the tag from the Product.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tagId: JString (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   productId: JString (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tagId` field"
  var valid_594242 = path.getOrDefault("tagId")
  valid_594242 = validateParameter(valid_594242, JString, required = true,
                                 default = nil)
  if valid_594242 != nil:
    section.add "tagId", valid_594242
  var valid_594243 = path.getOrDefault("resourceGroupName")
  valid_594243 = validateParameter(valid_594243, JString, required = true,
                                 default = nil)
  if valid_594243 != nil:
    section.add "resourceGroupName", valid_594243
  var valid_594244 = path.getOrDefault("subscriptionId")
  valid_594244 = validateParameter(valid_594244, JString, required = true,
                                 default = nil)
  if valid_594244 != nil:
    section.add "subscriptionId", valid_594244
  var valid_594245 = path.getOrDefault("productId")
  valid_594245 = validateParameter(valid_594245, JString, required = true,
                                 default = nil)
  if valid_594245 != nil:
    section.add "productId", valid_594245
  var valid_594246 = path.getOrDefault("serviceName")
  valid_594246 = validateParameter(valid_594246, JString, required = true,
                                 default = nil)
  if valid_594246 != nil:
    section.add "serviceName", valid_594246
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594247 = query.getOrDefault("api-version")
  valid_594247 = validateParameter(valid_594247, JString, required = true,
                                 default = nil)
  if valid_594247 != nil:
    section.add "api-version", valid_594247
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : The entity state (Etag) version of the Api schema to update. A value of "*" can be used for If-Match to unconditionally apply the operation.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_594248 = header.getOrDefault("If-Match")
  valid_594248 = validateParameter(valid_594248, JString, required = true,
                                 default = nil)
  if valid_594248 != nil:
    section.add "If-Match", valid_594248
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594249: Call_TagDetachFromProduct_594239; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Detach the tag from the Product.
  ## 
  let valid = call_594249.validator(path, query, header, formData, body)
  let scheme = call_594249.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594249.url(scheme.get, call_594249.host, call_594249.base,
                         call_594249.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594249, url, valid)

proc call*(call_594250: Call_TagDetachFromProduct_594239; tagId: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          productId: string; serviceName: string): Recallable =
  ## tagDetachFromProduct
  ## Detach the tag from the Product.
  ##   tagId: string (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   productId: string (required)
  ##            : Product identifier. Must be unique in the current API Management service instance.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594251 = newJObject()
  var query_594252 = newJObject()
  add(path_594251, "tagId", newJString(tagId))
  add(path_594251, "resourceGroupName", newJString(resourceGroupName))
  add(query_594252, "api-version", newJString(apiVersion))
  add(path_594251, "subscriptionId", newJString(subscriptionId))
  add(path_594251, "productId", newJString(productId))
  add(path_594251, "serviceName", newJString(serviceName))
  result = call_594250.call(path_594251, query_594252, nil, nil, nil)

var tagDetachFromProduct* = Call_TagDetachFromProduct_594239(
    name: "tagDetachFromProduct", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/products/{productId}/tags/{tagId}",
    validator: validate_TagDetachFromProduct_594240, base: "",
    url: url_TagDetachFromProduct_594241, schemes: {Scheme.Https})
type
  Call_TagListByService_594266 = ref object of OpenApiRestCall_593425
proc url_TagListByService_594268(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/tags")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagListByService_594267(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Lists a collection of tags defined within a service instance.
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
  var valid_594269 = path.getOrDefault("resourceGroupName")
  valid_594269 = validateParameter(valid_594269, JString, required = true,
                                 default = nil)
  if valid_594269 != nil:
    section.add "resourceGroupName", valid_594269
  var valid_594270 = path.getOrDefault("subscriptionId")
  valid_594270 = validateParameter(valid_594270, JString, required = true,
                                 default = nil)
  if valid_594270 != nil:
    section.add "subscriptionId", valid_594270
  var valid_594271 = path.getOrDefault("serviceName")
  valid_594271 = validateParameter(valid_594271, JString, required = true,
                                 default = nil)
  if valid_594271 != nil:
    section.add "serviceName", valid_594271
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
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594272 = query.getOrDefault("api-version")
  valid_594272 = validateParameter(valid_594272, JString, required = true,
                                 default = nil)
  if valid_594272 != nil:
    section.add "api-version", valid_594272
  var valid_594273 = query.getOrDefault("$top")
  valid_594273 = validateParameter(valid_594273, JInt, required = false, default = nil)
  if valid_594273 != nil:
    section.add "$top", valid_594273
  var valid_594274 = query.getOrDefault("$skip")
  valid_594274 = validateParameter(valid_594274, JInt, required = false, default = nil)
  if valid_594274 != nil:
    section.add "$skip", valid_594274
  var valid_594275 = query.getOrDefault("$filter")
  valid_594275 = validateParameter(valid_594275, JString, required = false,
                                 default = nil)
  if valid_594275 != nil:
    section.add "$filter", valid_594275
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594276: Call_TagListByService_594266; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a collection of tags defined within a service instance.
  ## 
  let valid = call_594276.validator(path, query, header, formData, body)
  let scheme = call_594276.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594276.url(scheme.get, call_594276.host, call_594276.base,
                         call_594276.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594276, url, valid)

proc call*(call_594277: Call_TagListByService_594266; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; serviceName: string;
          Top: int = 0; Skip: int = 0; Filter: string = ""): Recallable =
  ## tagListByService
  ## Lists a collection of tags defined within a service instance.
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
  var path_594278 = newJObject()
  var query_594279 = newJObject()
  add(path_594278, "resourceGroupName", newJString(resourceGroupName))
  add(query_594279, "api-version", newJString(apiVersion))
  add(path_594278, "subscriptionId", newJString(subscriptionId))
  add(query_594279, "$top", newJInt(Top))
  add(query_594279, "$skip", newJInt(Skip))
  add(path_594278, "serviceName", newJString(serviceName))
  add(query_594279, "$filter", newJString(Filter))
  result = call_594277.call(path_594278, query_594279, nil, nil, nil)

var tagListByService* = Call_TagListByService_594266(name: "tagListByService",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tags",
    validator: validate_TagListByService_594267, base: "",
    url: url_TagListByService_594268, schemes: {Scheme.Https})
type
  Call_TagCreateOrUpdate_594292 = ref object of OpenApiRestCall_593425
proc url_TagCreateOrUpdate_594294(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "tagId" in path, "`tagId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/tags/"),
               (kind: VariableSegment, value: "tagId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagCreateOrUpdate_594293(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Creates a tag.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tagId: JString (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tagId` field"
  var valid_594295 = path.getOrDefault("tagId")
  valid_594295 = validateParameter(valid_594295, JString, required = true,
                                 default = nil)
  if valid_594295 != nil:
    section.add "tagId", valid_594295
  var valid_594296 = path.getOrDefault("resourceGroupName")
  valid_594296 = validateParameter(valid_594296, JString, required = true,
                                 default = nil)
  if valid_594296 != nil:
    section.add "resourceGroupName", valid_594296
  var valid_594297 = path.getOrDefault("subscriptionId")
  valid_594297 = validateParameter(valid_594297, JString, required = true,
                                 default = nil)
  if valid_594297 != nil:
    section.add "subscriptionId", valid_594297
  var valid_594298 = path.getOrDefault("serviceName")
  valid_594298 = validateParameter(valid_594298, JString, required = true,
                                 default = nil)
  if valid_594298 != nil:
    section.add "serviceName", valid_594298
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594299 = query.getOrDefault("api-version")
  valid_594299 = validateParameter(valid_594299, JString, required = true,
                                 default = nil)
  if valid_594299 != nil:
    section.add "api-version", valid_594299
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

proc call*(call_594301: Call_TagCreateOrUpdate_594292; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a tag.
  ## 
  let valid = call_594301.validator(path, query, header, formData, body)
  let scheme = call_594301.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594301.url(scheme.get, call_594301.host, call_594301.base,
                         call_594301.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594301, url, valid)

proc call*(call_594302: Call_TagCreateOrUpdate_594292; tagId: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; serviceName: string): Recallable =
  ## tagCreateOrUpdate
  ## Creates a tag.
  ##   tagId: string (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Create parameters.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594303 = newJObject()
  var query_594304 = newJObject()
  var body_594305 = newJObject()
  add(path_594303, "tagId", newJString(tagId))
  add(path_594303, "resourceGroupName", newJString(resourceGroupName))
  add(query_594304, "api-version", newJString(apiVersion))
  add(path_594303, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594305 = parameters
  add(path_594303, "serviceName", newJString(serviceName))
  result = call_594302.call(path_594303, query_594304, nil, nil, body_594305)

var tagCreateOrUpdate* = Call_TagCreateOrUpdate_594292(name: "tagCreateOrUpdate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tags/{tagId}",
    validator: validate_TagCreateOrUpdate_594293, base: "",
    url: url_TagCreateOrUpdate_594294, schemes: {Scheme.Https})
type
  Call_TagGetEntityState_594319 = ref object of OpenApiRestCall_593425
proc url_TagGetEntityState_594321(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "tagId" in path, "`tagId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/tags/"),
               (kind: VariableSegment, value: "tagId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagGetEntityState_594320(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets the entity state version of the tag specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tagId: JString (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tagId` field"
  var valid_594322 = path.getOrDefault("tagId")
  valid_594322 = validateParameter(valid_594322, JString, required = true,
                                 default = nil)
  if valid_594322 != nil:
    section.add "tagId", valid_594322
  var valid_594323 = path.getOrDefault("resourceGroupName")
  valid_594323 = validateParameter(valid_594323, JString, required = true,
                                 default = nil)
  if valid_594323 != nil:
    section.add "resourceGroupName", valid_594323
  var valid_594324 = path.getOrDefault("subscriptionId")
  valid_594324 = validateParameter(valid_594324, JString, required = true,
                                 default = nil)
  if valid_594324 != nil:
    section.add "subscriptionId", valid_594324
  var valid_594325 = path.getOrDefault("serviceName")
  valid_594325 = validateParameter(valid_594325, JString, required = true,
                                 default = nil)
  if valid_594325 != nil:
    section.add "serviceName", valid_594325
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594326 = query.getOrDefault("api-version")
  valid_594326 = validateParameter(valid_594326, JString, required = true,
                                 default = nil)
  if valid_594326 != nil:
    section.add "api-version", valid_594326
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594327: Call_TagGetEntityState_594319; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the entity state version of the tag specified by its identifier.
  ## 
  let valid = call_594327.validator(path, query, header, formData, body)
  let scheme = call_594327.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594327.url(scheme.get, call_594327.host, call_594327.base,
                         call_594327.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594327, url, valid)

proc call*(call_594328: Call_TagGetEntityState_594319; tagId: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          serviceName: string): Recallable =
  ## tagGetEntityState
  ## Gets the entity state version of the tag specified by its identifier.
  ##   tagId: string (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594329 = newJObject()
  var query_594330 = newJObject()
  add(path_594329, "tagId", newJString(tagId))
  add(path_594329, "resourceGroupName", newJString(resourceGroupName))
  add(query_594330, "api-version", newJString(apiVersion))
  add(path_594329, "subscriptionId", newJString(subscriptionId))
  add(path_594329, "serviceName", newJString(serviceName))
  result = call_594328.call(path_594329, query_594330, nil, nil, nil)

var tagGetEntityState* = Call_TagGetEntityState_594319(name: "tagGetEntityState",
    meth: HttpMethod.HttpHead, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tags/{tagId}",
    validator: validate_TagGetEntityState_594320, base: "",
    url: url_TagGetEntityState_594321, schemes: {Scheme.Https})
type
  Call_TagGet_594280 = ref object of OpenApiRestCall_593425
proc url_TagGet_594282(protocol: Scheme; host: string; base: string; route: string;
                      path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "tagId" in path, "`tagId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/tags/"),
               (kind: VariableSegment, value: "tagId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagGet_594281(path: JsonNode; query: JsonNode; header: JsonNode;
                           formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of the tag specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tagId: JString (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tagId` field"
  var valid_594283 = path.getOrDefault("tagId")
  valid_594283 = validateParameter(valid_594283, JString, required = true,
                                 default = nil)
  if valid_594283 != nil:
    section.add "tagId", valid_594283
  var valid_594284 = path.getOrDefault("resourceGroupName")
  valid_594284 = validateParameter(valid_594284, JString, required = true,
                                 default = nil)
  if valid_594284 != nil:
    section.add "resourceGroupName", valid_594284
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
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594287 = query.getOrDefault("api-version")
  valid_594287 = validateParameter(valid_594287, JString, required = true,
                                 default = nil)
  if valid_594287 != nil:
    section.add "api-version", valid_594287
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594288: Call_TagGet_594280; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the tag specified by its identifier.
  ## 
  let valid = call_594288.validator(path, query, header, formData, body)
  let scheme = call_594288.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594288.url(scheme.get, call_594288.host, call_594288.base,
                         call_594288.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594288, url, valid)

proc call*(call_594289: Call_TagGet_594280; tagId: string; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; serviceName: string): Recallable =
  ## tagGet
  ## Gets the details of the tag specified by its identifier.
  ##   tagId: string (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594290 = newJObject()
  var query_594291 = newJObject()
  add(path_594290, "tagId", newJString(tagId))
  add(path_594290, "resourceGroupName", newJString(resourceGroupName))
  add(query_594291, "api-version", newJString(apiVersion))
  add(path_594290, "subscriptionId", newJString(subscriptionId))
  add(path_594290, "serviceName", newJString(serviceName))
  result = call_594289.call(path_594290, query_594291, nil, nil, nil)

var tagGet* = Call_TagGet_594280(name: "tagGet", meth: HttpMethod.HttpGet,
                              host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tags/{tagId}",
                              validator: validate_TagGet_594281, base: "",
                              url: url_TagGet_594282, schemes: {Scheme.Https})
type
  Call_TagUpdate_594331 = ref object of OpenApiRestCall_593425
proc url_TagUpdate_594333(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "tagId" in path, "`tagId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/tags/"),
               (kind: VariableSegment, value: "tagId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagUpdate_594332(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the details of the tag specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tagId: JString (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tagId` field"
  var valid_594334 = path.getOrDefault("tagId")
  valid_594334 = validateParameter(valid_594334, JString, required = true,
                                 default = nil)
  if valid_594334 != nil:
    section.add "tagId", valid_594334
  var valid_594335 = path.getOrDefault("resourceGroupName")
  valid_594335 = validateParameter(valid_594335, JString, required = true,
                                 default = nil)
  if valid_594335 != nil:
    section.add "resourceGroupName", valid_594335
  var valid_594336 = path.getOrDefault("subscriptionId")
  valid_594336 = validateParameter(valid_594336, JString, required = true,
                                 default = nil)
  if valid_594336 != nil:
    section.add "subscriptionId", valid_594336
  var valid_594337 = path.getOrDefault("serviceName")
  valid_594337 = validateParameter(valid_594337, JString, required = true,
                                 default = nil)
  if valid_594337 != nil:
    section.add "serviceName", valid_594337
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594338 = query.getOrDefault("api-version")
  valid_594338 = validateParameter(valid_594338, JString, required = true,
                                 default = nil)
  if valid_594338 != nil:
    section.add "api-version", valid_594338
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Tag Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_594339 = header.getOrDefault("If-Match")
  valid_594339 = validateParameter(valid_594339, JString, required = true,
                                 default = nil)
  if valid_594339 != nil:
    section.add "If-Match", valid_594339
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

proc call*(call_594341: Call_TagUpdate_594331; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the details of the tag specified by its identifier.
  ## 
  let valid = call_594341.validator(path, query, header, formData, body)
  let scheme = call_594341.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594341.url(scheme.get, call_594341.host, call_594341.base,
                         call_594341.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594341, url, valid)

proc call*(call_594342: Call_TagUpdate_594331; tagId: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; serviceName: string): Recallable =
  ## tagUpdate
  ## Updates the details of the tag specified by its identifier.
  ##   tagId: string (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Update parameters.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594343 = newJObject()
  var query_594344 = newJObject()
  var body_594345 = newJObject()
  add(path_594343, "tagId", newJString(tagId))
  add(path_594343, "resourceGroupName", newJString(resourceGroupName))
  add(query_594344, "api-version", newJString(apiVersion))
  add(path_594343, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594345 = parameters
  add(path_594343, "serviceName", newJString(serviceName))
  result = call_594342.call(path_594343, query_594344, nil, nil, body_594345)

var tagUpdate* = Call_TagUpdate_594331(name: "tagUpdate", meth: HttpMethod.HttpPatch,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tags/{tagId}",
                                    validator: validate_TagUpdate_594332,
                                    base: "", url: url_TagUpdate_594333,
                                    schemes: {Scheme.Https})
type
  Call_TagDelete_594306 = ref object of OpenApiRestCall_593425
proc url_TagDelete_594308(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "tagId" in path, "`tagId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/tags/"),
               (kind: VariableSegment, value: "tagId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagDelete_594307(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes specific tag of the API Management service instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tagId: JString (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tagId` field"
  var valid_594309 = path.getOrDefault("tagId")
  valid_594309 = validateParameter(valid_594309, JString, required = true,
                                 default = nil)
  if valid_594309 != nil:
    section.add "tagId", valid_594309
  var valid_594310 = path.getOrDefault("resourceGroupName")
  valid_594310 = validateParameter(valid_594310, JString, required = true,
                                 default = nil)
  if valid_594310 != nil:
    section.add "resourceGroupName", valid_594310
  var valid_594311 = path.getOrDefault("subscriptionId")
  valid_594311 = validateParameter(valid_594311, JString, required = true,
                                 default = nil)
  if valid_594311 != nil:
    section.add "subscriptionId", valid_594311
  var valid_594312 = path.getOrDefault("serviceName")
  valid_594312 = validateParameter(valid_594312, JString, required = true,
                                 default = nil)
  if valid_594312 != nil:
    section.add "serviceName", valid_594312
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594313 = query.getOrDefault("api-version")
  valid_594313 = validateParameter(valid_594313, JString, required = true,
                                 default = nil)
  if valid_594313 != nil:
    section.add "api-version", valid_594313
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Tag Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_594314 = header.getOrDefault("If-Match")
  valid_594314 = validateParameter(valid_594314, JString, required = true,
                                 default = nil)
  if valid_594314 != nil:
    section.add "If-Match", valid_594314
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594315: Call_TagDelete_594306; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes specific tag of the API Management service instance.
  ## 
  let valid = call_594315.validator(path, query, header, formData, body)
  let scheme = call_594315.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594315.url(scheme.get, call_594315.host, call_594315.base,
                         call_594315.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594315, url, valid)

proc call*(call_594316: Call_TagDelete_594306; tagId: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          serviceName: string): Recallable =
  ## tagDelete
  ## Deletes specific tag of the API Management service instance.
  ##   tagId: string (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594317 = newJObject()
  var query_594318 = newJObject()
  add(path_594317, "tagId", newJString(tagId))
  add(path_594317, "resourceGroupName", newJString(resourceGroupName))
  add(query_594318, "api-version", newJString(apiVersion))
  add(path_594317, "subscriptionId", newJString(subscriptionId))
  add(path_594317, "serviceName", newJString(serviceName))
  result = call_594316.call(path_594317, query_594318, nil, nil, nil)

var tagDelete* = Call_TagDelete_594306(name: "tagDelete",
                                    meth: HttpMethod.HttpDelete,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tags/{tagId}",
                                    validator: validate_TagDelete_594307,
                                    base: "", url: url_TagDelete_594308,
                                    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
