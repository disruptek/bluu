
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: ApiManagementClient
## version: 2018-06-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## Use these REST APIs for performing operations on Global Policies in Azure API Management deployment.
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
  macServiceName = "apimanagement-apimpolicies"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_PolicyListByService_593646 = ref object of OpenApiRestCall_593424
proc url_PolicyListByService_593648(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/policies")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyListByService_593647(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Lists all the Global Policy definitions of the Api Management service.
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
  var valid_593808 = path.getOrDefault("resourceGroupName")
  valid_593808 = validateParameter(valid_593808, JString, required = true,
                                 default = nil)
  if valid_593808 != nil:
    section.add "resourceGroupName", valid_593808
  var valid_593809 = path.getOrDefault("subscriptionId")
  valid_593809 = validateParameter(valid_593809, JString, required = true,
                                 default = nil)
  if valid_593809 != nil:
    section.add "subscriptionId", valid_593809
  var valid_593810 = path.getOrDefault("serviceName")
  valid_593810 = validateParameter(valid_593810, JString, required = true,
                                 default = nil)
  if valid_593810 != nil:
    section.add "serviceName", valid_593810
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593811 = query.getOrDefault("api-version")
  valid_593811 = validateParameter(valid_593811, JString, required = true,
                                 default = nil)
  if valid_593811 != nil:
    section.add "api-version", valid_593811
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593838: Call_PolicyListByService_593646; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the Global Policy definitions of the Api Management service.
  ## 
  let valid = call_593838.validator(path, query, header, formData, body)
  let scheme = call_593838.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593838.url(scheme.get, call_593838.host, call_593838.base,
                         call_593838.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593838, url, valid)

proc call*(call_593909: Call_PolicyListByService_593646; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; serviceName: string): Recallable =
  ## policyListByService
  ## Lists all the Global Policy definitions of the Api Management service.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_593910 = newJObject()
  var query_593912 = newJObject()
  add(path_593910, "resourceGroupName", newJString(resourceGroupName))
  add(query_593912, "api-version", newJString(apiVersion))
  add(path_593910, "subscriptionId", newJString(subscriptionId))
  add(path_593910, "serviceName", newJString(serviceName))
  result = call_593909.call(path_593910, query_593912, nil, nil, nil)

var policyListByService* = Call_PolicyListByService_593646(
    name: "policyListByService", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/policies",
    validator: validate_PolicyListByService_593647, base: "",
    url: url_PolicyListByService_593648, schemes: {Scheme.Https})
type
  Call_PolicyCreateOrUpdate_593976 = ref object of OpenApiRestCall_593424
proc url_PolicyCreateOrUpdate_593978(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "policyId" in path, "`policyId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/policies/"),
               (kind: VariableSegment, value: "policyId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyCreateOrUpdate_593977(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates the global policy configuration of the Api Management service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   policyId: JString (required)
  ##           : The identifier of the Policy.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593996 = path.getOrDefault("resourceGroupName")
  valid_593996 = validateParameter(valid_593996, JString, required = true,
                                 default = nil)
  if valid_593996 != nil:
    section.add "resourceGroupName", valid_593996
  var valid_593997 = path.getOrDefault("subscriptionId")
  valid_593997 = validateParameter(valid_593997, JString, required = true,
                                 default = nil)
  if valid_593997 != nil:
    section.add "subscriptionId", valid_593997
  var valid_593998 = path.getOrDefault("policyId")
  valid_593998 = validateParameter(valid_593998, JString, required = true,
                                 default = newJString("policy"))
  if valid_593998 != nil:
    section.add "policyId", valid_593998
  var valid_593999 = path.getOrDefault("serviceName")
  valid_593999 = validateParameter(valid_593999, JString, required = true,
                                 default = nil)
  if valid_593999 != nil:
    section.add "serviceName", valid_593999
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594000 = query.getOrDefault("api-version")
  valid_594000 = validateParameter(valid_594000, JString, required = true,
                                 default = nil)
  if valid_594000 != nil:
    section.add "api-version", valid_594000
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the Entity. Not required when creating an entity, but required when updating an entity.
  section = newJObject()
  var valid_594001 = header.getOrDefault("If-Match")
  valid_594001 = validateParameter(valid_594001, JString, required = false,
                                 default = nil)
  if valid_594001 != nil:
    section.add "If-Match", valid_594001
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

proc call*(call_594003: Call_PolicyCreateOrUpdate_593976; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates the global policy configuration of the Api Management service.
  ## 
  let valid = call_594003.validator(path, query, header, formData, body)
  let scheme = call_594003.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594003.url(scheme.get, call_594003.host, call_594003.base,
                         call_594003.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594003, url, valid)

proc call*(call_594004: Call_PolicyCreateOrUpdate_593976;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; serviceName: string; policyId: string = "policy"): Recallable =
  ## policyCreateOrUpdate
  ## Creates or updates the global policy configuration of the Api Management service.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   policyId: string (required)
  ##           : The identifier of the Policy.
  ##   parameters: JObject (required)
  ##             : The policy contents to apply.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594005 = newJObject()
  var query_594006 = newJObject()
  var body_594007 = newJObject()
  add(path_594005, "resourceGroupName", newJString(resourceGroupName))
  add(query_594006, "api-version", newJString(apiVersion))
  add(path_594005, "subscriptionId", newJString(subscriptionId))
  add(path_594005, "policyId", newJString(policyId))
  if parameters != nil:
    body_594007 = parameters
  add(path_594005, "serviceName", newJString(serviceName))
  result = call_594004.call(path_594005, query_594006, nil, nil, body_594007)

var policyCreateOrUpdate* = Call_PolicyCreateOrUpdate_593976(
    name: "policyCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/policies/{policyId}",
    validator: validate_PolicyCreateOrUpdate_593977, base: "",
    url: url_PolicyCreateOrUpdate_593978, schemes: {Scheme.Https})
type
  Call_PolicyGetEntityTag_594021 = ref object of OpenApiRestCall_593424
proc url_PolicyGetEntityTag_594023(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "policyId" in path, "`policyId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/policies/"),
               (kind: VariableSegment, value: "policyId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyGetEntityTag_594022(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets the entity state (Etag) version of the Global policy definition in the Api Management service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   policyId: JString (required)
  ##           : The identifier of the Policy.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594024 = path.getOrDefault("resourceGroupName")
  valid_594024 = validateParameter(valid_594024, JString, required = true,
                                 default = nil)
  if valid_594024 != nil:
    section.add "resourceGroupName", valid_594024
  var valid_594025 = path.getOrDefault("subscriptionId")
  valid_594025 = validateParameter(valid_594025, JString, required = true,
                                 default = nil)
  if valid_594025 != nil:
    section.add "subscriptionId", valid_594025
  var valid_594026 = path.getOrDefault("policyId")
  valid_594026 = validateParameter(valid_594026, JString, required = true,
                                 default = newJString("policy"))
  if valid_594026 != nil:
    section.add "policyId", valid_594026
  var valid_594027 = path.getOrDefault("serviceName")
  valid_594027 = validateParameter(valid_594027, JString, required = true,
                                 default = nil)
  if valid_594027 != nil:
    section.add "serviceName", valid_594027
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594028 = query.getOrDefault("api-version")
  valid_594028 = validateParameter(valid_594028, JString, required = true,
                                 default = nil)
  if valid_594028 != nil:
    section.add "api-version", valid_594028
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594029: Call_PolicyGetEntityTag_594021; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the entity state (Etag) version of the Global policy definition in the Api Management service.
  ## 
  let valid = call_594029.validator(path, query, header, formData, body)
  let scheme = call_594029.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594029.url(scheme.get, call_594029.host, call_594029.base,
                         call_594029.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594029, url, valid)

proc call*(call_594030: Call_PolicyGetEntityTag_594021; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; serviceName: string;
          policyId: string = "policy"): Recallable =
  ## policyGetEntityTag
  ## Gets the entity state (Etag) version of the Global policy definition in the Api Management service.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   policyId: string (required)
  ##           : The identifier of the Policy.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594031 = newJObject()
  var query_594032 = newJObject()
  add(path_594031, "resourceGroupName", newJString(resourceGroupName))
  add(query_594032, "api-version", newJString(apiVersion))
  add(path_594031, "subscriptionId", newJString(subscriptionId))
  add(path_594031, "policyId", newJString(policyId))
  add(path_594031, "serviceName", newJString(serviceName))
  result = call_594030.call(path_594031, query_594032, nil, nil, nil)

var policyGetEntityTag* = Call_PolicyGetEntityTag_594021(
    name: "policyGetEntityTag", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/policies/{policyId}",
    validator: validate_PolicyGetEntityTag_594022, base: "",
    url: url_PolicyGetEntityTag_594023, schemes: {Scheme.Https})
type
  Call_PolicyGet_593951 = ref object of OpenApiRestCall_593424
proc url_PolicyGet_593953(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "policyId" in path, "`policyId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/policies/"),
               (kind: VariableSegment, value: "policyId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyGet_593952(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the Global policy definition of the Api Management service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   policyId: JString (required)
  ##           : The identifier of the Policy.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593954 = path.getOrDefault("resourceGroupName")
  valid_593954 = validateParameter(valid_593954, JString, required = true,
                                 default = nil)
  if valid_593954 != nil:
    section.add "resourceGroupName", valid_593954
  var valid_593955 = path.getOrDefault("subscriptionId")
  valid_593955 = validateParameter(valid_593955, JString, required = true,
                                 default = nil)
  if valid_593955 != nil:
    section.add "subscriptionId", valid_593955
  var valid_593969 = path.getOrDefault("policyId")
  valid_593969 = validateParameter(valid_593969, JString, required = true,
                                 default = newJString("policy"))
  if valid_593969 != nil:
    section.add "policyId", valid_593969
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

proc call*(call_593972: Call_PolicyGet_593951; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the Global policy definition of the Api Management service.
  ## 
  let valid = call_593972.validator(path, query, header, formData, body)
  let scheme = call_593972.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593972.url(scheme.get, call_593972.host, call_593972.base,
                         call_593972.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593972, url, valid)

proc call*(call_593973: Call_PolicyGet_593951; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; serviceName: string;
          policyId: string = "policy"): Recallable =
  ## policyGet
  ## Get the Global policy definition of the Api Management service.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   policyId: string (required)
  ##           : The identifier of the Policy.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_593974 = newJObject()
  var query_593975 = newJObject()
  add(path_593974, "resourceGroupName", newJString(resourceGroupName))
  add(query_593975, "api-version", newJString(apiVersion))
  add(path_593974, "subscriptionId", newJString(subscriptionId))
  add(path_593974, "policyId", newJString(policyId))
  add(path_593974, "serviceName", newJString(serviceName))
  result = call_593973.call(path_593974, query_593975, nil, nil, nil)

var policyGet* = Call_PolicyGet_593951(name: "policyGet", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/policies/{policyId}",
                                    validator: validate_PolicyGet_593952,
                                    base: "", url: url_PolicyGet_593953,
                                    schemes: {Scheme.Https})
type
  Call_PolicyDelete_594008 = ref object of OpenApiRestCall_593424
proc url_PolicyDelete_594010(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "policyId" in path, "`policyId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/policies/"),
               (kind: VariableSegment, value: "policyId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyDelete_594009(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the global policy configuration of the Api Management Service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   policyId: JString (required)
  ##           : The identifier of the Policy.
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
  var valid_594012 = path.getOrDefault("subscriptionId")
  valid_594012 = validateParameter(valid_594012, JString, required = true,
                                 default = nil)
  if valid_594012 != nil:
    section.add "subscriptionId", valid_594012
  var valid_594013 = path.getOrDefault("policyId")
  valid_594013 = validateParameter(valid_594013, JString, required = true,
                                 default = newJString("policy"))
  if valid_594013 != nil:
    section.add "policyId", valid_594013
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
  ##   If-Match: JString (required)
  ##           : ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_594016 = header.getOrDefault("If-Match")
  valid_594016 = validateParameter(valid_594016, JString, required = true,
                                 default = nil)
  if valid_594016 != nil:
    section.add "If-Match", valid_594016
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594017: Call_PolicyDelete_594008; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the global policy configuration of the Api Management Service.
  ## 
  let valid = call_594017.validator(path, query, header, formData, body)
  let scheme = call_594017.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594017.url(scheme.get, call_594017.host, call_594017.base,
                         call_594017.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594017, url, valid)

proc call*(call_594018: Call_PolicyDelete_594008; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; serviceName: string;
          policyId: string = "policy"): Recallable =
  ## policyDelete
  ## Deletes the global policy configuration of the Api Management Service.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   policyId: string (required)
  ##           : The identifier of the Policy.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594019 = newJObject()
  var query_594020 = newJObject()
  add(path_594019, "resourceGroupName", newJString(resourceGroupName))
  add(query_594020, "api-version", newJString(apiVersion))
  add(path_594019, "subscriptionId", newJString(subscriptionId))
  add(path_594019, "policyId", newJString(policyId))
  add(path_594019, "serviceName", newJString(serviceName))
  result = call_594018.call(path_594019, query_594020, nil, nil, nil)

var policyDelete* = Call_PolicyDelete_594008(name: "policyDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/policies/{policyId}",
    validator: validate_PolicyDelete_594009, base: "", url: url_PolicyDelete_594010,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
