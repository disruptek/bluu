
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: ACE Provisioning ManagementPartner
## version: 2018-02-01
## termsOfService: (not provided)
## license: (not provided)
## 
## This API describe ACE Provisioning ManagementPartner
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
  macServiceName = "managementpartner-ManagementPartner"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationList_567879 = ref object of OpenApiRestCall_567657
proc url_OperationList_567881(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationList_567880(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## List all the operations.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Supported version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568040 = query.getOrDefault("api-version")
  valid_568040 = validateParameter(valid_568040, JString, required = true,
                                 default = nil)
  if valid_568040 != nil:
    section.add "api-version", valid_568040
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568063: Call_OperationList_567879; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all the operations.
  ## 
  let valid = call_568063.validator(path, query, header, formData, body)
  let scheme = call_568063.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568063.url(scheme.get, call_568063.host, call_568063.base,
                         call_568063.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568063, url, valid)

proc call*(call_568134: Call_OperationList_567879; apiVersion: string): Recallable =
  ## operationList
  ## List all the operations.
  ##   apiVersion: string (required)
  ##             : Supported version.
  var query_568135 = newJObject()
  add(query_568135, "api-version", newJString(apiVersion))
  result = call_568134.call(nil, query_568135, nil, nil, nil)

var operationList* = Call_OperationList_567879(name: "operationList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.ManagementPartner/operations",
    validator: validate_OperationList_567880, base: "", url: url_OperationList_567881,
    schemes: {Scheme.Https})
type
  Call_PartnersGet_568175 = ref object of OpenApiRestCall_567657
proc url_PartnersGet_568177(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_PartnersGet_568176(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the management partner using the objectId and tenantId.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Supported version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568178 = query.getOrDefault("api-version")
  valid_568178 = validateParameter(valid_568178, JString, required = true,
                                 default = nil)
  if valid_568178 != nil:
    section.add "api-version", valid_568178
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568179: Call_PartnersGet_568175; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the management partner using the objectId and tenantId.
  ## 
  let valid = call_568179.validator(path, query, header, formData, body)
  let scheme = call_568179.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568179.url(scheme.get, call_568179.host, call_568179.base,
                         call_568179.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568179, url, valid)

proc call*(call_568180: Call_PartnersGet_568175; apiVersion: string): Recallable =
  ## partnersGet
  ## Get the management partner using the objectId and tenantId.
  ##   apiVersion: string (required)
  ##             : Supported version.
  var query_568181 = newJObject()
  add(query_568181, "api-version", newJString(apiVersion))
  result = call_568180.call(nil, query_568181, nil, nil, nil)

var partnersGet* = Call_PartnersGet_568175(name: "partnersGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/providers/Microsoft.ManagementPartner/partners",
                                        validator: validate_PartnersGet_568176,
                                        base: "", url: url_PartnersGet_568177,
                                        schemes: {Scheme.Https})
type
  Call_PartnerCreate_568205 = ref object of OpenApiRestCall_567657
proc url_PartnerCreate_568207(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "partnerId" in path, "`partnerId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.ManagementPartner/partners/"),
               (kind: VariableSegment, value: "partnerId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PartnerCreate_568206(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a management partner for the objectId and tenantId.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   partnerId: JString (required)
  ##            : Id of the Partner
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `partnerId` field"
  var valid_568208 = path.getOrDefault("partnerId")
  valid_568208 = validateParameter(valid_568208, JString, required = true,
                                 default = nil)
  if valid_568208 != nil:
    section.add "partnerId", valid_568208
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Supported version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568209 = query.getOrDefault("api-version")
  valid_568209 = validateParameter(valid_568209, JString, required = true,
                                 default = nil)
  if valid_568209 != nil:
    section.add "api-version", valid_568209
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568210: Call_PartnerCreate_568205; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a management partner for the objectId and tenantId.
  ## 
  let valid = call_568210.validator(path, query, header, formData, body)
  let scheme = call_568210.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568210.url(scheme.get, call_568210.host, call_568210.base,
                         call_568210.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568210, url, valid)

proc call*(call_568211: Call_PartnerCreate_568205; apiVersion: string;
          partnerId: string): Recallable =
  ## partnerCreate
  ## Create a management partner for the objectId and tenantId.
  ##   apiVersion: string (required)
  ##             : Supported version.
  ##   partnerId: string (required)
  ##            : Id of the Partner
  var path_568212 = newJObject()
  var query_568213 = newJObject()
  add(query_568213, "api-version", newJString(apiVersion))
  add(path_568212, "partnerId", newJString(partnerId))
  result = call_568211.call(path_568212, query_568213, nil, nil, nil)

var partnerCreate* = Call_PartnerCreate_568205(name: "partnerCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com",
    route: "/providers/Microsoft.ManagementPartner/partners/{partnerId}",
    validator: validate_PartnerCreate_568206, base: "", url: url_PartnerCreate_568207,
    schemes: {Scheme.Https})
type
  Call_PartnerGet_568182 = ref object of OpenApiRestCall_567657
proc url_PartnerGet_568184(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "partnerId" in path, "`partnerId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.ManagementPartner/partners/"),
               (kind: VariableSegment, value: "partnerId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PartnerGet_568183(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the management partner using the partnerId, objectId and tenantId.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   partnerId: JString (required)
  ##            : Id of the Partner
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `partnerId` field"
  var valid_568199 = path.getOrDefault("partnerId")
  valid_568199 = validateParameter(valid_568199, JString, required = true,
                                 default = nil)
  if valid_568199 != nil:
    section.add "partnerId", valid_568199
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Supported version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568200 = query.getOrDefault("api-version")
  valid_568200 = validateParameter(valid_568200, JString, required = true,
                                 default = nil)
  if valid_568200 != nil:
    section.add "api-version", valid_568200
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568201: Call_PartnerGet_568182; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the management partner using the partnerId, objectId and tenantId.
  ## 
  let valid = call_568201.validator(path, query, header, formData, body)
  let scheme = call_568201.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568201.url(scheme.get, call_568201.host, call_568201.base,
                         call_568201.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568201, url, valid)

proc call*(call_568202: Call_PartnerGet_568182; apiVersion: string; partnerId: string): Recallable =
  ## partnerGet
  ## Get the management partner using the partnerId, objectId and tenantId.
  ##   apiVersion: string (required)
  ##             : Supported version.
  ##   partnerId: string (required)
  ##            : Id of the Partner
  var path_568203 = newJObject()
  var query_568204 = newJObject()
  add(query_568204, "api-version", newJString(apiVersion))
  add(path_568203, "partnerId", newJString(partnerId))
  result = call_568202.call(path_568203, query_568204, nil, nil, nil)

var partnerGet* = Call_PartnerGet_568182(name: "partnerGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/providers/Microsoft.ManagementPartner/partners/{partnerId}",
                                      validator: validate_PartnerGet_568183,
                                      base: "", url: url_PartnerGet_568184,
                                      schemes: {Scheme.Https})
type
  Call_PartnerUpdate_568223 = ref object of OpenApiRestCall_567657
proc url_PartnerUpdate_568225(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "partnerId" in path, "`partnerId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.ManagementPartner/partners/"),
               (kind: VariableSegment, value: "partnerId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PartnerUpdate_568224(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Update the management partner for the objectId and tenantId.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   partnerId: JString (required)
  ##            : Id of the Partner
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `partnerId` field"
  var valid_568226 = path.getOrDefault("partnerId")
  valid_568226 = validateParameter(valid_568226, JString, required = true,
                                 default = nil)
  if valid_568226 != nil:
    section.add "partnerId", valid_568226
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Supported version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568227 = query.getOrDefault("api-version")
  valid_568227 = validateParameter(valid_568227, JString, required = true,
                                 default = nil)
  if valid_568227 != nil:
    section.add "api-version", valid_568227
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568228: Call_PartnerUpdate_568223; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update the management partner for the objectId and tenantId.
  ## 
  let valid = call_568228.validator(path, query, header, formData, body)
  let scheme = call_568228.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568228.url(scheme.get, call_568228.host, call_568228.base,
                         call_568228.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568228, url, valid)

proc call*(call_568229: Call_PartnerUpdate_568223; apiVersion: string;
          partnerId: string): Recallable =
  ## partnerUpdate
  ## Update the management partner for the objectId and tenantId.
  ##   apiVersion: string (required)
  ##             : Supported version.
  ##   partnerId: string (required)
  ##            : Id of the Partner
  var path_568230 = newJObject()
  var query_568231 = newJObject()
  add(query_568231, "api-version", newJString(apiVersion))
  add(path_568230, "partnerId", newJString(partnerId))
  result = call_568229.call(path_568230, query_568231, nil, nil, nil)

var partnerUpdate* = Call_PartnerUpdate_568223(name: "partnerUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com",
    route: "/providers/Microsoft.ManagementPartner/partners/{partnerId}",
    validator: validate_PartnerUpdate_568224, base: "", url: url_PartnerUpdate_568225,
    schemes: {Scheme.Https})
type
  Call_PartnerDelete_568214 = ref object of OpenApiRestCall_567657
proc url_PartnerDelete_568216(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "partnerId" in path, "`partnerId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.ManagementPartner/partners/"),
               (kind: VariableSegment, value: "partnerId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PartnerDelete_568215(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete the management partner for the objectId and tenantId.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   partnerId: JString (required)
  ##            : Id of the Partner
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `partnerId` field"
  var valid_568217 = path.getOrDefault("partnerId")
  valid_568217 = validateParameter(valid_568217, JString, required = true,
                                 default = nil)
  if valid_568217 != nil:
    section.add "partnerId", valid_568217
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Supported version.
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

proc call*(call_568219: Call_PartnerDelete_568214; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete the management partner for the objectId and tenantId.
  ## 
  let valid = call_568219.validator(path, query, header, formData, body)
  let scheme = call_568219.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568219.url(scheme.get, call_568219.host, call_568219.base,
                         call_568219.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568219, url, valid)

proc call*(call_568220: Call_PartnerDelete_568214; apiVersion: string;
          partnerId: string): Recallable =
  ## partnerDelete
  ## Delete the management partner for the objectId and tenantId.
  ##   apiVersion: string (required)
  ##             : Supported version.
  ##   partnerId: string (required)
  ##            : Id of the Partner
  var path_568221 = newJObject()
  var query_568222 = newJObject()
  add(query_568222, "api-version", newJString(apiVersion))
  add(path_568221, "partnerId", newJString(partnerId))
  result = call_568220.call(path_568221, query_568222, nil, nil, nil)

var partnerDelete* = Call_PartnerDelete_568214(name: "partnerDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com",
    route: "/providers/Microsoft.ManagementPartner/partners/{partnerId}",
    validator: validate_PartnerDelete_568215, base: "", url: url_PartnerDelete_568216,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
