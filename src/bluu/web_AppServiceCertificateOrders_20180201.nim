
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: AppServiceCertificateOrders API Client
## version: 2018-02-01
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

  OpenApiRestCall_567657 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567657](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567657): Option[Scheme] {.used.} =
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
  macServiceName = "web-AppServiceCertificateOrders"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AppServiceCertificateOrdersList_567879 = ref object of OpenApiRestCall_567657
proc url_AppServiceCertificateOrdersList_567881(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.CertificateRegistration/certificateOrders")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceCertificateOrdersList_567880(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all certificate orders in a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568054 = path.getOrDefault("subscriptionId")
  valid_568054 = validateParameter(valid_568054, JString, required = true,
                                 default = nil)
  if valid_568054 != nil:
    section.add "subscriptionId", valid_568054
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568055 = query.getOrDefault("api-version")
  valid_568055 = validateParameter(valid_568055, JString, required = true,
                                 default = nil)
  if valid_568055 != nil:
    section.add "api-version", valid_568055
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568078: Call_AppServiceCertificateOrdersList_567879;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all certificate orders in a subscription.
  ## 
  let valid = call_568078.validator(path, query, header, formData, body)
  let scheme = call_568078.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568078.url(scheme.get, call_568078.host, call_568078.base,
                         call_568078.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568078, url, valid)

proc call*(call_568149: Call_AppServiceCertificateOrdersList_567879;
          apiVersion: string; subscriptionId: string): Recallable =
  ## appServiceCertificateOrdersList
  ## List all certificate orders in a subscription.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_568150 = newJObject()
  var query_568152 = newJObject()
  add(query_568152, "api-version", newJString(apiVersion))
  add(path_568150, "subscriptionId", newJString(subscriptionId))
  result = call_568149.call(path_568150, query_568152, nil, nil, nil)

var appServiceCertificateOrdersList* = Call_AppServiceCertificateOrdersList_567879(
    name: "appServiceCertificateOrdersList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.CertificateRegistration/certificateOrders",
    validator: validate_AppServiceCertificateOrdersList_567880, base: "",
    url: url_AppServiceCertificateOrdersList_567881, schemes: {Scheme.Https})
type
  Call_AppServiceCertificateOrdersValidatePurchaseInformation_568191 = ref object of OpenApiRestCall_567657
proc url_AppServiceCertificateOrdersValidatePurchaseInformation_568193(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.CertificateRegistration/validateCertificateRegistrationInformation")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceCertificateOrdersValidatePurchaseInformation_568192(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Validate information for a certificate order.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568194 = path.getOrDefault("subscriptionId")
  valid_568194 = validateParameter(valid_568194, JString, required = true,
                                 default = nil)
  if valid_568194 != nil:
    section.add "subscriptionId", valid_568194
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568195 = query.getOrDefault("api-version")
  valid_568195 = validateParameter(valid_568195, JString, required = true,
                                 default = nil)
  if valid_568195 != nil:
    section.add "api-version", valid_568195
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   appServiceCertificateOrder: JObject (required)
  ##                             : Information for a certificate order.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568197: Call_AppServiceCertificateOrdersValidatePurchaseInformation_568191;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Validate information for a certificate order.
  ## 
  let valid = call_568197.validator(path, query, header, formData, body)
  let scheme = call_568197.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568197.url(scheme.get, call_568197.host, call_568197.base,
                         call_568197.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568197, url, valid)

proc call*(call_568198: Call_AppServiceCertificateOrdersValidatePurchaseInformation_568191;
          apiVersion: string; subscriptionId: string;
          appServiceCertificateOrder: JsonNode): Recallable =
  ## appServiceCertificateOrdersValidatePurchaseInformation
  ## Validate information for a certificate order.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   appServiceCertificateOrder: JObject (required)
  ##                             : Information for a certificate order.
  var path_568199 = newJObject()
  var query_568200 = newJObject()
  var body_568201 = newJObject()
  add(query_568200, "api-version", newJString(apiVersion))
  add(path_568199, "subscriptionId", newJString(subscriptionId))
  if appServiceCertificateOrder != nil:
    body_568201 = appServiceCertificateOrder
  result = call_568198.call(path_568199, query_568200, nil, nil, body_568201)

var appServiceCertificateOrdersValidatePurchaseInformation* = Call_AppServiceCertificateOrdersValidatePurchaseInformation_568191(
    name: "appServiceCertificateOrdersValidatePurchaseInformation",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.CertificateRegistration/validateCertificateRegistrationInformation",
    validator: validate_AppServiceCertificateOrdersValidatePurchaseInformation_568192,
    base: "", url: url_AppServiceCertificateOrdersValidatePurchaseInformation_568193,
    schemes: {Scheme.Https})
type
  Call_AppServiceCertificateOrdersListByResourceGroup_568202 = ref object of OpenApiRestCall_567657
proc url_AppServiceCertificateOrdersListByResourceGroup_568204(protocol: Scheme;
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
        kind: ConstantSegment,
        value: "/providers/Microsoft.CertificateRegistration/certificateOrders")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceCertificateOrdersListByResourceGroup_568203(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Get certificate orders in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568205 = path.getOrDefault("resourceGroupName")
  valid_568205 = validateParameter(valid_568205, JString, required = true,
                                 default = nil)
  if valid_568205 != nil:
    section.add "resourceGroupName", valid_568205
  var valid_568206 = path.getOrDefault("subscriptionId")
  valid_568206 = validateParameter(valid_568206, JString, required = true,
                                 default = nil)
  if valid_568206 != nil:
    section.add "subscriptionId", valid_568206
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568207 = query.getOrDefault("api-version")
  valid_568207 = validateParameter(valid_568207, JString, required = true,
                                 default = nil)
  if valid_568207 != nil:
    section.add "api-version", valid_568207
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568208: Call_AppServiceCertificateOrdersListByResourceGroup_568202;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get certificate orders in a resource group.
  ## 
  let valid = call_568208.validator(path, query, header, formData, body)
  let scheme = call_568208.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568208.url(scheme.get, call_568208.host, call_568208.base,
                         call_568208.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568208, url, valid)

proc call*(call_568209: Call_AppServiceCertificateOrdersListByResourceGroup_568202;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## appServiceCertificateOrdersListByResourceGroup
  ## Get certificate orders in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_568210 = newJObject()
  var query_568211 = newJObject()
  add(path_568210, "resourceGroupName", newJString(resourceGroupName))
  add(query_568211, "api-version", newJString(apiVersion))
  add(path_568210, "subscriptionId", newJString(subscriptionId))
  result = call_568209.call(path_568210, query_568211, nil, nil, nil)

var appServiceCertificateOrdersListByResourceGroup* = Call_AppServiceCertificateOrdersListByResourceGroup_568202(
    name: "appServiceCertificateOrdersListByResourceGroup",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CertificateRegistration/certificateOrders",
    validator: validate_AppServiceCertificateOrdersListByResourceGroup_568203,
    base: "", url: url_AppServiceCertificateOrdersListByResourceGroup_568204,
    schemes: {Scheme.Https})
type
  Call_AppServiceCertificateOrdersCreateOrUpdate_568223 = ref object of OpenApiRestCall_567657
proc url_AppServiceCertificateOrdersCreateOrUpdate_568225(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "certificateOrderName" in path,
        "`certificateOrderName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.CertificateRegistration/certificateOrders/"),
               (kind: VariableSegment, value: "certificateOrderName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceCertificateOrdersCreateOrUpdate_568224(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update a certificate purchase order.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   certificateOrderName: JString (required)
  ##                       : Name of the certificate order.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `certificateOrderName` field"
  var valid_568226 = path.getOrDefault("certificateOrderName")
  valid_568226 = validateParameter(valid_568226, JString, required = true,
                                 default = nil)
  if valid_568226 != nil:
    section.add "certificateOrderName", valid_568226
  var valid_568227 = path.getOrDefault("resourceGroupName")
  valid_568227 = validateParameter(valid_568227, JString, required = true,
                                 default = nil)
  if valid_568227 != nil:
    section.add "resourceGroupName", valid_568227
  var valid_568228 = path.getOrDefault("subscriptionId")
  valid_568228 = validateParameter(valid_568228, JString, required = true,
                                 default = nil)
  if valid_568228 != nil:
    section.add "subscriptionId", valid_568228
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568229 = query.getOrDefault("api-version")
  valid_568229 = validateParameter(valid_568229, JString, required = true,
                                 default = nil)
  if valid_568229 != nil:
    section.add "api-version", valid_568229
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   certificateDistinguishedName: JObject (required)
  ##                               : Distinguished name to use for the certificate order.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568231: Call_AppServiceCertificateOrdersCreateOrUpdate_568223;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update a certificate purchase order.
  ## 
  let valid = call_568231.validator(path, query, header, formData, body)
  let scheme = call_568231.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568231.url(scheme.get, call_568231.host, call_568231.base,
                         call_568231.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568231, url, valid)

proc call*(call_568232: Call_AppServiceCertificateOrdersCreateOrUpdate_568223;
          certificateOrderName: string; resourceGroupName: string;
          apiVersion: string; subscriptionId: string;
          certificateDistinguishedName: JsonNode): Recallable =
  ## appServiceCertificateOrdersCreateOrUpdate
  ## Create or update a certificate purchase order.
  ##   certificateOrderName: string (required)
  ##                       : Name of the certificate order.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   certificateDistinguishedName: JObject (required)
  ##                               : Distinguished name to use for the certificate order.
  var path_568233 = newJObject()
  var query_568234 = newJObject()
  var body_568235 = newJObject()
  add(path_568233, "certificateOrderName", newJString(certificateOrderName))
  add(path_568233, "resourceGroupName", newJString(resourceGroupName))
  add(query_568234, "api-version", newJString(apiVersion))
  add(path_568233, "subscriptionId", newJString(subscriptionId))
  if certificateDistinguishedName != nil:
    body_568235 = certificateDistinguishedName
  result = call_568232.call(path_568233, query_568234, nil, nil, body_568235)

var appServiceCertificateOrdersCreateOrUpdate* = Call_AppServiceCertificateOrdersCreateOrUpdate_568223(
    name: "appServiceCertificateOrdersCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CertificateRegistration/certificateOrders/{certificateOrderName}",
    validator: validate_AppServiceCertificateOrdersCreateOrUpdate_568224,
    base: "", url: url_AppServiceCertificateOrdersCreateOrUpdate_568225,
    schemes: {Scheme.Https})
type
  Call_AppServiceCertificateOrdersGet_568212 = ref object of OpenApiRestCall_567657
proc url_AppServiceCertificateOrdersGet_568214(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "certificateOrderName" in path,
        "`certificateOrderName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.CertificateRegistration/certificateOrders/"),
               (kind: VariableSegment, value: "certificateOrderName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceCertificateOrdersGet_568213(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a certificate order.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   certificateOrderName: JString (required)
  ##                       : Name of the certificate order..
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `certificateOrderName` field"
  var valid_568215 = path.getOrDefault("certificateOrderName")
  valid_568215 = validateParameter(valid_568215, JString, required = true,
                                 default = nil)
  if valid_568215 != nil:
    section.add "certificateOrderName", valid_568215
  var valid_568216 = path.getOrDefault("resourceGroupName")
  valid_568216 = validateParameter(valid_568216, JString, required = true,
                                 default = nil)
  if valid_568216 != nil:
    section.add "resourceGroupName", valid_568216
  var valid_568217 = path.getOrDefault("subscriptionId")
  valid_568217 = validateParameter(valid_568217, JString, required = true,
                                 default = nil)
  if valid_568217 != nil:
    section.add "subscriptionId", valid_568217
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568218 = query.getOrDefault("api-version")
  valid_568218 = validateParameter(valid_568218, JString, required = true,
                                 default = nil)
  if valid_568218 != nil:
    section.add "api-version", valid_568218
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568219: Call_AppServiceCertificateOrdersGet_568212; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a certificate order.
  ## 
  let valid = call_568219.validator(path, query, header, formData, body)
  let scheme = call_568219.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568219.url(scheme.get, call_568219.host, call_568219.base,
                         call_568219.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568219, url, valid)

proc call*(call_568220: Call_AppServiceCertificateOrdersGet_568212;
          certificateOrderName: string; resourceGroupName: string;
          apiVersion: string; subscriptionId: string): Recallable =
  ## appServiceCertificateOrdersGet
  ## Get a certificate order.
  ##   certificateOrderName: string (required)
  ##                       : Name of the certificate order..
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_568221 = newJObject()
  var query_568222 = newJObject()
  add(path_568221, "certificateOrderName", newJString(certificateOrderName))
  add(path_568221, "resourceGroupName", newJString(resourceGroupName))
  add(query_568222, "api-version", newJString(apiVersion))
  add(path_568221, "subscriptionId", newJString(subscriptionId))
  result = call_568220.call(path_568221, query_568222, nil, nil, nil)

var appServiceCertificateOrdersGet* = Call_AppServiceCertificateOrdersGet_568212(
    name: "appServiceCertificateOrdersGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CertificateRegistration/certificateOrders/{certificateOrderName}",
    validator: validate_AppServiceCertificateOrdersGet_568213, base: "",
    url: url_AppServiceCertificateOrdersGet_568214, schemes: {Scheme.Https})
type
  Call_AppServiceCertificateOrdersUpdate_568247 = ref object of OpenApiRestCall_567657
proc url_AppServiceCertificateOrdersUpdate_568249(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "certificateOrderName" in path,
        "`certificateOrderName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.CertificateRegistration/certificateOrders/"),
               (kind: VariableSegment, value: "certificateOrderName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceCertificateOrdersUpdate_568248(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update a certificate purchase order.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   certificateOrderName: JString (required)
  ##                       : Name of the certificate order.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `certificateOrderName` field"
  var valid_568250 = path.getOrDefault("certificateOrderName")
  valid_568250 = validateParameter(valid_568250, JString, required = true,
                                 default = nil)
  if valid_568250 != nil:
    section.add "certificateOrderName", valid_568250
  var valid_568251 = path.getOrDefault("resourceGroupName")
  valid_568251 = validateParameter(valid_568251, JString, required = true,
                                 default = nil)
  if valid_568251 != nil:
    section.add "resourceGroupName", valid_568251
  var valid_568252 = path.getOrDefault("subscriptionId")
  valid_568252 = validateParameter(valid_568252, JString, required = true,
                                 default = nil)
  if valid_568252 != nil:
    section.add "subscriptionId", valid_568252
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568253 = query.getOrDefault("api-version")
  valid_568253 = validateParameter(valid_568253, JString, required = true,
                                 default = nil)
  if valid_568253 != nil:
    section.add "api-version", valid_568253
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   certificateDistinguishedName: JObject (required)
  ##                               : Distinguished name to use for the certificate order.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568255: Call_AppServiceCertificateOrdersUpdate_568247;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update a certificate purchase order.
  ## 
  let valid = call_568255.validator(path, query, header, formData, body)
  let scheme = call_568255.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568255.url(scheme.get, call_568255.host, call_568255.base,
                         call_568255.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568255, url, valid)

proc call*(call_568256: Call_AppServiceCertificateOrdersUpdate_568247;
          certificateOrderName: string; resourceGroupName: string;
          apiVersion: string; subscriptionId: string;
          certificateDistinguishedName: JsonNode): Recallable =
  ## appServiceCertificateOrdersUpdate
  ## Create or update a certificate purchase order.
  ##   certificateOrderName: string (required)
  ##                       : Name of the certificate order.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   certificateDistinguishedName: JObject (required)
  ##                               : Distinguished name to use for the certificate order.
  var path_568257 = newJObject()
  var query_568258 = newJObject()
  var body_568259 = newJObject()
  add(path_568257, "certificateOrderName", newJString(certificateOrderName))
  add(path_568257, "resourceGroupName", newJString(resourceGroupName))
  add(query_568258, "api-version", newJString(apiVersion))
  add(path_568257, "subscriptionId", newJString(subscriptionId))
  if certificateDistinguishedName != nil:
    body_568259 = certificateDistinguishedName
  result = call_568256.call(path_568257, query_568258, nil, nil, body_568259)

var appServiceCertificateOrdersUpdate* = Call_AppServiceCertificateOrdersUpdate_568247(
    name: "appServiceCertificateOrdersUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CertificateRegistration/certificateOrders/{certificateOrderName}",
    validator: validate_AppServiceCertificateOrdersUpdate_568248, base: "",
    url: url_AppServiceCertificateOrdersUpdate_568249, schemes: {Scheme.Https})
type
  Call_AppServiceCertificateOrdersDelete_568236 = ref object of OpenApiRestCall_567657
proc url_AppServiceCertificateOrdersDelete_568238(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "certificateOrderName" in path,
        "`certificateOrderName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.CertificateRegistration/certificateOrders/"),
               (kind: VariableSegment, value: "certificateOrderName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceCertificateOrdersDelete_568237(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete an existing certificate order.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   certificateOrderName: JString (required)
  ##                       : Name of the certificate order.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `certificateOrderName` field"
  var valid_568239 = path.getOrDefault("certificateOrderName")
  valid_568239 = validateParameter(valid_568239, JString, required = true,
                                 default = nil)
  if valid_568239 != nil:
    section.add "certificateOrderName", valid_568239
  var valid_568240 = path.getOrDefault("resourceGroupName")
  valid_568240 = validateParameter(valid_568240, JString, required = true,
                                 default = nil)
  if valid_568240 != nil:
    section.add "resourceGroupName", valid_568240
  var valid_568241 = path.getOrDefault("subscriptionId")
  valid_568241 = validateParameter(valid_568241, JString, required = true,
                                 default = nil)
  if valid_568241 != nil:
    section.add "subscriptionId", valid_568241
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568242 = query.getOrDefault("api-version")
  valid_568242 = validateParameter(valid_568242, JString, required = true,
                                 default = nil)
  if valid_568242 != nil:
    section.add "api-version", valid_568242
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568243: Call_AppServiceCertificateOrdersDelete_568236;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete an existing certificate order.
  ## 
  let valid = call_568243.validator(path, query, header, formData, body)
  let scheme = call_568243.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568243.url(scheme.get, call_568243.host, call_568243.base,
                         call_568243.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568243, url, valid)

proc call*(call_568244: Call_AppServiceCertificateOrdersDelete_568236;
          certificateOrderName: string; resourceGroupName: string;
          apiVersion: string; subscriptionId: string): Recallable =
  ## appServiceCertificateOrdersDelete
  ## Delete an existing certificate order.
  ##   certificateOrderName: string (required)
  ##                       : Name of the certificate order.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_568245 = newJObject()
  var query_568246 = newJObject()
  add(path_568245, "certificateOrderName", newJString(certificateOrderName))
  add(path_568245, "resourceGroupName", newJString(resourceGroupName))
  add(query_568246, "api-version", newJString(apiVersion))
  add(path_568245, "subscriptionId", newJString(subscriptionId))
  result = call_568244.call(path_568245, query_568246, nil, nil, nil)

var appServiceCertificateOrdersDelete* = Call_AppServiceCertificateOrdersDelete_568236(
    name: "appServiceCertificateOrdersDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CertificateRegistration/certificateOrders/{certificateOrderName}",
    validator: validate_AppServiceCertificateOrdersDelete_568237, base: "",
    url: url_AppServiceCertificateOrdersDelete_568238, schemes: {Scheme.Https})
type
  Call_AppServiceCertificateOrdersListCertificates_568260 = ref object of OpenApiRestCall_567657
proc url_AppServiceCertificateOrdersListCertificates_568262(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "certificateOrderName" in path,
        "`certificateOrderName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.CertificateRegistration/certificateOrders/"),
               (kind: VariableSegment, value: "certificateOrderName"),
               (kind: ConstantSegment, value: "/certificates")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceCertificateOrdersListCertificates_568261(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all certificates associated with a certificate order.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   certificateOrderName: JString (required)
  ##                       : Name of the certificate order.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `certificateOrderName` field"
  var valid_568263 = path.getOrDefault("certificateOrderName")
  valid_568263 = validateParameter(valid_568263, JString, required = true,
                                 default = nil)
  if valid_568263 != nil:
    section.add "certificateOrderName", valid_568263
  var valid_568264 = path.getOrDefault("resourceGroupName")
  valid_568264 = validateParameter(valid_568264, JString, required = true,
                                 default = nil)
  if valid_568264 != nil:
    section.add "resourceGroupName", valid_568264
  var valid_568265 = path.getOrDefault("subscriptionId")
  valid_568265 = validateParameter(valid_568265, JString, required = true,
                                 default = nil)
  if valid_568265 != nil:
    section.add "subscriptionId", valid_568265
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568266 = query.getOrDefault("api-version")
  valid_568266 = validateParameter(valid_568266, JString, required = true,
                                 default = nil)
  if valid_568266 != nil:
    section.add "api-version", valid_568266
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568267: Call_AppServiceCertificateOrdersListCertificates_568260;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all certificates associated with a certificate order.
  ## 
  let valid = call_568267.validator(path, query, header, formData, body)
  let scheme = call_568267.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568267.url(scheme.get, call_568267.host, call_568267.base,
                         call_568267.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568267, url, valid)

proc call*(call_568268: Call_AppServiceCertificateOrdersListCertificates_568260;
          certificateOrderName: string; resourceGroupName: string;
          apiVersion: string; subscriptionId: string): Recallable =
  ## appServiceCertificateOrdersListCertificates
  ## List all certificates associated with a certificate order.
  ##   certificateOrderName: string (required)
  ##                       : Name of the certificate order.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_568269 = newJObject()
  var query_568270 = newJObject()
  add(path_568269, "certificateOrderName", newJString(certificateOrderName))
  add(path_568269, "resourceGroupName", newJString(resourceGroupName))
  add(query_568270, "api-version", newJString(apiVersion))
  add(path_568269, "subscriptionId", newJString(subscriptionId))
  result = call_568268.call(path_568269, query_568270, nil, nil, nil)

var appServiceCertificateOrdersListCertificates* = Call_AppServiceCertificateOrdersListCertificates_568260(
    name: "appServiceCertificateOrdersListCertificates", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CertificateRegistration/certificateOrders/{certificateOrderName}/certificates",
    validator: validate_AppServiceCertificateOrdersListCertificates_568261,
    base: "", url: url_AppServiceCertificateOrdersListCertificates_568262,
    schemes: {Scheme.Https})
type
  Call_AppServiceCertificateOrdersCreateOrUpdateCertificate_568283 = ref object of OpenApiRestCall_567657
proc url_AppServiceCertificateOrdersCreateOrUpdateCertificate_568285(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "certificateOrderName" in path,
        "`certificateOrderName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.CertificateRegistration/certificateOrders/"),
               (kind: VariableSegment, value: "certificateOrderName"),
               (kind: ConstantSegment, value: "/certificates/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceCertificateOrdersCreateOrUpdateCertificate_568284(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates or updates a certificate and associates with key vault secret.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   certificateOrderName: JString (required)
  ##                       : Name of the certificate order.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the certificate.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `certificateOrderName` field"
  var valid_568286 = path.getOrDefault("certificateOrderName")
  valid_568286 = validateParameter(valid_568286, JString, required = true,
                                 default = nil)
  if valid_568286 != nil:
    section.add "certificateOrderName", valid_568286
  var valid_568287 = path.getOrDefault("resourceGroupName")
  valid_568287 = validateParameter(valid_568287, JString, required = true,
                                 default = nil)
  if valid_568287 != nil:
    section.add "resourceGroupName", valid_568287
  var valid_568288 = path.getOrDefault("name")
  valid_568288 = validateParameter(valid_568288, JString, required = true,
                                 default = nil)
  if valid_568288 != nil:
    section.add "name", valid_568288
  var valid_568289 = path.getOrDefault("subscriptionId")
  valid_568289 = validateParameter(valid_568289, JString, required = true,
                                 default = nil)
  if valid_568289 != nil:
    section.add "subscriptionId", valid_568289
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568290 = query.getOrDefault("api-version")
  valid_568290 = validateParameter(valid_568290, JString, required = true,
                                 default = nil)
  if valid_568290 != nil:
    section.add "api-version", valid_568290
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   keyVaultCertificate: JObject (required)
  ##                      : Key vault certificate resource Id.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568292: Call_AppServiceCertificateOrdersCreateOrUpdateCertificate_568283;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a certificate and associates with key vault secret.
  ## 
  let valid = call_568292.validator(path, query, header, formData, body)
  let scheme = call_568292.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568292.url(scheme.get, call_568292.host, call_568292.base,
                         call_568292.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568292, url, valid)

proc call*(call_568293: Call_AppServiceCertificateOrdersCreateOrUpdateCertificate_568283;
          certificateOrderName: string; resourceGroupName: string;
          apiVersion: string; name: string; keyVaultCertificate: JsonNode;
          subscriptionId: string): Recallable =
  ## appServiceCertificateOrdersCreateOrUpdateCertificate
  ## Creates or updates a certificate and associates with key vault secret.
  ##   certificateOrderName: string (required)
  ##                       : Name of the certificate order.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the certificate.
  ##   keyVaultCertificate: JObject (required)
  ##                      : Key vault certificate resource Id.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_568294 = newJObject()
  var query_568295 = newJObject()
  var body_568296 = newJObject()
  add(path_568294, "certificateOrderName", newJString(certificateOrderName))
  add(path_568294, "resourceGroupName", newJString(resourceGroupName))
  add(query_568295, "api-version", newJString(apiVersion))
  add(path_568294, "name", newJString(name))
  if keyVaultCertificate != nil:
    body_568296 = keyVaultCertificate
  add(path_568294, "subscriptionId", newJString(subscriptionId))
  result = call_568293.call(path_568294, query_568295, nil, nil, body_568296)

var appServiceCertificateOrdersCreateOrUpdateCertificate* = Call_AppServiceCertificateOrdersCreateOrUpdateCertificate_568283(
    name: "appServiceCertificateOrdersCreateOrUpdateCertificate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CertificateRegistration/certificateOrders/{certificateOrderName}/certificates/{name}",
    validator: validate_AppServiceCertificateOrdersCreateOrUpdateCertificate_568284,
    base: "", url: url_AppServiceCertificateOrdersCreateOrUpdateCertificate_568285,
    schemes: {Scheme.Https})
type
  Call_AppServiceCertificateOrdersGetCertificate_568271 = ref object of OpenApiRestCall_567657
proc url_AppServiceCertificateOrdersGetCertificate_568273(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "certificateOrderName" in path,
        "`certificateOrderName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.CertificateRegistration/certificateOrders/"),
               (kind: VariableSegment, value: "certificateOrderName"),
               (kind: ConstantSegment, value: "/certificates/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceCertificateOrdersGetCertificate_568272(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the certificate associated with a certificate order.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   certificateOrderName: JString (required)
  ##                       : Name of the certificate order.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the certificate.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `certificateOrderName` field"
  var valid_568274 = path.getOrDefault("certificateOrderName")
  valid_568274 = validateParameter(valid_568274, JString, required = true,
                                 default = nil)
  if valid_568274 != nil:
    section.add "certificateOrderName", valid_568274
  var valid_568275 = path.getOrDefault("resourceGroupName")
  valid_568275 = validateParameter(valid_568275, JString, required = true,
                                 default = nil)
  if valid_568275 != nil:
    section.add "resourceGroupName", valid_568275
  var valid_568276 = path.getOrDefault("name")
  valid_568276 = validateParameter(valid_568276, JString, required = true,
                                 default = nil)
  if valid_568276 != nil:
    section.add "name", valid_568276
  var valid_568277 = path.getOrDefault("subscriptionId")
  valid_568277 = validateParameter(valid_568277, JString, required = true,
                                 default = nil)
  if valid_568277 != nil:
    section.add "subscriptionId", valid_568277
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568278 = query.getOrDefault("api-version")
  valid_568278 = validateParameter(valid_568278, JString, required = true,
                                 default = nil)
  if valid_568278 != nil:
    section.add "api-version", valid_568278
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568279: Call_AppServiceCertificateOrdersGetCertificate_568271;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the certificate associated with a certificate order.
  ## 
  let valid = call_568279.validator(path, query, header, formData, body)
  let scheme = call_568279.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568279.url(scheme.get, call_568279.host, call_568279.base,
                         call_568279.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568279, url, valid)

proc call*(call_568280: Call_AppServiceCertificateOrdersGetCertificate_568271;
          certificateOrderName: string; resourceGroupName: string;
          apiVersion: string; name: string; subscriptionId: string): Recallable =
  ## appServiceCertificateOrdersGetCertificate
  ## Get the certificate associated with a certificate order.
  ##   certificateOrderName: string (required)
  ##                       : Name of the certificate order.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the certificate.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_568281 = newJObject()
  var query_568282 = newJObject()
  add(path_568281, "certificateOrderName", newJString(certificateOrderName))
  add(path_568281, "resourceGroupName", newJString(resourceGroupName))
  add(query_568282, "api-version", newJString(apiVersion))
  add(path_568281, "name", newJString(name))
  add(path_568281, "subscriptionId", newJString(subscriptionId))
  result = call_568280.call(path_568281, query_568282, nil, nil, nil)

var appServiceCertificateOrdersGetCertificate* = Call_AppServiceCertificateOrdersGetCertificate_568271(
    name: "appServiceCertificateOrdersGetCertificate", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CertificateRegistration/certificateOrders/{certificateOrderName}/certificates/{name}",
    validator: validate_AppServiceCertificateOrdersGetCertificate_568272,
    base: "", url: url_AppServiceCertificateOrdersGetCertificate_568273,
    schemes: {Scheme.Https})
type
  Call_AppServiceCertificateOrdersUpdateCertificate_568309 = ref object of OpenApiRestCall_567657
proc url_AppServiceCertificateOrdersUpdateCertificate_568311(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "certificateOrderName" in path,
        "`certificateOrderName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.CertificateRegistration/certificateOrders/"),
               (kind: VariableSegment, value: "certificateOrderName"),
               (kind: ConstantSegment, value: "/certificates/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceCertificateOrdersUpdateCertificate_568310(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a certificate and associates with key vault secret.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   certificateOrderName: JString (required)
  ##                       : Name of the certificate order.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the certificate.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `certificateOrderName` field"
  var valid_568312 = path.getOrDefault("certificateOrderName")
  valid_568312 = validateParameter(valid_568312, JString, required = true,
                                 default = nil)
  if valid_568312 != nil:
    section.add "certificateOrderName", valid_568312
  var valid_568313 = path.getOrDefault("resourceGroupName")
  valid_568313 = validateParameter(valid_568313, JString, required = true,
                                 default = nil)
  if valid_568313 != nil:
    section.add "resourceGroupName", valid_568313
  var valid_568314 = path.getOrDefault("name")
  valid_568314 = validateParameter(valid_568314, JString, required = true,
                                 default = nil)
  if valid_568314 != nil:
    section.add "name", valid_568314
  var valid_568315 = path.getOrDefault("subscriptionId")
  valid_568315 = validateParameter(valid_568315, JString, required = true,
                                 default = nil)
  if valid_568315 != nil:
    section.add "subscriptionId", valid_568315
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568316 = query.getOrDefault("api-version")
  valid_568316 = validateParameter(valid_568316, JString, required = true,
                                 default = nil)
  if valid_568316 != nil:
    section.add "api-version", valid_568316
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   keyVaultCertificate: JObject (required)
  ##                      : Key vault certificate resource Id.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568318: Call_AppServiceCertificateOrdersUpdateCertificate_568309;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a certificate and associates with key vault secret.
  ## 
  let valid = call_568318.validator(path, query, header, formData, body)
  let scheme = call_568318.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568318.url(scheme.get, call_568318.host, call_568318.base,
                         call_568318.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568318, url, valid)

proc call*(call_568319: Call_AppServiceCertificateOrdersUpdateCertificate_568309;
          certificateOrderName: string; resourceGroupName: string;
          apiVersion: string; name: string; keyVaultCertificate: JsonNode;
          subscriptionId: string): Recallable =
  ## appServiceCertificateOrdersUpdateCertificate
  ## Creates or updates a certificate and associates with key vault secret.
  ##   certificateOrderName: string (required)
  ##                       : Name of the certificate order.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the certificate.
  ##   keyVaultCertificate: JObject (required)
  ##                      : Key vault certificate resource Id.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_568320 = newJObject()
  var query_568321 = newJObject()
  var body_568322 = newJObject()
  add(path_568320, "certificateOrderName", newJString(certificateOrderName))
  add(path_568320, "resourceGroupName", newJString(resourceGroupName))
  add(query_568321, "api-version", newJString(apiVersion))
  add(path_568320, "name", newJString(name))
  if keyVaultCertificate != nil:
    body_568322 = keyVaultCertificate
  add(path_568320, "subscriptionId", newJString(subscriptionId))
  result = call_568319.call(path_568320, query_568321, nil, nil, body_568322)

var appServiceCertificateOrdersUpdateCertificate* = Call_AppServiceCertificateOrdersUpdateCertificate_568309(
    name: "appServiceCertificateOrdersUpdateCertificate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CertificateRegistration/certificateOrders/{certificateOrderName}/certificates/{name}",
    validator: validate_AppServiceCertificateOrdersUpdateCertificate_568310,
    base: "", url: url_AppServiceCertificateOrdersUpdateCertificate_568311,
    schemes: {Scheme.Https})
type
  Call_AppServiceCertificateOrdersDeleteCertificate_568297 = ref object of OpenApiRestCall_567657
proc url_AppServiceCertificateOrdersDeleteCertificate_568299(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "certificateOrderName" in path,
        "`certificateOrderName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.CertificateRegistration/certificateOrders/"),
               (kind: VariableSegment, value: "certificateOrderName"),
               (kind: ConstantSegment, value: "/certificates/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceCertificateOrdersDeleteCertificate_568298(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete the certificate associated with a certificate order.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   certificateOrderName: JString (required)
  ##                       : Name of the certificate order.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the certificate.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `certificateOrderName` field"
  var valid_568300 = path.getOrDefault("certificateOrderName")
  valid_568300 = validateParameter(valid_568300, JString, required = true,
                                 default = nil)
  if valid_568300 != nil:
    section.add "certificateOrderName", valid_568300
  var valid_568301 = path.getOrDefault("resourceGroupName")
  valid_568301 = validateParameter(valid_568301, JString, required = true,
                                 default = nil)
  if valid_568301 != nil:
    section.add "resourceGroupName", valid_568301
  var valid_568302 = path.getOrDefault("name")
  valid_568302 = validateParameter(valid_568302, JString, required = true,
                                 default = nil)
  if valid_568302 != nil:
    section.add "name", valid_568302
  var valid_568303 = path.getOrDefault("subscriptionId")
  valid_568303 = validateParameter(valid_568303, JString, required = true,
                                 default = nil)
  if valid_568303 != nil:
    section.add "subscriptionId", valid_568303
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568304 = query.getOrDefault("api-version")
  valid_568304 = validateParameter(valid_568304, JString, required = true,
                                 default = nil)
  if valid_568304 != nil:
    section.add "api-version", valid_568304
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568305: Call_AppServiceCertificateOrdersDeleteCertificate_568297;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete the certificate associated with a certificate order.
  ## 
  let valid = call_568305.validator(path, query, header, formData, body)
  let scheme = call_568305.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568305.url(scheme.get, call_568305.host, call_568305.base,
                         call_568305.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568305, url, valid)

proc call*(call_568306: Call_AppServiceCertificateOrdersDeleteCertificate_568297;
          certificateOrderName: string; resourceGroupName: string;
          apiVersion: string; name: string; subscriptionId: string): Recallable =
  ## appServiceCertificateOrdersDeleteCertificate
  ## Delete the certificate associated with a certificate order.
  ##   certificateOrderName: string (required)
  ##                       : Name of the certificate order.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the certificate.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_568307 = newJObject()
  var query_568308 = newJObject()
  add(path_568307, "certificateOrderName", newJString(certificateOrderName))
  add(path_568307, "resourceGroupName", newJString(resourceGroupName))
  add(query_568308, "api-version", newJString(apiVersion))
  add(path_568307, "name", newJString(name))
  add(path_568307, "subscriptionId", newJString(subscriptionId))
  result = call_568306.call(path_568307, query_568308, nil, nil, nil)

var appServiceCertificateOrdersDeleteCertificate* = Call_AppServiceCertificateOrdersDeleteCertificate_568297(
    name: "appServiceCertificateOrdersDeleteCertificate",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CertificateRegistration/certificateOrders/{certificateOrderName}/certificates/{name}",
    validator: validate_AppServiceCertificateOrdersDeleteCertificate_568298,
    base: "", url: url_AppServiceCertificateOrdersDeleteCertificate_568299,
    schemes: {Scheme.Https})
type
  Call_AppServiceCertificateOrdersReissue_568323 = ref object of OpenApiRestCall_567657
proc url_AppServiceCertificateOrdersReissue_568325(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "certificateOrderName" in path,
        "`certificateOrderName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.CertificateRegistration/certificateOrders/"),
               (kind: VariableSegment, value: "certificateOrderName"),
               (kind: ConstantSegment, value: "/reissue")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceCertificateOrdersReissue_568324(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Reissue an existing certificate order.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   certificateOrderName: JString (required)
  ##                       : Name of the certificate order.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `certificateOrderName` field"
  var valid_568326 = path.getOrDefault("certificateOrderName")
  valid_568326 = validateParameter(valid_568326, JString, required = true,
                                 default = nil)
  if valid_568326 != nil:
    section.add "certificateOrderName", valid_568326
  var valid_568327 = path.getOrDefault("resourceGroupName")
  valid_568327 = validateParameter(valid_568327, JString, required = true,
                                 default = nil)
  if valid_568327 != nil:
    section.add "resourceGroupName", valid_568327
  var valid_568328 = path.getOrDefault("subscriptionId")
  valid_568328 = validateParameter(valid_568328, JString, required = true,
                                 default = nil)
  if valid_568328 != nil:
    section.add "subscriptionId", valid_568328
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568329 = query.getOrDefault("api-version")
  valid_568329 = validateParameter(valid_568329, JString, required = true,
                                 default = nil)
  if valid_568329 != nil:
    section.add "api-version", valid_568329
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   reissueCertificateOrderRequest: JObject (required)
  ##                                 : Parameters for the reissue.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568331: Call_AppServiceCertificateOrdersReissue_568323;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Reissue an existing certificate order.
  ## 
  let valid = call_568331.validator(path, query, header, formData, body)
  let scheme = call_568331.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568331.url(scheme.get, call_568331.host, call_568331.base,
                         call_568331.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568331, url, valid)

proc call*(call_568332: Call_AppServiceCertificateOrdersReissue_568323;
          certificateOrderName: string; resourceGroupName: string;
          apiVersion: string; reissueCertificateOrderRequest: JsonNode;
          subscriptionId: string): Recallable =
  ## appServiceCertificateOrdersReissue
  ## Reissue an existing certificate order.
  ##   certificateOrderName: string (required)
  ##                       : Name of the certificate order.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   reissueCertificateOrderRequest: JObject (required)
  ##                                 : Parameters for the reissue.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_568333 = newJObject()
  var query_568334 = newJObject()
  var body_568335 = newJObject()
  add(path_568333, "certificateOrderName", newJString(certificateOrderName))
  add(path_568333, "resourceGroupName", newJString(resourceGroupName))
  add(query_568334, "api-version", newJString(apiVersion))
  if reissueCertificateOrderRequest != nil:
    body_568335 = reissueCertificateOrderRequest
  add(path_568333, "subscriptionId", newJString(subscriptionId))
  result = call_568332.call(path_568333, query_568334, nil, nil, body_568335)

var appServiceCertificateOrdersReissue* = Call_AppServiceCertificateOrdersReissue_568323(
    name: "appServiceCertificateOrdersReissue", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CertificateRegistration/certificateOrders/{certificateOrderName}/reissue",
    validator: validate_AppServiceCertificateOrdersReissue_568324, base: "",
    url: url_AppServiceCertificateOrdersReissue_568325, schemes: {Scheme.Https})
type
  Call_AppServiceCertificateOrdersRenew_568336 = ref object of OpenApiRestCall_567657
proc url_AppServiceCertificateOrdersRenew_568338(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "certificateOrderName" in path,
        "`certificateOrderName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.CertificateRegistration/certificateOrders/"),
               (kind: VariableSegment, value: "certificateOrderName"),
               (kind: ConstantSegment, value: "/renew")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceCertificateOrdersRenew_568337(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Renew an existing certificate order.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   certificateOrderName: JString (required)
  ##                       : Name of the certificate order.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `certificateOrderName` field"
  var valid_568339 = path.getOrDefault("certificateOrderName")
  valid_568339 = validateParameter(valid_568339, JString, required = true,
                                 default = nil)
  if valid_568339 != nil:
    section.add "certificateOrderName", valid_568339
  var valid_568340 = path.getOrDefault("resourceGroupName")
  valid_568340 = validateParameter(valid_568340, JString, required = true,
                                 default = nil)
  if valid_568340 != nil:
    section.add "resourceGroupName", valid_568340
  var valid_568341 = path.getOrDefault("subscriptionId")
  valid_568341 = validateParameter(valid_568341, JString, required = true,
                                 default = nil)
  if valid_568341 != nil:
    section.add "subscriptionId", valid_568341
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568342 = query.getOrDefault("api-version")
  valid_568342 = validateParameter(valid_568342, JString, required = true,
                                 default = nil)
  if valid_568342 != nil:
    section.add "api-version", valid_568342
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   renewCertificateOrderRequest: JObject (required)
  ##                               : Renew parameters
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568344: Call_AppServiceCertificateOrdersRenew_568336;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Renew an existing certificate order.
  ## 
  let valid = call_568344.validator(path, query, header, formData, body)
  let scheme = call_568344.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568344.url(scheme.get, call_568344.host, call_568344.base,
                         call_568344.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568344, url, valid)

proc call*(call_568345: Call_AppServiceCertificateOrdersRenew_568336;
          certificateOrderName: string; resourceGroupName: string;
          apiVersion: string; subscriptionId: string;
          renewCertificateOrderRequest: JsonNode): Recallable =
  ## appServiceCertificateOrdersRenew
  ## Renew an existing certificate order.
  ##   certificateOrderName: string (required)
  ##                       : Name of the certificate order.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   renewCertificateOrderRequest: JObject (required)
  ##                               : Renew parameters
  var path_568346 = newJObject()
  var query_568347 = newJObject()
  var body_568348 = newJObject()
  add(path_568346, "certificateOrderName", newJString(certificateOrderName))
  add(path_568346, "resourceGroupName", newJString(resourceGroupName))
  add(query_568347, "api-version", newJString(apiVersion))
  add(path_568346, "subscriptionId", newJString(subscriptionId))
  if renewCertificateOrderRequest != nil:
    body_568348 = renewCertificateOrderRequest
  result = call_568345.call(path_568346, query_568347, nil, nil, body_568348)

var appServiceCertificateOrdersRenew* = Call_AppServiceCertificateOrdersRenew_568336(
    name: "appServiceCertificateOrdersRenew", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CertificateRegistration/certificateOrders/{certificateOrderName}/renew",
    validator: validate_AppServiceCertificateOrdersRenew_568337, base: "",
    url: url_AppServiceCertificateOrdersRenew_568338, schemes: {Scheme.Https})
type
  Call_AppServiceCertificateOrdersResendEmail_568349 = ref object of OpenApiRestCall_567657
proc url_AppServiceCertificateOrdersResendEmail_568351(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "certificateOrderName" in path,
        "`certificateOrderName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.CertificateRegistration/certificateOrders/"),
               (kind: VariableSegment, value: "certificateOrderName"),
               (kind: ConstantSegment, value: "/resendEmail")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceCertificateOrdersResendEmail_568350(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Resend certificate email.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   certificateOrderName: JString (required)
  ##                       : Name of the certificate order.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `certificateOrderName` field"
  var valid_568352 = path.getOrDefault("certificateOrderName")
  valid_568352 = validateParameter(valid_568352, JString, required = true,
                                 default = nil)
  if valid_568352 != nil:
    section.add "certificateOrderName", valid_568352
  var valid_568353 = path.getOrDefault("resourceGroupName")
  valid_568353 = validateParameter(valid_568353, JString, required = true,
                                 default = nil)
  if valid_568353 != nil:
    section.add "resourceGroupName", valid_568353
  var valid_568354 = path.getOrDefault("subscriptionId")
  valid_568354 = validateParameter(valid_568354, JString, required = true,
                                 default = nil)
  if valid_568354 != nil:
    section.add "subscriptionId", valid_568354
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568355 = query.getOrDefault("api-version")
  valid_568355 = validateParameter(valid_568355, JString, required = true,
                                 default = nil)
  if valid_568355 != nil:
    section.add "api-version", valid_568355
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568356: Call_AppServiceCertificateOrdersResendEmail_568349;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Resend certificate email.
  ## 
  let valid = call_568356.validator(path, query, header, formData, body)
  let scheme = call_568356.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568356.url(scheme.get, call_568356.host, call_568356.base,
                         call_568356.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568356, url, valid)

proc call*(call_568357: Call_AppServiceCertificateOrdersResendEmail_568349;
          certificateOrderName: string; resourceGroupName: string;
          apiVersion: string; subscriptionId: string): Recallable =
  ## appServiceCertificateOrdersResendEmail
  ## Resend certificate email.
  ##   certificateOrderName: string (required)
  ##                       : Name of the certificate order.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_568358 = newJObject()
  var query_568359 = newJObject()
  add(path_568358, "certificateOrderName", newJString(certificateOrderName))
  add(path_568358, "resourceGroupName", newJString(resourceGroupName))
  add(query_568359, "api-version", newJString(apiVersion))
  add(path_568358, "subscriptionId", newJString(subscriptionId))
  result = call_568357.call(path_568358, query_568359, nil, nil, nil)

var appServiceCertificateOrdersResendEmail* = Call_AppServiceCertificateOrdersResendEmail_568349(
    name: "appServiceCertificateOrdersResendEmail", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CertificateRegistration/certificateOrders/{certificateOrderName}/resendEmail",
    validator: validate_AppServiceCertificateOrdersResendEmail_568350, base: "",
    url: url_AppServiceCertificateOrdersResendEmail_568351,
    schemes: {Scheme.Https})
type
  Call_AppServiceCertificateOrdersResendRequestEmails_568360 = ref object of OpenApiRestCall_567657
proc url_AppServiceCertificateOrdersResendRequestEmails_568362(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "certificateOrderName" in path,
        "`certificateOrderName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.CertificateRegistration/certificateOrders/"),
               (kind: VariableSegment, value: "certificateOrderName"),
               (kind: ConstantSegment, value: "/resendRequestEmails")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceCertificateOrdersResendRequestEmails_568361(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Verify domain ownership for this certificate order.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   certificateOrderName: JString (required)
  ##                       : Name of the certificate order.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `certificateOrderName` field"
  var valid_568363 = path.getOrDefault("certificateOrderName")
  valid_568363 = validateParameter(valid_568363, JString, required = true,
                                 default = nil)
  if valid_568363 != nil:
    section.add "certificateOrderName", valid_568363
  var valid_568364 = path.getOrDefault("resourceGroupName")
  valid_568364 = validateParameter(valid_568364, JString, required = true,
                                 default = nil)
  if valid_568364 != nil:
    section.add "resourceGroupName", valid_568364
  var valid_568365 = path.getOrDefault("subscriptionId")
  valid_568365 = validateParameter(valid_568365, JString, required = true,
                                 default = nil)
  if valid_568365 != nil:
    section.add "subscriptionId", valid_568365
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568366 = query.getOrDefault("api-version")
  valid_568366 = validateParameter(valid_568366, JString, required = true,
                                 default = nil)
  if valid_568366 != nil:
    section.add "api-version", valid_568366
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   nameIdentifier: JObject (required)
  ##                 : Email address
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568368: Call_AppServiceCertificateOrdersResendRequestEmails_568360;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Verify domain ownership for this certificate order.
  ## 
  let valid = call_568368.validator(path, query, header, formData, body)
  let scheme = call_568368.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568368.url(scheme.get, call_568368.host, call_568368.base,
                         call_568368.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568368, url, valid)

proc call*(call_568369: Call_AppServiceCertificateOrdersResendRequestEmails_568360;
          certificateOrderName: string; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; nameIdentifier: JsonNode): Recallable =
  ## appServiceCertificateOrdersResendRequestEmails
  ## Verify domain ownership for this certificate order.
  ##   certificateOrderName: string (required)
  ##                       : Name of the certificate order.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   nameIdentifier: JObject (required)
  ##                 : Email address
  var path_568370 = newJObject()
  var query_568371 = newJObject()
  var body_568372 = newJObject()
  add(path_568370, "certificateOrderName", newJString(certificateOrderName))
  add(path_568370, "resourceGroupName", newJString(resourceGroupName))
  add(query_568371, "api-version", newJString(apiVersion))
  add(path_568370, "subscriptionId", newJString(subscriptionId))
  if nameIdentifier != nil:
    body_568372 = nameIdentifier
  result = call_568369.call(path_568370, query_568371, nil, nil, body_568372)

var appServiceCertificateOrdersResendRequestEmails* = Call_AppServiceCertificateOrdersResendRequestEmails_568360(
    name: "appServiceCertificateOrdersResendRequestEmails",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CertificateRegistration/certificateOrders/{certificateOrderName}/resendRequestEmails",
    validator: validate_AppServiceCertificateOrdersResendRequestEmails_568361,
    base: "", url: url_AppServiceCertificateOrdersResendRequestEmails_568362,
    schemes: {Scheme.Https})
type
  Call_AppServiceCertificateOrdersRetrieveSiteSeal_568373 = ref object of OpenApiRestCall_567657
proc url_AppServiceCertificateOrdersRetrieveSiteSeal_568375(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "certificateOrderName" in path,
        "`certificateOrderName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.CertificateRegistration/certificateOrders/"),
               (kind: VariableSegment, value: "certificateOrderName"),
               (kind: ConstantSegment, value: "/retrieveSiteSeal")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceCertificateOrdersRetrieveSiteSeal_568374(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Verify domain ownership for this certificate order.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   certificateOrderName: JString (required)
  ##                       : Name of the certificate order.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `certificateOrderName` field"
  var valid_568376 = path.getOrDefault("certificateOrderName")
  valid_568376 = validateParameter(valid_568376, JString, required = true,
                                 default = nil)
  if valid_568376 != nil:
    section.add "certificateOrderName", valid_568376
  var valid_568377 = path.getOrDefault("resourceGroupName")
  valid_568377 = validateParameter(valid_568377, JString, required = true,
                                 default = nil)
  if valid_568377 != nil:
    section.add "resourceGroupName", valid_568377
  var valid_568378 = path.getOrDefault("subscriptionId")
  valid_568378 = validateParameter(valid_568378, JString, required = true,
                                 default = nil)
  if valid_568378 != nil:
    section.add "subscriptionId", valid_568378
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568379 = query.getOrDefault("api-version")
  valid_568379 = validateParameter(valid_568379, JString, required = true,
                                 default = nil)
  if valid_568379 != nil:
    section.add "api-version", valid_568379
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   siteSealRequest: JObject (required)
  ##                  : Site seal request.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568381: Call_AppServiceCertificateOrdersRetrieveSiteSeal_568373;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Verify domain ownership for this certificate order.
  ## 
  let valid = call_568381.validator(path, query, header, formData, body)
  let scheme = call_568381.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568381.url(scheme.get, call_568381.host, call_568381.base,
                         call_568381.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568381, url, valid)

proc call*(call_568382: Call_AppServiceCertificateOrdersRetrieveSiteSeal_568373;
          certificateOrderName: string; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; siteSealRequest: JsonNode): Recallable =
  ## appServiceCertificateOrdersRetrieveSiteSeal
  ## Verify domain ownership for this certificate order.
  ##   certificateOrderName: string (required)
  ##                       : Name of the certificate order.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  ##   siteSealRequest: JObject (required)
  ##                  : Site seal request.
  var path_568383 = newJObject()
  var query_568384 = newJObject()
  var body_568385 = newJObject()
  add(path_568383, "certificateOrderName", newJString(certificateOrderName))
  add(path_568383, "resourceGroupName", newJString(resourceGroupName))
  add(query_568384, "api-version", newJString(apiVersion))
  add(path_568383, "subscriptionId", newJString(subscriptionId))
  if siteSealRequest != nil:
    body_568385 = siteSealRequest
  result = call_568382.call(path_568383, query_568384, nil, nil, body_568385)

var appServiceCertificateOrdersRetrieveSiteSeal* = Call_AppServiceCertificateOrdersRetrieveSiteSeal_568373(
    name: "appServiceCertificateOrdersRetrieveSiteSeal",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CertificateRegistration/certificateOrders/{certificateOrderName}/retrieveSiteSeal",
    validator: validate_AppServiceCertificateOrdersRetrieveSiteSeal_568374,
    base: "", url: url_AppServiceCertificateOrdersRetrieveSiteSeal_568375,
    schemes: {Scheme.Https})
type
  Call_AppServiceCertificateOrdersVerifyDomainOwnership_568386 = ref object of OpenApiRestCall_567657
proc url_AppServiceCertificateOrdersVerifyDomainOwnership_568388(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "certificateOrderName" in path,
        "`certificateOrderName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.CertificateRegistration/certificateOrders/"),
               (kind: VariableSegment, value: "certificateOrderName"),
               (kind: ConstantSegment, value: "/verifyDomainOwnership")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceCertificateOrdersVerifyDomainOwnership_568387(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Verify domain ownership for this certificate order.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   certificateOrderName: JString (required)
  ##                       : Name of the certificate order.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `certificateOrderName` field"
  var valid_568389 = path.getOrDefault("certificateOrderName")
  valid_568389 = validateParameter(valid_568389, JString, required = true,
                                 default = nil)
  if valid_568389 != nil:
    section.add "certificateOrderName", valid_568389
  var valid_568390 = path.getOrDefault("resourceGroupName")
  valid_568390 = validateParameter(valid_568390, JString, required = true,
                                 default = nil)
  if valid_568390 != nil:
    section.add "resourceGroupName", valid_568390
  var valid_568391 = path.getOrDefault("subscriptionId")
  valid_568391 = validateParameter(valid_568391, JString, required = true,
                                 default = nil)
  if valid_568391 != nil:
    section.add "subscriptionId", valid_568391
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568392 = query.getOrDefault("api-version")
  valid_568392 = validateParameter(valid_568392, JString, required = true,
                                 default = nil)
  if valid_568392 != nil:
    section.add "api-version", valid_568392
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568393: Call_AppServiceCertificateOrdersVerifyDomainOwnership_568386;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Verify domain ownership for this certificate order.
  ## 
  let valid = call_568393.validator(path, query, header, formData, body)
  let scheme = call_568393.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568393.url(scheme.get, call_568393.host, call_568393.base,
                         call_568393.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568393, url, valid)

proc call*(call_568394: Call_AppServiceCertificateOrdersVerifyDomainOwnership_568386;
          certificateOrderName: string; resourceGroupName: string;
          apiVersion: string; subscriptionId: string): Recallable =
  ## appServiceCertificateOrdersVerifyDomainOwnership
  ## Verify domain ownership for this certificate order.
  ##   certificateOrderName: string (required)
  ##                       : Name of the certificate order.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_568395 = newJObject()
  var query_568396 = newJObject()
  add(path_568395, "certificateOrderName", newJString(certificateOrderName))
  add(path_568395, "resourceGroupName", newJString(resourceGroupName))
  add(query_568396, "api-version", newJString(apiVersion))
  add(path_568395, "subscriptionId", newJString(subscriptionId))
  result = call_568394.call(path_568395, query_568396, nil, nil, nil)

var appServiceCertificateOrdersVerifyDomainOwnership* = Call_AppServiceCertificateOrdersVerifyDomainOwnership_568386(
    name: "appServiceCertificateOrdersVerifyDomainOwnership",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CertificateRegistration/certificateOrders/{certificateOrderName}/verifyDomainOwnership",
    validator: validate_AppServiceCertificateOrdersVerifyDomainOwnership_568387,
    base: "", url: url_AppServiceCertificateOrdersVerifyDomainOwnership_568388,
    schemes: {Scheme.Https})
type
  Call_AppServiceCertificateOrdersRetrieveCertificateActions_568397 = ref object of OpenApiRestCall_567657
proc url_AppServiceCertificateOrdersRetrieveCertificateActions_568399(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.CertificateRegistration/certificateOrders/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/retrieveCertificateActions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceCertificateOrdersRetrieveCertificateActions_568398(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Retrieve the list of certificate actions.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the certificate order.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568400 = path.getOrDefault("resourceGroupName")
  valid_568400 = validateParameter(valid_568400, JString, required = true,
                                 default = nil)
  if valid_568400 != nil:
    section.add "resourceGroupName", valid_568400
  var valid_568401 = path.getOrDefault("name")
  valid_568401 = validateParameter(valid_568401, JString, required = true,
                                 default = nil)
  if valid_568401 != nil:
    section.add "name", valid_568401
  var valid_568402 = path.getOrDefault("subscriptionId")
  valid_568402 = validateParameter(valid_568402, JString, required = true,
                                 default = nil)
  if valid_568402 != nil:
    section.add "subscriptionId", valid_568402
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568403 = query.getOrDefault("api-version")
  valid_568403 = validateParameter(valid_568403, JString, required = true,
                                 default = nil)
  if valid_568403 != nil:
    section.add "api-version", valid_568403
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568404: Call_AppServiceCertificateOrdersRetrieveCertificateActions_568397;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieve the list of certificate actions.
  ## 
  let valid = call_568404.validator(path, query, header, formData, body)
  let scheme = call_568404.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568404.url(scheme.get, call_568404.host, call_568404.base,
                         call_568404.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568404, url, valid)

proc call*(call_568405: Call_AppServiceCertificateOrdersRetrieveCertificateActions_568397;
          resourceGroupName: string; apiVersion: string; name: string;
          subscriptionId: string): Recallable =
  ## appServiceCertificateOrdersRetrieveCertificateActions
  ## Retrieve the list of certificate actions.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the certificate order.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_568406 = newJObject()
  var query_568407 = newJObject()
  add(path_568406, "resourceGroupName", newJString(resourceGroupName))
  add(query_568407, "api-version", newJString(apiVersion))
  add(path_568406, "name", newJString(name))
  add(path_568406, "subscriptionId", newJString(subscriptionId))
  result = call_568405.call(path_568406, query_568407, nil, nil, nil)

var appServiceCertificateOrdersRetrieveCertificateActions* = Call_AppServiceCertificateOrdersRetrieveCertificateActions_568397(
    name: "appServiceCertificateOrdersRetrieveCertificateActions",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CertificateRegistration/certificateOrders/{name}/retrieveCertificateActions",
    validator: validate_AppServiceCertificateOrdersRetrieveCertificateActions_568398,
    base: "", url: url_AppServiceCertificateOrdersRetrieveCertificateActions_568399,
    schemes: {Scheme.Https})
type
  Call_AppServiceCertificateOrdersRetrieveCertificateEmailHistory_568408 = ref object of OpenApiRestCall_567657
proc url_AppServiceCertificateOrdersRetrieveCertificateEmailHistory_568410(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.CertificateRegistration/certificateOrders/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/retrieveEmailHistory")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppServiceCertificateOrdersRetrieveCertificateEmailHistory_568409(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Retrieve email history.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the certificate order.
  ##   subscriptionId: JString (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568411 = path.getOrDefault("resourceGroupName")
  valid_568411 = validateParameter(valid_568411, JString, required = true,
                                 default = nil)
  if valid_568411 != nil:
    section.add "resourceGroupName", valid_568411
  var valid_568412 = path.getOrDefault("name")
  valid_568412 = validateParameter(valid_568412, JString, required = true,
                                 default = nil)
  if valid_568412 != nil:
    section.add "name", valid_568412
  var valid_568413 = path.getOrDefault("subscriptionId")
  valid_568413 = validateParameter(valid_568413, JString, required = true,
                                 default = nil)
  if valid_568413 != nil:
    section.add "subscriptionId", valid_568413
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API Version
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568414 = query.getOrDefault("api-version")
  valid_568414 = validateParameter(valid_568414, JString, required = true,
                                 default = nil)
  if valid_568414 != nil:
    section.add "api-version", valid_568414
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568415: Call_AppServiceCertificateOrdersRetrieveCertificateEmailHistory_568408;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieve email history.
  ## 
  let valid = call_568415.validator(path, query, header, formData, body)
  let scheme = call_568415.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568415.url(scheme.get, call_568415.host, call_568415.base,
                         call_568415.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568415, url, valid)

proc call*(call_568416: Call_AppServiceCertificateOrdersRetrieveCertificateEmailHistory_568408;
          resourceGroupName: string; apiVersion: string; name: string;
          subscriptionId: string): Recallable =
  ## appServiceCertificateOrdersRetrieveCertificateEmailHistory
  ## Retrieve email history.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : API Version
  ##   name: string (required)
  ##       : Name of the certificate order.
  ##   subscriptionId: string (required)
  ##                 : Your Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000).
  var path_568417 = newJObject()
  var query_568418 = newJObject()
  add(path_568417, "resourceGroupName", newJString(resourceGroupName))
  add(query_568418, "api-version", newJString(apiVersion))
  add(path_568417, "name", newJString(name))
  add(path_568417, "subscriptionId", newJString(subscriptionId))
  result = call_568416.call(path_568417, query_568418, nil, nil, nil)

var appServiceCertificateOrdersRetrieveCertificateEmailHistory* = Call_AppServiceCertificateOrdersRetrieveCertificateEmailHistory_568408(
    name: "appServiceCertificateOrdersRetrieveCertificateEmailHistory",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CertificateRegistration/certificateOrders/{name}/retrieveEmailHistory", validator: validate_AppServiceCertificateOrdersRetrieveCertificateEmailHistory_568409,
    base: "", url: url_AppServiceCertificateOrdersRetrieveCertificateEmailHistory_568410,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
