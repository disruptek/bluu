
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: ApiManagementClient
## version: 2017-03-01
## termsOfService: (not provided)
## license: (not provided)
## 
## Use these REST APIs for performing operations on Identity Provider entity associated with your Azure API Management deployment. Setting up an external Identity Provider for authentication can help you manage the developer portal logins using the OAuth2 flow.
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
  macServiceName = "apimanagement-apimidentityprovider"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_IdentityProviderListByService_593646 = ref object of OpenApiRestCall_593424
proc url_IdentityProviderListByService_593648(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/identityProviders")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IdentityProviderListByService_593647(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists a collection of Identity Provider configured in the specified service instance.
  ## 
  ## https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-aad#how-to-authorize-developer-accounts-using-azure-active-directory
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

proc call*(call_593838: Call_IdentityProviderListByService_593646; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a collection of Identity Provider configured in the specified service instance.
  ## 
  ## https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-aad#how-to-authorize-developer-accounts-using-azure-active-directory
  let valid = call_593838.validator(path, query, header, formData, body)
  let scheme = call_593838.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593838.url(scheme.get, call_593838.host, call_593838.base,
                         call_593838.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593838, url, valid)

proc call*(call_593909: Call_IdentityProviderListByService_593646;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          serviceName: string): Recallable =
  ## identityProviderListByService
  ## Lists a collection of Identity Provider configured in the specified service instance.
  ## https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-aad#how-to-authorize-developer-accounts-using-azure-active-directory
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

var identityProviderListByService* = Call_IdentityProviderListByService_593646(
    name: "identityProviderListByService", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/identityProviders",
    validator: validate_IdentityProviderListByService_593647, base: "",
    url: url_IdentityProviderListByService_593648, schemes: {Scheme.Https})
type
  Call_IdentityProviderCreateOrUpdate_593985 = ref object of OpenApiRestCall_593424
proc url_IdentityProviderCreateOrUpdate_593987(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "identityProviderName" in path,
        "`identityProviderName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/identityProviders/"),
               (kind: VariableSegment, value: "identityProviderName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IdentityProviderCreateOrUpdate_593986(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or Updates the IdentityProvider configuration.
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
  ##   identityProviderName: JString (required)
  ##                       : Identity Provider Type identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594005 = path.getOrDefault("resourceGroupName")
  valid_594005 = validateParameter(valid_594005, JString, required = true,
                                 default = nil)
  if valid_594005 != nil:
    section.add "resourceGroupName", valid_594005
  var valid_594006 = path.getOrDefault("subscriptionId")
  valid_594006 = validateParameter(valid_594006, JString, required = true,
                                 default = nil)
  if valid_594006 != nil:
    section.add "subscriptionId", valid_594006
  var valid_594007 = path.getOrDefault("serviceName")
  valid_594007 = validateParameter(valid_594007, JString, required = true,
                                 default = nil)
  if valid_594007 != nil:
    section.add "serviceName", valid_594007
  var valid_594008 = path.getOrDefault("identityProviderName")
  valid_594008 = validateParameter(valid_594008, JString, required = true,
                                 default = newJString("facebook"))
  if valid_594008 != nil:
    section.add "identityProviderName", valid_594008
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594009 = query.getOrDefault("api-version")
  valid_594009 = validateParameter(valid_594009, JString, required = true,
                                 default = nil)
  if valid_594009 != nil:
    section.add "api-version", valid_594009
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

proc call*(call_594011: Call_IdentityProviderCreateOrUpdate_593985; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or Updates the IdentityProvider configuration.
  ## 
  let valid = call_594011.validator(path, query, header, formData, body)
  let scheme = call_594011.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594011.url(scheme.get, call_594011.host, call_594011.base,
                         call_594011.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594011, url, valid)

proc call*(call_594012: Call_IdentityProviderCreateOrUpdate_593985;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; serviceName: string;
          identityProviderName: string = "facebook"): Recallable =
  ## identityProviderCreateOrUpdate
  ## Creates or Updates the IdentityProvider configuration.
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
  ##   identityProviderName: string (required)
  ##                       : Identity Provider Type identifier.
  var path_594013 = newJObject()
  var query_594014 = newJObject()
  var body_594015 = newJObject()
  add(path_594013, "resourceGroupName", newJString(resourceGroupName))
  add(query_594014, "api-version", newJString(apiVersion))
  add(path_594013, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594015 = parameters
  add(path_594013, "serviceName", newJString(serviceName))
  add(path_594013, "identityProviderName", newJString(identityProviderName))
  result = call_594012.call(path_594013, query_594014, nil, nil, body_594015)

var identityProviderCreateOrUpdate* = Call_IdentityProviderCreateOrUpdate_593985(
    name: "identityProviderCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/identityProviders/{identityProviderName}",
    validator: validate_IdentityProviderCreateOrUpdate_593986, base: "",
    url: url_IdentityProviderCreateOrUpdate_593987, schemes: {Scheme.Https})
type
  Call_IdentityProviderGetEntityTag_594029 = ref object of OpenApiRestCall_593424
proc url_IdentityProviderGetEntityTag_594031(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "identityProviderName" in path,
        "`identityProviderName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/identityProviders/"),
               (kind: VariableSegment, value: "identityProviderName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IdentityProviderGetEntityTag_594030(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the entity state (Etag) version of the identityProvider specified by its identifier.
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
  ##   identityProviderName: JString (required)
  ##                       : Identity Provider Type identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594032 = path.getOrDefault("resourceGroupName")
  valid_594032 = validateParameter(valid_594032, JString, required = true,
                                 default = nil)
  if valid_594032 != nil:
    section.add "resourceGroupName", valid_594032
  var valid_594033 = path.getOrDefault("subscriptionId")
  valid_594033 = validateParameter(valid_594033, JString, required = true,
                                 default = nil)
  if valid_594033 != nil:
    section.add "subscriptionId", valid_594033
  var valid_594034 = path.getOrDefault("serviceName")
  valid_594034 = validateParameter(valid_594034, JString, required = true,
                                 default = nil)
  if valid_594034 != nil:
    section.add "serviceName", valid_594034
  var valid_594035 = path.getOrDefault("identityProviderName")
  valid_594035 = validateParameter(valid_594035, JString, required = true,
                                 default = newJString("facebook"))
  if valid_594035 != nil:
    section.add "identityProviderName", valid_594035
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594036 = query.getOrDefault("api-version")
  valid_594036 = validateParameter(valid_594036, JString, required = true,
                                 default = nil)
  if valid_594036 != nil:
    section.add "api-version", valid_594036
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594037: Call_IdentityProviderGetEntityTag_594029; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the entity state (Etag) version of the identityProvider specified by its identifier.
  ## 
  let valid = call_594037.validator(path, query, header, formData, body)
  let scheme = call_594037.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594037.url(scheme.get, call_594037.host, call_594037.base,
                         call_594037.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594037, url, valid)

proc call*(call_594038: Call_IdentityProviderGetEntityTag_594029;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          serviceName: string; identityProviderName: string = "facebook"): Recallable =
  ## identityProviderGetEntityTag
  ## Gets the entity state (Etag) version of the identityProvider specified by its identifier.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   identityProviderName: string (required)
  ##                       : Identity Provider Type identifier.
  var path_594039 = newJObject()
  var query_594040 = newJObject()
  add(path_594039, "resourceGroupName", newJString(resourceGroupName))
  add(query_594040, "api-version", newJString(apiVersion))
  add(path_594039, "subscriptionId", newJString(subscriptionId))
  add(path_594039, "serviceName", newJString(serviceName))
  add(path_594039, "identityProviderName", newJString(identityProviderName))
  result = call_594038.call(path_594039, query_594040, nil, nil, nil)

var identityProviderGetEntityTag* = Call_IdentityProviderGetEntityTag_594029(
    name: "identityProviderGetEntityTag", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/identityProviders/{identityProviderName}",
    validator: validate_IdentityProviderGetEntityTag_594030, base: "",
    url: url_IdentityProviderGetEntityTag_594031, schemes: {Scheme.Https})
type
  Call_IdentityProviderGet_593951 = ref object of OpenApiRestCall_593424
proc url_IdentityProviderGet_593953(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "identityProviderName" in path,
        "`identityProviderName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/identityProviders/"),
               (kind: VariableSegment, value: "identityProviderName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IdentityProviderGet_593952(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Gets the configuration details of the identity Provider configured in specified service instance.
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
  ##   identityProviderName: JString (required)
  ##                       : Identity Provider Type identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593963 = path.getOrDefault("resourceGroupName")
  valid_593963 = validateParameter(valid_593963, JString, required = true,
                                 default = nil)
  if valid_593963 != nil:
    section.add "resourceGroupName", valid_593963
  var valid_593964 = path.getOrDefault("subscriptionId")
  valid_593964 = validateParameter(valid_593964, JString, required = true,
                                 default = nil)
  if valid_593964 != nil:
    section.add "subscriptionId", valid_593964
  var valid_593965 = path.getOrDefault("serviceName")
  valid_593965 = validateParameter(valid_593965, JString, required = true,
                                 default = nil)
  if valid_593965 != nil:
    section.add "serviceName", valid_593965
  var valid_593979 = path.getOrDefault("identityProviderName")
  valid_593979 = validateParameter(valid_593979, JString, required = true,
                                 default = newJString("facebook"))
  if valid_593979 != nil:
    section.add "identityProviderName", valid_593979
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593980 = query.getOrDefault("api-version")
  valid_593980 = validateParameter(valid_593980, JString, required = true,
                                 default = nil)
  if valid_593980 != nil:
    section.add "api-version", valid_593980
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593981: Call_IdentityProviderGet_593951; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the configuration details of the identity Provider configured in specified service instance.
  ## 
  let valid = call_593981.validator(path, query, header, formData, body)
  let scheme = call_593981.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593981.url(scheme.get, call_593981.host, call_593981.base,
                         call_593981.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593981, url, valid)

proc call*(call_593982: Call_IdentityProviderGet_593951; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; serviceName: string;
          identityProviderName: string = "facebook"): Recallable =
  ## identityProviderGet
  ## Gets the configuration details of the identity Provider configured in specified service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   identityProviderName: string (required)
  ##                       : Identity Provider Type identifier.
  var path_593983 = newJObject()
  var query_593984 = newJObject()
  add(path_593983, "resourceGroupName", newJString(resourceGroupName))
  add(query_593984, "api-version", newJString(apiVersion))
  add(path_593983, "subscriptionId", newJString(subscriptionId))
  add(path_593983, "serviceName", newJString(serviceName))
  add(path_593983, "identityProviderName", newJString(identityProviderName))
  result = call_593982.call(path_593983, query_593984, nil, nil, nil)

var identityProviderGet* = Call_IdentityProviderGet_593951(
    name: "identityProviderGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/identityProviders/{identityProviderName}",
    validator: validate_IdentityProviderGet_593952, base: "",
    url: url_IdentityProviderGet_593953, schemes: {Scheme.Https})
type
  Call_IdentityProviderUpdate_594041 = ref object of OpenApiRestCall_593424
proc url_IdentityProviderUpdate_594043(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "identityProviderName" in path,
        "`identityProviderName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/identityProviders/"),
               (kind: VariableSegment, value: "identityProviderName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IdentityProviderUpdate_594042(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing IdentityProvider configuration.
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
  ##   identityProviderName: JString (required)
  ##                       : Identity Provider Type identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594044 = path.getOrDefault("resourceGroupName")
  valid_594044 = validateParameter(valid_594044, JString, required = true,
                                 default = nil)
  if valid_594044 != nil:
    section.add "resourceGroupName", valid_594044
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
  var valid_594047 = path.getOrDefault("identityProviderName")
  valid_594047 = validateParameter(valid_594047, JString, required = true,
                                 default = newJString("facebook"))
  if valid_594047 != nil:
    section.add "identityProviderName", valid_594047
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594048 = query.getOrDefault("api-version")
  valid_594048 = validateParameter(valid_594048, JString, required = true,
                                 default = nil)
  if valid_594048 != nil:
    section.add "api-version", valid_594048
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : The entity state (Etag) version of the identity provider configuration to update. A value of "*" can be used for If-Match to unconditionally apply the operation.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_594049 = header.getOrDefault("If-Match")
  valid_594049 = validateParameter(valid_594049, JString, required = true,
                                 default = nil)
  if valid_594049 != nil:
    section.add "If-Match", valid_594049
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

proc call*(call_594051: Call_IdentityProviderUpdate_594041; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing IdentityProvider configuration.
  ## 
  let valid = call_594051.validator(path, query, header, formData, body)
  let scheme = call_594051.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594051.url(scheme.get, call_594051.host, call_594051.base,
                         call_594051.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594051, url, valid)

proc call*(call_594052: Call_IdentityProviderUpdate_594041;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; serviceName: string;
          identityProviderName: string = "facebook"): Recallable =
  ## identityProviderUpdate
  ## Updates an existing IdentityProvider configuration.
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
  ##   identityProviderName: string (required)
  ##                       : Identity Provider Type identifier.
  var path_594053 = newJObject()
  var query_594054 = newJObject()
  var body_594055 = newJObject()
  add(path_594053, "resourceGroupName", newJString(resourceGroupName))
  add(query_594054, "api-version", newJString(apiVersion))
  add(path_594053, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594055 = parameters
  add(path_594053, "serviceName", newJString(serviceName))
  add(path_594053, "identityProviderName", newJString(identityProviderName))
  result = call_594052.call(path_594053, query_594054, nil, nil, body_594055)

var identityProviderUpdate* = Call_IdentityProviderUpdate_594041(
    name: "identityProviderUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/identityProviders/{identityProviderName}",
    validator: validate_IdentityProviderUpdate_594042, base: "",
    url: url_IdentityProviderUpdate_594043, schemes: {Scheme.Https})
type
  Call_IdentityProviderDelete_594016 = ref object of OpenApiRestCall_593424
proc url_IdentityProviderDelete_594018(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "identityProviderName" in path,
        "`identityProviderName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/identityProviders/"),
               (kind: VariableSegment, value: "identityProviderName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IdentityProviderDelete_594017(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified identity provider configuration.
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
  ##   identityProviderName: JString (required)
  ##                       : Identity Provider Type identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594019 = path.getOrDefault("resourceGroupName")
  valid_594019 = validateParameter(valid_594019, JString, required = true,
                                 default = nil)
  if valid_594019 != nil:
    section.add "resourceGroupName", valid_594019
  var valid_594020 = path.getOrDefault("subscriptionId")
  valid_594020 = validateParameter(valid_594020, JString, required = true,
                                 default = nil)
  if valid_594020 != nil:
    section.add "subscriptionId", valid_594020
  var valid_594021 = path.getOrDefault("serviceName")
  valid_594021 = validateParameter(valid_594021, JString, required = true,
                                 default = nil)
  if valid_594021 != nil:
    section.add "serviceName", valid_594021
  var valid_594022 = path.getOrDefault("identityProviderName")
  valid_594022 = validateParameter(valid_594022, JString, required = true,
                                 default = newJString("facebook"))
  if valid_594022 != nil:
    section.add "identityProviderName", valid_594022
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594023 = query.getOrDefault("api-version")
  valid_594023 = validateParameter(valid_594023, JString, required = true,
                                 default = nil)
  if valid_594023 != nil:
    section.add "api-version", valid_594023
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : The entity state (Etag) version of the backend to delete. A value of "*" can be used for If-Match to unconditionally apply the operation.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_594024 = header.getOrDefault("If-Match")
  valid_594024 = validateParameter(valid_594024, JString, required = true,
                                 default = nil)
  if valid_594024 != nil:
    section.add "If-Match", valid_594024
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594025: Call_IdentityProviderDelete_594016; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified identity provider configuration.
  ## 
  let valid = call_594025.validator(path, query, header, formData, body)
  let scheme = call_594025.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594025.url(scheme.get, call_594025.host, call_594025.base,
                         call_594025.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594025, url, valid)

proc call*(call_594026: Call_IdentityProviderDelete_594016;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          serviceName: string; identityProviderName: string = "facebook"): Recallable =
  ## identityProviderDelete
  ## Deletes the specified identity provider configuration.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   identityProviderName: string (required)
  ##                       : Identity Provider Type identifier.
  var path_594027 = newJObject()
  var query_594028 = newJObject()
  add(path_594027, "resourceGroupName", newJString(resourceGroupName))
  add(query_594028, "api-version", newJString(apiVersion))
  add(path_594027, "subscriptionId", newJString(subscriptionId))
  add(path_594027, "serviceName", newJString(serviceName))
  add(path_594027, "identityProviderName", newJString(identityProviderName))
  result = call_594026.call(path_594027, query_594028, nil, nil, nil)

var identityProviderDelete* = Call_IdentityProviderDelete_594016(
    name: "identityProviderDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/identityProviders/{identityProviderName}",
    validator: validate_IdentityProviderDelete_594017, base: "",
    url: url_IdentityProviderDelete_594018, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
