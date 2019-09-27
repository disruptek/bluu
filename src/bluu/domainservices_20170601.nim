
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Domain Services Resource Provider
## version: 2017-06-01
## termsOfService: (not provided)
## license: (not provided)
## 
## The AAD Domain Services API.
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
  macServiceName = "domainservices"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_DomainServiceOperationsList_593646 = ref object of OpenApiRestCall_593424
proc url_DomainServiceOperationsList_593648(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DomainServiceOperationsList_593647(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the available Domain Services operations.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593807 = query.getOrDefault("api-version")
  valid_593807 = validateParameter(valid_593807, JString, required = true,
                                 default = nil)
  if valid_593807 != nil:
    section.add "api-version", valid_593807
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593830: Call_DomainServiceOperationsList_593646; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the available Domain Services operations.
  ## 
  let valid = call_593830.validator(path, query, header, formData, body)
  let scheme = call_593830.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593830.url(scheme.get, call_593830.host, call_593830.base,
                         call_593830.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593830, url, valid)

proc call*(call_593901: Call_DomainServiceOperationsList_593646; apiVersion: string): Recallable =
  ## domainServiceOperationsList
  ## Lists all the available Domain Services operations.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_593902 = newJObject()
  add(query_593902, "api-version", newJString(apiVersion))
  result = call_593901.call(nil, query_593902, nil, nil, nil)

var domainServiceOperationsList* = Call_DomainServiceOperationsList_593646(
    name: "domainServiceOperationsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.AAD/operations",
    validator: validate_DomainServiceOperationsList_593647, base: "",
    url: url_DomainServiceOperationsList_593648, schemes: {Scheme.Https})
type
  Call_DomainServicesList_593942 = ref object of OpenApiRestCall_593424
proc url_DomainServicesList_593944(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.AAD/domainServices")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DomainServicesList_593943(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## The List Domain Services in Subscription operation lists all the domain services available under the given subscription (and across all resource groups within that subscription).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_593959 = path.getOrDefault("subscriptionId")
  valid_593959 = validateParameter(valid_593959, JString, required = true,
                                 default = nil)
  if valid_593959 != nil:
    section.add "subscriptionId", valid_593959
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593960 = query.getOrDefault("api-version")
  valid_593960 = validateParameter(valid_593960, JString, required = true,
                                 default = nil)
  if valid_593960 != nil:
    section.add "api-version", valid_593960
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593961: Call_DomainServicesList_593942; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The List Domain Services in Subscription operation lists all the domain services available under the given subscription (and across all resource groups within that subscription).
  ## 
  let valid = call_593961.validator(path, query, header, formData, body)
  let scheme = call_593961.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593961.url(scheme.get, call_593961.host, call_593961.base,
                         call_593961.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593961, url, valid)

proc call*(call_593962: Call_DomainServicesList_593942; apiVersion: string;
          subscriptionId: string): Recallable =
  ## domainServicesList
  ## The List Domain Services in Subscription operation lists all the domain services available under the given subscription (and across all resource groups within that subscription).
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_593963 = newJObject()
  var query_593964 = newJObject()
  add(query_593964, "api-version", newJString(apiVersion))
  add(path_593963, "subscriptionId", newJString(subscriptionId))
  result = call_593962.call(path_593963, query_593964, nil, nil, nil)

var domainServicesList* = Call_DomainServicesList_593942(
    name: "domainServicesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.AAD/domainServices",
    validator: validate_DomainServicesList_593943, base: "",
    url: url_DomainServicesList_593944, schemes: {Scheme.Https})
type
  Call_DomainServicesListByResourceGroup_593965 = ref object of OpenApiRestCall_593424
proc url_DomainServicesListByResourceGroup_593967(protocol: Scheme; host: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.AAD/domainServices")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DomainServicesListByResourceGroup_593966(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The List Domain Services in Resource Group operation lists all the domain services available under the given resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593968 = path.getOrDefault("resourceGroupName")
  valid_593968 = validateParameter(valid_593968, JString, required = true,
                                 default = nil)
  if valid_593968 != nil:
    section.add "resourceGroupName", valid_593968
  var valid_593969 = path.getOrDefault("subscriptionId")
  valid_593969 = validateParameter(valid_593969, JString, required = true,
                                 default = nil)
  if valid_593969 != nil:
    section.add "subscriptionId", valid_593969
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593970 = query.getOrDefault("api-version")
  valid_593970 = validateParameter(valid_593970, JString, required = true,
                                 default = nil)
  if valid_593970 != nil:
    section.add "api-version", valid_593970
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593971: Call_DomainServicesListByResourceGroup_593965;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The List Domain Services in Resource Group operation lists all the domain services available under the given resource group.
  ## 
  let valid = call_593971.validator(path, query, header, formData, body)
  let scheme = call_593971.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593971.url(scheme.get, call_593971.host, call_593971.base,
                         call_593971.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593971, url, valid)

proc call*(call_593972: Call_DomainServicesListByResourceGroup_593965;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## domainServicesListByResourceGroup
  ## The List Domain Services in Resource Group operation lists all the domain services available under the given resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_593973 = newJObject()
  var query_593974 = newJObject()
  add(path_593973, "resourceGroupName", newJString(resourceGroupName))
  add(query_593974, "api-version", newJString(apiVersion))
  add(path_593973, "subscriptionId", newJString(subscriptionId))
  result = call_593972.call(path_593973, query_593974, nil, nil, nil)

var domainServicesListByResourceGroup* = Call_DomainServicesListByResourceGroup_593965(
    name: "domainServicesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AAD/domainServices",
    validator: validate_DomainServicesListByResourceGroup_593966, base: "",
    url: url_DomainServicesListByResourceGroup_593967, schemes: {Scheme.Https})
type
  Call_DomainServicesCreateOrUpdate_593986 = ref object of OpenApiRestCall_593424
proc url_DomainServicesCreateOrUpdate_593988(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "domainServiceName" in path,
        "`domainServiceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.AAD/domainServices/"),
               (kind: VariableSegment, value: "domainServiceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DomainServicesCreateOrUpdate_593987(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The Create Domain Service operation creates a new domain service with the specified parameters. If the specific service already exists, then any patchable properties will be updated and any immutable properties will remain unchanged.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   domainServiceName: JString (required)
  ##                    : The name of the domain service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594006 = path.getOrDefault("resourceGroupName")
  valid_594006 = validateParameter(valid_594006, JString, required = true,
                                 default = nil)
  if valid_594006 != nil:
    section.add "resourceGroupName", valid_594006
  var valid_594007 = path.getOrDefault("subscriptionId")
  valid_594007 = validateParameter(valid_594007, JString, required = true,
                                 default = nil)
  if valid_594007 != nil:
    section.add "subscriptionId", valid_594007
  var valid_594008 = path.getOrDefault("domainServiceName")
  valid_594008 = validateParameter(valid_594008, JString, required = true,
                                 default = nil)
  if valid_594008 != nil:
    section.add "domainServiceName", valid_594008
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
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
  ##   domainService: JObject (required)
  ##                : Properties supplied to the Create or Update a Domain Service operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594011: Call_DomainServicesCreateOrUpdate_593986; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Create Domain Service operation creates a new domain service with the specified parameters. If the specific service already exists, then any patchable properties will be updated and any immutable properties will remain unchanged.
  ## 
  let valid = call_594011.validator(path, query, header, formData, body)
  let scheme = call_594011.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594011.url(scheme.get, call_594011.host, call_594011.base,
                         call_594011.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594011, url, valid)

proc call*(call_594012: Call_DomainServicesCreateOrUpdate_593986;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          domainServiceName: string; domainService: JsonNode): Recallable =
  ## domainServicesCreateOrUpdate
  ## The Create Domain Service operation creates a new domain service with the specified parameters. If the specific service already exists, then any patchable properties will be updated and any immutable properties will remain unchanged.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   domainServiceName: string (required)
  ##                    : The name of the domain service.
  ##   domainService: JObject (required)
  ##                : Properties supplied to the Create or Update a Domain Service operation.
  var path_594013 = newJObject()
  var query_594014 = newJObject()
  var body_594015 = newJObject()
  add(path_594013, "resourceGroupName", newJString(resourceGroupName))
  add(query_594014, "api-version", newJString(apiVersion))
  add(path_594013, "subscriptionId", newJString(subscriptionId))
  add(path_594013, "domainServiceName", newJString(domainServiceName))
  if domainService != nil:
    body_594015 = domainService
  result = call_594012.call(path_594013, query_594014, nil, nil, body_594015)

var domainServicesCreateOrUpdate* = Call_DomainServicesCreateOrUpdate_593986(
    name: "domainServicesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AAD/domainServices/{domainServiceName}",
    validator: validate_DomainServicesCreateOrUpdate_593987, base: "",
    url: url_DomainServicesCreateOrUpdate_593988, schemes: {Scheme.Https})
type
  Call_DomainServicesGet_593975 = ref object of OpenApiRestCall_593424
proc url_DomainServicesGet_593977(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "domainServiceName" in path,
        "`domainServiceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.AAD/domainServices/"),
               (kind: VariableSegment, value: "domainServiceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DomainServicesGet_593976(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## The Get Domain Service operation retrieves a json representation of the Domain Service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   domainServiceName: JString (required)
  ##                    : The name of the domain service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593978 = path.getOrDefault("resourceGroupName")
  valid_593978 = validateParameter(valid_593978, JString, required = true,
                                 default = nil)
  if valid_593978 != nil:
    section.add "resourceGroupName", valid_593978
  var valid_593979 = path.getOrDefault("subscriptionId")
  valid_593979 = validateParameter(valid_593979, JString, required = true,
                                 default = nil)
  if valid_593979 != nil:
    section.add "subscriptionId", valid_593979
  var valid_593980 = path.getOrDefault("domainServiceName")
  valid_593980 = validateParameter(valid_593980, JString, required = true,
                                 default = nil)
  if valid_593980 != nil:
    section.add "domainServiceName", valid_593980
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593981 = query.getOrDefault("api-version")
  valid_593981 = validateParameter(valid_593981, JString, required = true,
                                 default = nil)
  if valid_593981 != nil:
    section.add "api-version", valid_593981
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593982: Call_DomainServicesGet_593975; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get Domain Service operation retrieves a json representation of the Domain Service.
  ## 
  let valid = call_593982.validator(path, query, header, formData, body)
  let scheme = call_593982.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593982.url(scheme.get, call_593982.host, call_593982.base,
                         call_593982.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593982, url, valid)

proc call*(call_593983: Call_DomainServicesGet_593975; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; domainServiceName: string): Recallable =
  ## domainServicesGet
  ## The Get Domain Service operation retrieves a json representation of the Domain Service.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   domainServiceName: string (required)
  ##                    : The name of the domain service.
  var path_593984 = newJObject()
  var query_593985 = newJObject()
  add(path_593984, "resourceGroupName", newJString(resourceGroupName))
  add(query_593985, "api-version", newJString(apiVersion))
  add(path_593984, "subscriptionId", newJString(subscriptionId))
  add(path_593984, "domainServiceName", newJString(domainServiceName))
  result = call_593983.call(path_593984, query_593985, nil, nil, nil)

var domainServicesGet* = Call_DomainServicesGet_593975(name: "domainServicesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AAD/domainServices/{domainServiceName}",
    validator: validate_DomainServicesGet_593976, base: "",
    url: url_DomainServicesGet_593977, schemes: {Scheme.Https})
type
  Call_DomainServicesUpdate_594027 = ref object of OpenApiRestCall_593424
proc url_DomainServicesUpdate_594029(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "domainServiceName" in path,
        "`domainServiceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.AAD/domainServices/"),
               (kind: VariableSegment, value: "domainServiceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DomainServicesUpdate_594028(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The Update Domain Service operation can be used to update the existing deployment. The update call only supports the properties listed in the PATCH body.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   domainServiceName: JString (required)
  ##                    : The name of the domain service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594030 = path.getOrDefault("resourceGroupName")
  valid_594030 = validateParameter(valid_594030, JString, required = true,
                                 default = nil)
  if valid_594030 != nil:
    section.add "resourceGroupName", valid_594030
  var valid_594031 = path.getOrDefault("subscriptionId")
  valid_594031 = validateParameter(valid_594031, JString, required = true,
                                 default = nil)
  if valid_594031 != nil:
    section.add "subscriptionId", valid_594031
  var valid_594032 = path.getOrDefault("domainServiceName")
  valid_594032 = validateParameter(valid_594032, JString, required = true,
                                 default = nil)
  if valid_594032 != nil:
    section.add "domainServiceName", valid_594032
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594033 = query.getOrDefault("api-version")
  valid_594033 = validateParameter(valid_594033, JString, required = true,
                                 default = nil)
  if valid_594033 != nil:
    section.add "api-version", valid_594033
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   domainService: JObject (required)
  ##                : Properties supplied to the Update a Domain Service operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594035: Call_DomainServicesUpdate_594027; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Update Domain Service operation can be used to update the existing deployment. The update call only supports the properties listed in the PATCH body.
  ## 
  let valid = call_594035.validator(path, query, header, formData, body)
  let scheme = call_594035.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594035.url(scheme.get, call_594035.host, call_594035.base,
                         call_594035.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594035, url, valid)

proc call*(call_594036: Call_DomainServicesUpdate_594027;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          domainServiceName: string; domainService: JsonNode): Recallable =
  ## domainServicesUpdate
  ## The Update Domain Service operation can be used to update the existing deployment. The update call only supports the properties listed in the PATCH body.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   domainServiceName: string (required)
  ##                    : The name of the domain service.
  ##   domainService: JObject (required)
  ##                : Properties supplied to the Update a Domain Service operation.
  var path_594037 = newJObject()
  var query_594038 = newJObject()
  var body_594039 = newJObject()
  add(path_594037, "resourceGroupName", newJString(resourceGroupName))
  add(query_594038, "api-version", newJString(apiVersion))
  add(path_594037, "subscriptionId", newJString(subscriptionId))
  add(path_594037, "domainServiceName", newJString(domainServiceName))
  if domainService != nil:
    body_594039 = domainService
  result = call_594036.call(path_594037, query_594038, nil, nil, body_594039)

var domainServicesUpdate* = Call_DomainServicesUpdate_594027(
    name: "domainServicesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AAD/domainServices/{domainServiceName}",
    validator: validate_DomainServicesUpdate_594028, base: "",
    url: url_DomainServicesUpdate_594029, schemes: {Scheme.Https})
type
  Call_DomainServicesDelete_594016 = ref object of OpenApiRestCall_593424
proc url_DomainServicesDelete_594018(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "domainServiceName" in path,
        "`domainServiceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.AAD/domainServices/"),
               (kind: VariableSegment, value: "domainServiceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DomainServicesDelete_594017(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The Delete Domain Service operation deletes an existing Domain Service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   domainServiceName: JString (required)
  ##                    : The name of the domain service.
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
  var valid_594021 = path.getOrDefault("domainServiceName")
  valid_594021 = validateParameter(valid_594021, JString, required = true,
                                 default = nil)
  if valid_594021 != nil:
    section.add "domainServiceName", valid_594021
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594022 = query.getOrDefault("api-version")
  valid_594022 = validateParameter(valid_594022, JString, required = true,
                                 default = nil)
  if valid_594022 != nil:
    section.add "api-version", valid_594022
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594023: Call_DomainServicesDelete_594016; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Delete Domain Service operation deletes an existing Domain Service.
  ## 
  let valid = call_594023.validator(path, query, header, formData, body)
  let scheme = call_594023.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594023.url(scheme.get, call_594023.host, call_594023.base,
                         call_594023.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594023, url, valid)

proc call*(call_594024: Call_DomainServicesDelete_594016;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          domainServiceName: string): Recallable =
  ## domainServicesDelete
  ## The Delete Domain Service operation deletes an existing Domain Service.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   domainServiceName: string (required)
  ##                    : The name of the domain service.
  var path_594025 = newJObject()
  var query_594026 = newJObject()
  add(path_594025, "resourceGroupName", newJString(resourceGroupName))
  add(query_594026, "api-version", newJString(apiVersion))
  add(path_594025, "subscriptionId", newJString(subscriptionId))
  add(path_594025, "domainServiceName", newJString(domainServiceName))
  result = call_594024.call(path_594025, query_594026, nil, nil, nil)

var domainServicesDelete* = Call_DomainServicesDelete_594016(
    name: "domainServicesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AAD/domainServices/{domainServiceName}",
    validator: validate_DomainServicesDelete_594017, base: "",
    url: url_DomainServicesDelete_594018, schemes: {Scheme.Https})
type
  Call_ReplicaSetsListByResourceGroup_594040 = ref object of OpenApiRestCall_593424
proc url_ReplicaSetsListByResourceGroup_594042(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "domainServiceName" in path,
        "`domainServiceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.AAD/domainServices/"),
               (kind: VariableSegment, value: "domainServiceName"),
               (kind: ConstantSegment, value: "/replicaSets")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicaSetsListByResourceGroup_594041(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The List ReplicaSets in Resource Group operation lists all the domain services available under the given resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   domainServiceName: JString (required)
  ##                    : The name of the domain service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594043 = path.getOrDefault("resourceGroupName")
  valid_594043 = validateParameter(valid_594043, JString, required = true,
                                 default = nil)
  if valid_594043 != nil:
    section.add "resourceGroupName", valid_594043
  var valid_594044 = path.getOrDefault("subscriptionId")
  valid_594044 = validateParameter(valid_594044, JString, required = true,
                                 default = nil)
  if valid_594044 != nil:
    section.add "subscriptionId", valid_594044
  var valid_594045 = path.getOrDefault("domainServiceName")
  valid_594045 = validateParameter(valid_594045, JString, required = true,
                                 default = nil)
  if valid_594045 != nil:
    section.add "domainServiceName", valid_594045
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594046 = query.getOrDefault("api-version")
  valid_594046 = validateParameter(valid_594046, JString, required = true,
                                 default = nil)
  if valid_594046 != nil:
    section.add "api-version", valid_594046
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594047: Call_ReplicaSetsListByResourceGroup_594040; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The List ReplicaSets in Resource Group operation lists all the domain services available under the given resource group.
  ## 
  let valid = call_594047.validator(path, query, header, formData, body)
  let scheme = call_594047.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594047.url(scheme.get, call_594047.host, call_594047.base,
                         call_594047.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594047, url, valid)

proc call*(call_594048: Call_ReplicaSetsListByResourceGroup_594040;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          domainServiceName: string): Recallable =
  ## replicaSetsListByResourceGroup
  ## The List ReplicaSets in Resource Group operation lists all the domain services available under the given resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   domainServiceName: string (required)
  ##                    : The name of the domain service.
  var path_594049 = newJObject()
  var query_594050 = newJObject()
  add(path_594049, "resourceGroupName", newJString(resourceGroupName))
  add(query_594050, "api-version", newJString(apiVersion))
  add(path_594049, "subscriptionId", newJString(subscriptionId))
  add(path_594049, "domainServiceName", newJString(domainServiceName))
  result = call_594048.call(path_594049, query_594050, nil, nil, nil)

var replicaSetsListByResourceGroup* = Call_ReplicaSetsListByResourceGroup_594040(
    name: "replicaSetsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AAD/domainServices/{domainServiceName}/replicaSets",
    validator: validate_ReplicaSetsListByResourceGroup_594041, base: "",
    url: url_ReplicaSetsListByResourceGroup_594042, schemes: {Scheme.Https})
type
  Call_ReplicaSetsCreateOrUpdate_594063 = ref object of OpenApiRestCall_593424
proc url_ReplicaSetsCreateOrUpdate_594065(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "domainServiceName" in path,
        "`domainServiceName` is a required path parameter"
  assert "replicaSetName" in path, "`replicaSetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.AAD/domainServices/"),
               (kind: VariableSegment, value: "domainServiceName"),
               (kind: ConstantSegment, value: "/replicaSets/"),
               (kind: VariableSegment, value: "replicaSetName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicaSetsCreateOrUpdate_594064(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The Create ReplicaSet operation creates a new domain service with the specified parameters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   replicaSetName: JString (required)
  ##                 : The name of the replica set.
  ##   domainServiceName: JString (required)
  ##                    : The name of the domain service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594066 = path.getOrDefault("resourceGroupName")
  valid_594066 = validateParameter(valid_594066, JString, required = true,
                                 default = nil)
  if valid_594066 != nil:
    section.add "resourceGroupName", valid_594066
  var valid_594067 = path.getOrDefault("subscriptionId")
  valid_594067 = validateParameter(valid_594067, JString, required = true,
                                 default = nil)
  if valid_594067 != nil:
    section.add "subscriptionId", valid_594067
  var valid_594068 = path.getOrDefault("replicaSetName")
  valid_594068 = validateParameter(valid_594068, JString, required = true,
                                 default = nil)
  if valid_594068 != nil:
    section.add "replicaSetName", valid_594068
  var valid_594069 = path.getOrDefault("domainServiceName")
  valid_594069 = validateParameter(valid_594069, JString, required = true,
                                 default = nil)
  if valid_594069 != nil:
    section.add "domainServiceName", valid_594069
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594070 = query.getOrDefault("api-version")
  valid_594070 = validateParameter(valid_594070, JString, required = true,
                                 default = nil)
  if valid_594070 != nil:
    section.add "api-version", valid_594070
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   replicaSet: JObject (required)
  ##             : Properties supplied to the Create ReplicaSet operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594072: Call_ReplicaSetsCreateOrUpdate_594063; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Create ReplicaSet operation creates a new domain service with the specified parameters.
  ## 
  let valid = call_594072.validator(path, query, header, formData, body)
  let scheme = call_594072.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594072.url(scheme.get, call_594072.host, call_594072.base,
                         call_594072.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594072, url, valid)

proc call*(call_594073: Call_ReplicaSetsCreateOrUpdate_594063;
          resourceGroupName: string; apiVersion: string; replicaSet: JsonNode;
          subscriptionId: string; replicaSetName: string; domainServiceName: string): Recallable =
  ## replicaSetsCreateOrUpdate
  ## The Create ReplicaSet operation creates a new domain service with the specified parameters.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   replicaSet: JObject (required)
  ##             : Properties supplied to the Create ReplicaSet operation.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   replicaSetName: string (required)
  ##                 : The name of the replica set.
  ##   domainServiceName: string (required)
  ##                    : The name of the domain service.
  var path_594074 = newJObject()
  var query_594075 = newJObject()
  var body_594076 = newJObject()
  add(path_594074, "resourceGroupName", newJString(resourceGroupName))
  add(query_594075, "api-version", newJString(apiVersion))
  if replicaSet != nil:
    body_594076 = replicaSet
  add(path_594074, "subscriptionId", newJString(subscriptionId))
  add(path_594074, "replicaSetName", newJString(replicaSetName))
  add(path_594074, "domainServiceName", newJString(domainServiceName))
  result = call_594073.call(path_594074, query_594075, nil, nil, body_594076)

var replicaSetsCreateOrUpdate* = Call_ReplicaSetsCreateOrUpdate_594063(
    name: "replicaSetsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AAD/domainServices/{domainServiceName}/replicaSets/{replicaSetName}",
    validator: validate_ReplicaSetsCreateOrUpdate_594064, base: "",
    url: url_ReplicaSetsCreateOrUpdate_594065, schemes: {Scheme.Https})
type
  Call_ReplicaSetsGet_594051 = ref object of OpenApiRestCall_593424
proc url_ReplicaSetsGet_594053(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "domainServiceName" in path,
        "`domainServiceName` is a required path parameter"
  assert "replicaSetName" in path, "`replicaSetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.AAD/domainServices/"),
               (kind: VariableSegment, value: "domainServiceName"),
               (kind: ConstantSegment, value: "/replicaSets/"),
               (kind: VariableSegment, value: "replicaSetName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicaSetsGet_594052(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## The Get ReplicaSet operation retrieves a json representation of the ReplicaSet.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   replicaSetName: JString (required)
  ##                 : The name of the replica set.
  ##   domainServiceName: JString (required)
  ##                    : The name of the domain service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594054 = path.getOrDefault("resourceGroupName")
  valid_594054 = validateParameter(valid_594054, JString, required = true,
                                 default = nil)
  if valid_594054 != nil:
    section.add "resourceGroupName", valid_594054
  var valid_594055 = path.getOrDefault("subscriptionId")
  valid_594055 = validateParameter(valid_594055, JString, required = true,
                                 default = nil)
  if valid_594055 != nil:
    section.add "subscriptionId", valid_594055
  var valid_594056 = path.getOrDefault("replicaSetName")
  valid_594056 = validateParameter(valid_594056, JString, required = true,
                                 default = nil)
  if valid_594056 != nil:
    section.add "replicaSetName", valid_594056
  var valid_594057 = path.getOrDefault("domainServiceName")
  valid_594057 = validateParameter(valid_594057, JString, required = true,
                                 default = nil)
  if valid_594057 != nil:
    section.add "domainServiceName", valid_594057
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
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
  if body != nil:
    result.add "body", body

proc call*(call_594059: Call_ReplicaSetsGet_594051; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get ReplicaSet operation retrieves a json representation of the ReplicaSet.
  ## 
  let valid = call_594059.validator(path, query, header, formData, body)
  let scheme = call_594059.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594059.url(scheme.get, call_594059.host, call_594059.base,
                         call_594059.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594059, url, valid)

proc call*(call_594060: Call_ReplicaSetsGet_594051; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; replicaSetName: string;
          domainServiceName: string): Recallable =
  ## replicaSetsGet
  ## The Get ReplicaSet operation retrieves a json representation of the ReplicaSet.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   replicaSetName: string (required)
  ##                 : The name of the replica set.
  ##   domainServiceName: string (required)
  ##                    : The name of the domain service.
  var path_594061 = newJObject()
  var query_594062 = newJObject()
  add(path_594061, "resourceGroupName", newJString(resourceGroupName))
  add(query_594062, "api-version", newJString(apiVersion))
  add(path_594061, "subscriptionId", newJString(subscriptionId))
  add(path_594061, "replicaSetName", newJString(replicaSetName))
  add(path_594061, "domainServiceName", newJString(domainServiceName))
  result = call_594060.call(path_594061, query_594062, nil, nil, nil)

var replicaSetsGet* = Call_ReplicaSetsGet_594051(name: "replicaSetsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AAD/domainServices/{domainServiceName}/replicaSets/{replicaSetName}",
    validator: validate_ReplicaSetsGet_594052, base: "", url: url_ReplicaSetsGet_594053,
    schemes: {Scheme.Https})
type
  Call_ReplicaSetsUpdate_594089 = ref object of OpenApiRestCall_593424
proc url_ReplicaSetsUpdate_594091(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "domainServiceName" in path,
        "`domainServiceName` is a required path parameter"
  assert "replicaSetName" in path, "`replicaSetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.AAD/domainServices/"),
               (kind: VariableSegment, value: "domainServiceName"),
               (kind: ConstantSegment, value: "/replicaSets/"),
               (kind: VariableSegment, value: "replicaSetName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicaSetsUpdate_594090(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## The Update ReplicaSet operation can be used to update the existing deployment. The update call only supports the properties listed in the PATCH body.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   replicaSetName: JString (required)
  ##                 : The name of the replica set.
  ##   domainServiceName: JString (required)
  ##                    : The name of the domain service.
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
  var valid_594094 = path.getOrDefault("replicaSetName")
  valid_594094 = validateParameter(valid_594094, JString, required = true,
                                 default = nil)
  if valid_594094 != nil:
    section.add "replicaSetName", valid_594094
  var valid_594095 = path.getOrDefault("domainServiceName")
  valid_594095 = validateParameter(valid_594095, JString, required = true,
                                 default = nil)
  if valid_594095 != nil:
    section.add "domainServiceName", valid_594095
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594096 = query.getOrDefault("api-version")
  valid_594096 = validateParameter(valid_594096, JString, required = true,
                                 default = nil)
  if valid_594096 != nil:
    section.add "api-version", valid_594096
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   replicaSet: JObject (required)
  ##             : Properties supplied to the Update a ReplicaSet operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594098: Call_ReplicaSetsUpdate_594089; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Update ReplicaSet operation can be used to update the existing deployment. The update call only supports the properties listed in the PATCH body.
  ## 
  let valid = call_594098.validator(path, query, header, formData, body)
  let scheme = call_594098.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594098.url(scheme.get, call_594098.host, call_594098.base,
                         call_594098.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594098, url, valid)

proc call*(call_594099: Call_ReplicaSetsUpdate_594089; resourceGroupName: string;
          apiVersion: string; replicaSet: JsonNode; subscriptionId: string;
          replicaSetName: string; domainServiceName: string): Recallable =
  ## replicaSetsUpdate
  ## The Update ReplicaSet operation can be used to update the existing deployment. The update call only supports the properties listed in the PATCH body.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   replicaSet: JObject (required)
  ##             : Properties supplied to the Update a ReplicaSet operation.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   replicaSetName: string (required)
  ##                 : The name of the replica set.
  ##   domainServiceName: string (required)
  ##                    : The name of the domain service.
  var path_594100 = newJObject()
  var query_594101 = newJObject()
  var body_594102 = newJObject()
  add(path_594100, "resourceGroupName", newJString(resourceGroupName))
  add(query_594101, "api-version", newJString(apiVersion))
  if replicaSet != nil:
    body_594102 = replicaSet
  add(path_594100, "subscriptionId", newJString(subscriptionId))
  add(path_594100, "replicaSetName", newJString(replicaSetName))
  add(path_594100, "domainServiceName", newJString(domainServiceName))
  result = call_594099.call(path_594100, query_594101, nil, nil, body_594102)

var replicaSetsUpdate* = Call_ReplicaSetsUpdate_594089(name: "replicaSetsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AAD/domainServices/{domainServiceName}/replicaSets/{replicaSetName}",
    validator: validate_ReplicaSetsUpdate_594090, base: "",
    url: url_ReplicaSetsUpdate_594091, schemes: {Scheme.Https})
type
  Call_ReplicaSetsDelete_594077 = ref object of OpenApiRestCall_593424
proc url_ReplicaSetsDelete_594079(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "domainServiceName" in path,
        "`domainServiceName` is a required path parameter"
  assert "replicaSetName" in path, "`replicaSetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.AAD/domainServices/"),
               (kind: VariableSegment, value: "domainServiceName"),
               (kind: ConstantSegment, value: "/replicaSets/"),
               (kind: VariableSegment, value: "replicaSetName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicaSetsDelete_594078(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## The Delete ReplicaSet operation deletes an existing ReplicaSet.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   replicaSetName: JString (required)
  ##                 : The name of the replica set.
  ##   domainServiceName: JString (required)
  ##                    : The name of the domain service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594080 = path.getOrDefault("resourceGroupName")
  valid_594080 = validateParameter(valid_594080, JString, required = true,
                                 default = nil)
  if valid_594080 != nil:
    section.add "resourceGroupName", valid_594080
  var valid_594081 = path.getOrDefault("subscriptionId")
  valid_594081 = validateParameter(valid_594081, JString, required = true,
                                 default = nil)
  if valid_594081 != nil:
    section.add "subscriptionId", valid_594081
  var valid_594082 = path.getOrDefault("replicaSetName")
  valid_594082 = validateParameter(valid_594082, JString, required = true,
                                 default = nil)
  if valid_594082 != nil:
    section.add "replicaSetName", valid_594082
  var valid_594083 = path.getOrDefault("domainServiceName")
  valid_594083 = validateParameter(valid_594083, JString, required = true,
                                 default = nil)
  if valid_594083 != nil:
    section.add "domainServiceName", valid_594083
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
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

proc call*(call_594085: Call_ReplicaSetsDelete_594077; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Delete ReplicaSet operation deletes an existing ReplicaSet.
  ## 
  let valid = call_594085.validator(path, query, header, formData, body)
  let scheme = call_594085.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594085.url(scheme.get, call_594085.host, call_594085.base,
                         call_594085.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594085, url, valid)

proc call*(call_594086: Call_ReplicaSetsDelete_594077; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; replicaSetName: string;
          domainServiceName: string): Recallable =
  ## replicaSetsDelete
  ## The Delete ReplicaSet operation deletes an existing ReplicaSet.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   replicaSetName: string (required)
  ##                 : The name of the replica set.
  ##   domainServiceName: string (required)
  ##                    : The name of the domain service.
  var path_594087 = newJObject()
  var query_594088 = newJObject()
  add(path_594087, "resourceGroupName", newJString(resourceGroupName))
  add(query_594088, "api-version", newJString(apiVersion))
  add(path_594087, "subscriptionId", newJString(subscriptionId))
  add(path_594087, "replicaSetName", newJString(replicaSetName))
  add(path_594087, "domainServiceName", newJString(domainServiceName))
  result = call_594086.call(path_594087, query_594088, nil, nil, nil)

var replicaSetsDelete* = Call_ReplicaSetsDelete_594077(name: "replicaSetsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AAD/domainServices/{domainServiceName}/replicaSets/{replicaSetName}",
    validator: validate_ReplicaSetsDelete_594078, base: "",
    url: url_ReplicaSetsDelete_594079, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
