
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: InstanceMetadataClient
## version: 2018-10-01
## termsOfService: (not provided)
## license: (not provided)
## 
## The Azure Instance Metadata Client
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

  OpenApiRestCall_567641 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567641](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567641): Option[Scheme] {.used.} =
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
  macServiceName = "imds"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AttestedGetDocument_567863 = ref object of OpenApiRestCall_567641
proc url_AttestedGetDocument_567865(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AttestedGetDocument_567864(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Get Attested Data for the Virtual Machine.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : This is the API version to use.
  ##   nonce: JString
  ##        : This is a string of up to 32 random alphanumeric characters.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568037 = query.getOrDefault("api-version")
  valid_568037 = validateParameter(valid_568037, JString, required = true,
                                 default = newJString("2018-10-01"))
  if valid_568037 != nil:
    section.add "api-version", valid_568037
  var valid_568038 = query.getOrDefault("nonce")
  valid_568038 = validateParameter(valid_568038, JString, required = false,
                                 default = nil)
  if valid_568038 != nil:
    section.add "nonce", valid_568038
  result.add "query", section
  ## parameters in `header` object:
  ##   Metadata: JString (required)
  ##           : This must be set to 'true'.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `Metadata` field"
  var valid_568039 = header.getOrDefault("Metadata")
  valid_568039 = validateParameter(valid_568039, JString, required = true,
                                 default = newJString("true"))
  if valid_568039 != nil:
    section.add "Metadata", valid_568039
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568062: Call_AttestedGetDocument_567863; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get Attested Data for the Virtual Machine.
  ## 
  let valid = call_568062.validator(path, query, header, formData, body)
  let scheme = call_568062.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568062.url(scheme.get, call_568062.host, call_568062.base,
                         call_568062.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568062, url, valid)

proc call*(call_568133: Call_AttestedGetDocument_567863;
          apiVersion: string = "2018-10-01"; nonce: string = ""): Recallable =
  ## attestedGetDocument
  ## Get Attested Data for the Virtual Machine.
  ##   apiVersion: string (required)
  ##             : This is the API version to use.
  ##   nonce: string
  ##        : This is a string of up to 32 random alphanumeric characters.
  var query_568134 = newJObject()
  add(query_568134, "api-version", newJString(apiVersion))
  add(query_568134, "nonce", newJString(nonce))
  result = call_568133.call(nil, query_568134, nil, nil, nil)

var attestedGetDocument* = Call_AttestedGetDocument_567863(
    name: "attestedGetDocument", meth: HttpMethod.HttpGet, host: "169.254.169.254",
    route: "/attested/document", validator: validate_AttestedGetDocument_567864,
    base: "/metadata", url: url_AttestedGetDocument_567865, schemes: {Scheme.Https})
type
  Call_IdentityGetInfo_568174 = ref object of OpenApiRestCall_567641
proc url_IdentityGetInfo_568176(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_IdentityGetInfo_568175(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Get information about AAD Metadata
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : This is the API version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568177 = query.getOrDefault("api-version")
  valid_568177 = validateParameter(valid_568177, JString, required = true,
                                 default = newJString("2018-10-01"))
  if valid_568177 != nil:
    section.add "api-version", valid_568177
  result.add "query", section
  ## parameters in `header` object:
  ##   Metadata: JString (required)
  ##           : This must be set to 'true'.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `Metadata` field"
  var valid_568178 = header.getOrDefault("Metadata")
  valid_568178 = validateParameter(valid_568178, JString, required = true,
                                 default = newJString("true"))
  if valid_568178 != nil:
    section.add "Metadata", valid_568178
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568179: Call_IdentityGetInfo_568174; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get information about AAD Metadata
  ## 
  let valid = call_568179.validator(path, query, header, formData, body)
  let scheme = call_568179.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568179.url(scheme.get, call_568179.host, call_568179.base,
                         call_568179.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568179, url, valid)

proc call*(call_568180: Call_IdentityGetInfo_568174;
          apiVersion: string = "2018-10-01"): Recallable =
  ## identityGetInfo
  ## Get information about AAD Metadata
  ##   apiVersion: string (required)
  ##             : This is the API version to use.
  var query_568181 = newJObject()
  add(query_568181, "api-version", newJString(apiVersion))
  result = call_568180.call(nil, query_568181, nil, nil, nil)

var identityGetInfo* = Call_IdentityGetInfo_568174(name: "identityGetInfo",
    meth: HttpMethod.HttpGet, host: "169.254.169.254", route: "/identity/info",
    validator: validate_IdentityGetInfo_568175, base: "/metadata",
    url: url_IdentityGetInfo_568176, schemes: {Scheme.Https})
type
  Call_IdentityGetToken_568182 = ref object of OpenApiRestCall_567641
proc url_IdentityGetToken_568184(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_IdentityGetToken_568183(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Get a Token from Azure AD
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   object_id: JString
  ##            : This identifies, by Azure AD object id, a specific explicit identity to use when authenticating to Azure AD. Mutually exclusive with client_id and msi_res_id.
  ##   client_id: JString
  ##            : This identifies, by Azure AD client id, a specific explicit identity to use when authenticating to Azure AD. Mutually exclusive with object_id and msi_res_id.
  ##   api-version: JString (required)
  ##              : This is the API version to use.
  ##   resource: JString (required)
  ##           : This is the urlencoded identifier URI of the sink resource for the requested Azure AD token. The resulting token contains the corresponding aud for this resource.
  ##   bypass_cache: JString
  ##               : If provided, the value must be 'true'. This indicates to the server that the token must be retrieved from Azure AD and cannot be retrieved from an internal cache.
  ##   authority: JString
  ##            : This indicates the authority to request AAD tokens from. Defaults to the known authority of the identity to be used.
  ##   msi_res_id: JString
  ##             : This identifies, by urlencoded ARM resource id, a specific explicit identity to use when authenticating to Azure AD. Mutually exclusive with client_id and object_id.
  section = newJObject()
  var valid_568185 = query.getOrDefault("object_id")
  valid_568185 = validateParameter(valid_568185, JString, required = false,
                                 default = nil)
  if valid_568185 != nil:
    section.add "object_id", valid_568185
  var valid_568186 = query.getOrDefault("client_id")
  valid_568186 = validateParameter(valid_568186, JString, required = false,
                                 default = nil)
  if valid_568186 != nil:
    section.add "client_id", valid_568186
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568187 = query.getOrDefault("api-version")
  valid_568187 = validateParameter(valid_568187, JString, required = true,
                                 default = newJString("2018-10-01"))
  if valid_568187 != nil:
    section.add "api-version", valid_568187
  var valid_568188 = query.getOrDefault("resource")
  valid_568188 = validateParameter(valid_568188, JString, required = true,
                                 default = nil)
  if valid_568188 != nil:
    section.add "resource", valid_568188
  var valid_568189 = query.getOrDefault("bypass_cache")
  valid_568189 = validateParameter(valid_568189, JString, required = false,
                                 default = newJString("true"))
  if valid_568189 != nil:
    section.add "bypass_cache", valid_568189
  var valid_568190 = query.getOrDefault("authority")
  valid_568190 = validateParameter(valid_568190, JString, required = false,
                                 default = nil)
  if valid_568190 != nil:
    section.add "authority", valid_568190
  var valid_568191 = query.getOrDefault("msi_res_id")
  valid_568191 = validateParameter(valid_568191, JString, required = false,
                                 default = nil)
  if valid_568191 != nil:
    section.add "msi_res_id", valid_568191
  result.add "query", section
  ## parameters in `header` object:
  ##   Metadata: JString (required)
  ##           : This must be set to 'true'.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `Metadata` field"
  var valid_568192 = header.getOrDefault("Metadata")
  valid_568192 = validateParameter(valid_568192, JString, required = true,
                                 default = newJString("true"))
  if valid_568192 != nil:
    section.add "Metadata", valid_568192
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568193: Call_IdentityGetToken_568182; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a Token from Azure AD
  ## 
  let valid = call_568193.validator(path, query, header, formData, body)
  let scheme = call_568193.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568193.url(scheme.get, call_568193.host, call_568193.base,
                         call_568193.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568193, url, valid)

proc call*(call_568194: Call_IdentityGetToken_568182; resource: string;
          objectId: string = ""; clientId: string = "";
          apiVersion: string = "2018-10-01"; bypassCache: string = "true";
          authority: string = ""; msiResId: string = ""): Recallable =
  ## identityGetToken
  ## Get a Token from Azure AD
  ##   objectId: string
  ##           : This identifies, by Azure AD object id, a specific explicit identity to use when authenticating to Azure AD. Mutually exclusive with client_id and msi_res_id.
  ##   clientId: string
  ##           : This identifies, by Azure AD client id, a specific explicit identity to use when authenticating to Azure AD. Mutually exclusive with object_id and msi_res_id.
  ##   apiVersion: string (required)
  ##             : This is the API version to use.
  ##   resource: string (required)
  ##           : This is the urlencoded identifier URI of the sink resource for the requested Azure AD token. The resulting token contains the corresponding aud for this resource.
  ##   bypassCache: string
  ##              : If provided, the value must be 'true'. This indicates to the server that the token must be retrieved from Azure AD and cannot be retrieved from an internal cache.
  ##   authority: string
  ##            : This indicates the authority to request AAD tokens from. Defaults to the known authority of the identity to be used.
  ##   msiResId: string
  ##           : This identifies, by urlencoded ARM resource id, a specific explicit identity to use when authenticating to Azure AD. Mutually exclusive with client_id and object_id.
  var query_568195 = newJObject()
  add(query_568195, "object_id", newJString(objectId))
  add(query_568195, "client_id", newJString(clientId))
  add(query_568195, "api-version", newJString(apiVersion))
  add(query_568195, "resource", newJString(resource))
  add(query_568195, "bypass_cache", newJString(bypassCache))
  add(query_568195, "authority", newJString(authority))
  add(query_568195, "msi_res_id", newJString(msiResId))
  result = call_568194.call(nil, query_568195, nil, nil, nil)

var identityGetToken* = Call_IdentityGetToken_568182(name: "identityGetToken",
    meth: HttpMethod.HttpGet, host: "169.254.169.254",
    route: "/identity/oauth2/token", validator: validate_IdentityGetToken_568183,
    base: "/metadata", url: url_IdentityGetToken_568184, schemes: {Scheme.Https})
type
  Call_InstancesGetMetadata_568196 = ref object of OpenApiRestCall_567641
proc url_InstancesGetMetadata_568198(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_InstancesGetMetadata_568197(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get Instance Metadata for the Virtual Machine.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : This is the API version to use.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568199 = query.getOrDefault("api-version")
  valid_568199 = validateParameter(valid_568199, JString, required = true,
                                 default = newJString("2018-10-01"))
  if valid_568199 != nil:
    section.add "api-version", valid_568199
  result.add "query", section
  ## parameters in `header` object:
  ##   Metadata: JString (required)
  ##           : This must be set to 'true'.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `Metadata` field"
  var valid_568200 = header.getOrDefault("Metadata")
  valid_568200 = validateParameter(valid_568200, JString, required = true,
                                 default = newJString("true"))
  if valid_568200 != nil:
    section.add "Metadata", valid_568200
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568201: Call_InstancesGetMetadata_568196; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get Instance Metadata for the Virtual Machine.
  ## 
  let valid = call_568201.validator(path, query, header, formData, body)
  let scheme = call_568201.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568201.url(scheme.get, call_568201.host, call_568201.base,
                         call_568201.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568201, url, valid)

proc call*(call_568202: Call_InstancesGetMetadata_568196;
          apiVersion: string = "2018-10-01"): Recallable =
  ## instancesGetMetadata
  ## Get Instance Metadata for the Virtual Machine.
  ##   apiVersion: string (required)
  ##             : This is the API version to use.
  var query_568203 = newJObject()
  add(query_568203, "api-version", newJString(apiVersion))
  result = call_568202.call(nil, query_568203, nil, nil, nil)

var instancesGetMetadata* = Call_InstancesGetMetadata_568196(
    name: "instancesGetMetadata", meth: HttpMethod.HttpGet, host: "169.254.169.254",
    route: "/instance", validator: validate_InstancesGetMetadata_568197,
    base: "/metadata", url: url_InstancesGetMetadata_568198, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
