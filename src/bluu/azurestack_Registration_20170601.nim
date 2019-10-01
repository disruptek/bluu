
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Azure Stack Azure Bridge Client
## version: 2017-06-01
## termsOfService: (not provided)
## license: (not provided)
## 
## 
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

  OpenApiRestCall_574441 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_574441](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_574441): Option[Scheme] {.used.} =
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
  macServiceName = "azurestack-Registration"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_RegistrationsList_574663 = ref object of OpenApiRestCall_574441
proc url_RegistrationsList_574665(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroup" in path, "`resourceGroup` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroup"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.AzureStack/registrations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RegistrationsList_574664(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Returns a list of all registrations.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroup: JString (required)
  ##                : Name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_574825 = path.getOrDefault("subscriptionId")
  valid_574825 = validateParameter(valid_574825, JString, required = true,
                                 default = nil)
  if valid_574825 != nil:
    section.add "subscriptionId", valid_574825
  var valid_574826 = path.getOrDefault("resourceGroup")
  valid_574826 = validateParameter(valid_574826, JString, required = true,
                                 default = nil)
  if valid_574826 != nil:
    section.add "resourceGroup", valid_574826
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574840 = query.getOrDefault("api-version")
  valid_574840 = validateParameter(valid_574840, JString, required = true,
                                 default = newJString("2017-06-01"))
  if valid_574840 != nil:
    section.add "api-version", valid_574840
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574867: Call_RegistrationsList_574663; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of all registrations.
  ## 
  let valid = call_574867.validator(path, query, header, formData, body)
  let scheme = call_574867.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574867.url(scheme.get, call_574867.host, call_574867.base,
                         call_574867.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574867, url, valid)

proc call*(call_574938: Call_RegistrationsList_574663; subscriptionId: string;
          resourceGroup: string; apiVersion: string = "2017-06-01"): Recallable =
  ## registrationsList
  ## Returns a list of all registrations.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroup: string (required)
  ##                : Name of the resource group.
  var path_574939 = newJObject()
  var query_574941 = newJObject()
  add(query_574941, "api-version", newJString(apiVersion))
  add(path_574939, "subscriptionId", newJString(subscriptionId))
  add(path_574939, "resourceGroup", newJString(resourceGroup))
  result = call_574938.call(path_574939, query_574941, nil, nil, nil)

var registrationsList* = Call_RegistrationsList_574663(name: "registrationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.AzureStack/registrations",
    validator: validate_RegistrationsList_574664, base: "",
    url: url_RegistrationsList_574665, schemes: {Scheme.Https})
type
  Call_RegistrationsCreateOrUpdate_574991 = ref object of OpenApiRestCall_574441
proc url_RegistrationsCreateOrUpdate_574993(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroup" in path, "`resourceGroup` is a required path parameter"
  assert "registrationName" in path,
        "`registrationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroup"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.AzureStack/registrations/"),
               (kind: VariableSegment, value: "registrationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RegistrationsCreateOrUpdate_574992(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update an Azure Stack registration.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   registrationName: JString (required)
  ##                   : Name of the Azure Stack registration.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroup: JString (required)
  ##                : Name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `registrationName` field"
  var valid_575003 = path.getOrDefault("registrationName")
  valid_575003 = validateParameter(valid_575003, JString, required = true,
                                 default = nil)
  if valid_575003 != nil:
    section.add "registrationName", valid_575003
  var valid_575004 = path.getOrDefault("subscriptionId")
  valid_575004 = validateParameter(valid_575004, JString, required = true,
                                 default = nil)
  if valid_575004 != nil:
    section.add "subscriptionId", valid_575004
  var valid_575005 = path.getOrDefault("resourceGroup")
  valid_575005 = validateParameter(valid_575005, JString, required = true,
                                 default = nil)
  if valid_575005 != nil:
    section.add "resourceGroup", valid_575005
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575006 = query.getOrDefault("api-version")
  valid_575006 = validateParameter(valid_575006, JString, required = true,
                                 default = newJString("2017-06-01"))
  if valid_575006 != nil:
    section.add "api-version", valid_575006
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   token: JObject (required)
  ##        : Registration token
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575008: Call_RegistrationsCreateOrUpdate_574991; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update an Azure Stack registration.
  ## 
  let valid = call_575008.validator(path, query, header, formData, body)
  let scheme = call_575008.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575008.url(scheme.get, call_575008.host, call_575008.base,
                         call_575008.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575008, url, valid)

proc call*(call_575009: Call_RegistrationsCreateOrUpdate_574991;
          registrationName: string; subscriptionId: string; resourceGroup: string;
          token: JsonNode; apiVersion: string = "2017-06-01"): Recallable =
  ## registrationsCreateOrUpdate
  ## Create or update an Azure Stack registration.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   registrationName: string (required)
  ##                   : Name of the Azure Stack registration.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroup: string (required)
  ##                : Name of the resource group.
  ##   token: JObject (required)
  ##        : Registration token
  var path_575010 = newJObject()
  var query_575011 = newJObject()
  var body_575012 = newJObject()
  add(query_575011, "api-version", newJString(apiVersion))
  add(path_575010, "registrationName", newJString(registrationName))
  add(path_575010, "subscriptionId", newJString(subscriptionId))
  add(path_575010, "resourceGroup", newJString(resourceGroup))
  if token != nil:
    body_575012 = token
  result = call_575009.call(path_575010, query_575011, nil, nil, body_575012)

var registrationsCreateOrUpdate* = Call_RegistrationsCreateOrUpdate_574991(
    name: "registrationsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.AzureStack/registrations/{registrationName}",
    validator: validate_RegistrationsCreateOrUpdate_574992, base: "",
    url: url_RegistrationsCreateOrUpdate_574993, schemes: {Scheme.Https})
type
  Call_RegistrationsGet_574980 = ref object of OpenApiRestCall_574441
proc url_RegistrationsGet_574982(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroup" in path, "`resourceGroup` is a required path parameter"
  assert "registrationName" in path,
        "`registrationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroup"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.AzureStack/registrations/"),
               (kind: VariableSegment, value: "registrationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RegistrationsGet_574981(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Returns the properties of an Azure Stack registration.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   registrationName: JString (required)
  ##                   : Name of the Azure Stack registration.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroup: JString (required)
  ##                : Name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `registrationName` field"
  var valid_574983 = path.getOrDefault("registrationName")
  valid_574983 = validateParameter(valid_574983, JString, required = true,
                                 default = nil)
  if valid_574983 != nil:
    section.add "registrationName", valid_574983
  var valid_574984 = path.getOrDefault("subscriptionId")
  valid_574984 = validateParameter(valid_574984, JString, required = true,
                                 default = nil)
  if valid_574984 != nil:
    section.add "subscriptionId", valid_574984
  var valid_574985 = path.getOrDefault("resourceGroup")
  valid_574985 = validateParameter(valid_574985, JString, required = true,
                                 default = nil)
  if valid_574985 != nil:
    section.add "resourceGroup", valid_574985
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574986 = query.getOrDefault("api-version")
  valid_574986 = validateParameter(valid_574986, JString, required = true,
                                 default = newJString("2017-06-01"))
  if valid_574986 != nil:
    section.add "api-version", valid_574986
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574987: Call_RegistrationsGet_574980; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the properties of an Azure Stack registration.
  ## 
  let valid = call_574987.validator(path, query, header, formData, body)
  let scheme = call_574987.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574987.url(scheme.get, call_574987.host, call_574987.base,
                         call_574987.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574987, url, valid)

proc call*(call_574988: Call_RegistrationsGet_574980; registrationName: string;
          subscriptionId: string; resourceGroup: string;
          apiVersion: string = "2017-06-01"): Recallable =
  ## registrationsGet
  ## Returns the properties of an Azure Stack registration.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   registrationName: string (required)
  ##                   : Name of the Azure Stack registration.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroup: string (required)
  ##                : Name of the resource group.
  var path_574989 = newJObject()
  var query_574990 = newJObject()
  add(query_574990, "api-version", newJString(apiVersion))
  add(path_574989, "registrationName", newJString(registrationName))
  add(path_574989, "subscriptionId", newJString(subscriptionId))
  add(path_574989, "resourceGroup", newJString(resourceGroup))
  result = call_574988.call(path_574989, query_574990, nil, nil, nil)

var registrationsGet* = Call_RegistrationsGet_574980(name: "registrationsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.AzureStack/registrations/{registrationName}",
    validator: validate_RegistrationsGet_574981, base: "",
    url: url_RegistrationsGet_574982, schemes: {Scheme.Https})
type
  Call_RegistrationsUpdate_575024 = ref object of OpenApiRestCall_574441
proc url_RegistrationsUpdate_575026(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroup" in path, "`resourceGroup` is a required path parameter"
  assert "registrationName" in path,
        "`registrationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroup"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.AzureStack/registrations/"),
               (kind: VariableSegment, value: "registrationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RegistrationsUpdate_575025(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Patch an Azure Stack registration.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   registrationName: JString (required)
  ##                   : Name of the Azure Stack registration.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroup: JString (required)
  ##                : Name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `registrationName` field"
  var valid_575027 = path.getOrDefault("registrationName")
  valid_575027 = validateParameter(valid_575027, JString, required = true,
                                 default = nil)
  if valid_575027 != nil:
    section.add "registrationName", valid_575027
  var valid_575028 = path.getOrDefault("subscriptionId")
  valid_575028 = validateParameter(valid_575028, JString, required = true,
                                 default = nil)
  if valid_575028 != nil:
    section.add "subscriptionId", valid_575028
  var valid_575029 = path.getOrDefault("resourceGroup")
  valid_575029 = validateParameter(valid_575029, JString, required = true,
                                 default = nil)
  if valid_575029 != nil:
    section.add "resourceGroup", valid_575029
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575030 = query.getOrDefault("api-version")
  valid_575030 = validateParameter(valid_575030, JString, required = true,
                                 default = newJString("2017-06-01"))
  if valid_575030 != nil:
    section.add "api-version", valid_575030
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   token: JObject (required)
  ##        : Registration token
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575032: Call_RegistrationsUpdate_575024; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Patch an Azure Stack registration.
  ## 
  let valid = call_575032.validator(path, query, header, formData, body)
  let scheme = call_575032.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575032.url(scheme.get, call_575032.host, call_575032.base,
                         call_575032.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575032, url, valid)

proc call*(call_575033: Call_RegistrationsUpdate_575024; registrationName: string;
          subscriptionId: string; resourceGroup: string; token: JsonNode;
          apiVersion: string = "2017-06-01"): Recallable =
  ## registrationsUpdate
  ## Patch an Azure Stack registration.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   registrationName: string (required)
  ##                   : Name of the Azure Stack registration.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroup: string (required)
  ##                : Name of the resource group.
  ##   token: JObject (required)
  ##        : Registration token
  var path_575034 = newJObject()
  var query_575035 = newJObject()
  var body_575036 = newJObject()
  add(query_575035, "api-version", newJString(apiVersion))
  add(path_575034, "registrationName", newJString(registrationName))
  add(path_575034, "subscriptionId", newJString(subscriptionId))
  add(path_575034, "resourceGroup", newJString(resourceGroup))
  if token != nil:
    body_575036 = token
  result = call_575033.call(path_575034, query_575035, nil, nil, body_575036)

var registrationsUpdate* = Call_RegistrationsUpdate_575024(
    name: "registrationsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.AzureStack/registrations/{registrationName}",
    validator: validate_RegistrationsUpdate_575025, base: "",
    url: url_RegistrationsUpdate_575026, schemes: {Scheme.Https})
type
  Call_RegistrationsDelete_575013 = ref object of OpenApiRestCall_574441
proc url_RegistrationsDelete_575015(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroup" in path, "`resourceGroup` is a required path parameter"
  assert "registrationName" in path,
        "`registrationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroup"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.AzureStack/registrations/"),
               (kind: VariableSegment, value: "registrationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RegistrationsDelete_575014(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Delete the requested Azure Stack registration.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   registrationName: JString (required)
  ##                   : Name of the Azure Stack registration.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroup: JString (required)
  ##                : Name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `registrationName` field"
  var valid_575016 = path.getOrDefault("registrationName")
  valid_575016 = validateParameter(valid_575016, JString, required = true,
                                 default = nil)
  if valid_575016 != nil:
    section.add "registrationName", valid_575016
  var valid_575017 = path.getOrDefault("subscriptionId")
  valid_575017 = validateParameter(valid_575017, JString, required = true,
                                 default = nil)
  if valid_575017 != nil:
    section.add "subscriptionId", valid_575017
  var valid_575018 = path.getOrDefault("resourceGroup")
  valid_575018 = validateParameter(valid_575018, JString, required = true,
                                 default = nil)
  if valid_575018 != nil:
    section.add "resourceGroup", valid_575018
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575019 = query.getOrDefault("api-version")
  valid_575019 = validateParameter(valid_575019, JString, required = true,
                                 default = newJString("2017-06-01"))
  if valid_575019 != nil:
    section.add "api-version", valid_575019
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575020: Call_RegistrationsDelete_575013; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete the requested Azure Stack registration.
  ## 
  let valid = call_575020.validator(path, query, header, formData, body)
  let scheme = call_575020.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575020.url(scheme.get, call_575020.host, call_575020.base,
                         call_575020.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575020, url, valid)

proc call*(call_575021: Call_RegistrationsDelete_575013; registrationName: string;
          subscriptionId: string; resourceGroup: string;
          apiVersion: string = "2017-06-01"): Recallable =
  ## registrationsDelete
  ## Delete the requested Azure Stack registration.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   registrationName: string (required)
  ##                   : Name of the Azure Stack registration.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroup: string (required)
  ##                : Name of the resource group.
  var path_575022 = newJObject()
  var query_575023 = newJObject()
  add(query_575023, "api-version", newJString(apiVersion))
  add(path_575022, "registrationName", newJString(registrationName))
  add(path_575022, "subscriptionId", newJString(subscriptionId))
  add(path_575022, "resourceGroup", newJString(resourceGroup))
  result = call_575021.call(path_575022, query_575023, nil, nil, nil)

var registrationsDelete* = Call_RegistrationsDelete_575013(
    name: "registrationsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.AzureStack/registrations/{registrationName}",
    validator: validate_RegistrationsDelete_575014, base: "",
    url: url_RegistrationsDelete_575015, schemes: {Scheme.Https})
type
  Call_RegistrationsGetActivationKey_575037 = ref object of OpenApiRestCall_574441
proc url_RegistrationsGetActivationKey_575039(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroup" in path, "`resourceGroup` is a required path parameter"
  assert "registrationName" in path,
        "`registrationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroup"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.AzureStack/registrations/"),
               (kind: VariableSegment, value: "registrationName"),
               (kind: ConstantSegment, value: "/getactivationkey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RegistrationsGetActivationKey_575038(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns Azure Stack Activation Key.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   registrationName: JString (required)
  ##                   : Name of the Azure Stack registration.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroup: JString (required)
  ##                : Name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `registrationName` field"
  var valid_575040 = path.getOrDefault("registrationName")
  valid_575040 = validateParameter(valid_575040, JString, required = true,
                                 default = nil)
  if valid_575040 != nil:
    section.add "registrationName", valid_575040
  var valid_575041 = path.getOrDefault("subscriptionId")
  valid_575041 = validateParameter(valid_575041, JString, required = true,
                                 default = nil)
  if valid_575041 != nil:
    section.add "subscriptionId", valid_575041
  var valid_575042 = path.getOrDefault("resourceGroup")
  valid_575042 = validateParameter(valid_575042, JString, required = true,
                                 default = nil)
  if valid_575042 != nil:
    section.add "resourceGroup", valid_575042
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575043 = query.getOrDefault("api-version")
  valid_575043 = validateParameter(valid_575043, JString, required = true,
                                 default = newJString("2017-06-01"))
  if valid_575043 != nil:
    section.add "api-version", valid_575043
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575044: Call_RegistrationsGetActivationKey_575037; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns Azure Stack Activation Key.
  ## 
  let valid = call_575044.validator(path, query, header, formData, body)
  let scheme = call_575044.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575044.url(scheme.get, call_575044.host, call_575044.base,
                         call_575044.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575044, url, valid)

proc call*(call_575045: Call_RegistrationsGetActivationKey_575037;
          registrationName: string; subscriptionId: string; resourceGroup: string;
          apiVersion: string = "2017-06-01"): Recallable =
  ## registrationsGetActivationKey
  ## Returns Azure Stack Activation Key.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   registrationName: string (required)
  ##                   : Name of the Azure Stack registration.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroup: string (required)
  ##                : Name of the resource group.
  var path_575046 = newJObject()
  var query_575047 = newJObject()
  add(query_575047, "api-version", newJString(apiVersion))
  add(path_575046, "registrationName", newJString(registrationName))
  add(path_575046, "subscriptionId", newJString(subscriptionId))
  add(path_575046, "resourceGroup", newJString(resourceGroup))
  result = call_575045.call(path_575046, query_575047, nil, nil, nil)

var registrationsGetActivationKey* = Call_RegistrationsGetActivationKey_575037(
    name: "registrationsGetActivationKey", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.AzureStack/registrations/{registrationName}/getactivationkey",
    validator: validate_RegistrationsGetActivationKey_575038, base: "",
    url: url_RegistrationsGetActivationKey_575039, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
